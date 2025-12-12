"""
Root-level setup script for dotfiles installation.

Supports two environments:
- Digital Ocean: Full setup including user creation (with password/sudo), SSH hardening, firewall
- Lima: Full setup including user creation (no password/no sudo), SSH hardening, firewall, vault dir

Both environments share most hardening code. Key differences:
- Lima: adrien has NO sudo (security), NO password (SSH key only), has vault directory
- DO: adrien HAS sudo (admin needs), HAS password (interactive login), no vault directory
"""

import sys
import os
import subprocess
import shutil
import setup_utils
from termcolor import cprint
import getpass
import time
import tempfile
from passlib.hash import sha512_crypt


def setup_root():
    """These are the installation steps which should happen as root."""
    # Update package lists first (cloud images have stale cache)
    setup_utils.cached_run(
        "Updating package lists",
        ["sudo apt-get update"],
    )

    # Installing cc linker and compiler which cargo will need.
    setup_utils.cached_apt_install("build-essential")

    # Setup zsh
    setup_utils.cached_run(
        "Setting up zsh",
        [
            f"sudo {setup_utils.APT_INSTALL} -y zsh",
            "sudo chsh -s $(which zsh)",
        ],
    )

    # Install netstat
    setup_utils.cached_apt_install("net-tools")

    # Install fancy search tools
    setup_utils.cached_apt_install("ripgrep")
    setup_utils.cached_apt_install("fzf")
    setup_utils.cached_apt_install("fd-find")

    # Install zip and unzip
    setup_utils.cached_apt_install("zip")
    setup_utils.cached_apt_install("unzip")

    # Install lsd, a prettier ls
    setup_utils.cached_apt_install("lsd")

    # Installing nodejs v22 (for GitHub Copilot plugin)
    setup_utils.cached_run(
        "Installing nodejs",
        [
            "sudo apt-get purge -y nodejs",
            "curl -fsSL https://deb.nodesource.com/setup_22.x | sudo bash",
        ],
    )
    setup_utils.cached_apt_install("nodejs")

    # Installe bat, a prettier cat (quality of life)
    setup_utils.cached_apt_install("bat")

    # Install btop, a prettier resource monitor (quality of life)
    setup_utils.cached_apt_install("btop")

    # ZSH autosuggestions and highlighting (quality of life)
    setup_utils.cached_apt_install("zsh-autosuggestions")
    setup_utils.cached_apt_install("zsh-syntax-highlighting")

    # Install git lfs, which lets us download large files from git repos
    setup_utils.cached_apt_install("git-lfs")

    # Set the timezone properly
    setup_utils.cached_run(
        "Setting timezone",
        [
            "sudo timedatectl set-timezone America/Los_Angeles",
        ],
    )

    # Neovim is installed as user via AppImage in setup_dotfiles.py

    # I nice TUI for GIT - need to test thi
    arch_suffix = "Linux_arm64" if setup_utils.machine_is_arm64() else "Linux_x86_64"
    setup_utils.cached_run(
        "Installing lazygit",
        [
            r"""curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')_"""
            + arch_suffix
            + """.tar.gz" """,
            "tar xf lazygit.tar.gz lazygit",
            "sudo install lazygit /usr/local/bin",
        ],
    )

    # Server hardening (shared between Lima and DO, with env-specific differences)
    setup_hardening()


def setup_hardening():
    """Harden the server for both Lima and Digital Ocean.

    Shared hardening:
    - Creating the adrien user (parameterized by env)
    - Locking down SSH (disable password auth, root login)
    - Enabling UFW firewall
    - Disabling core dumps

    Lima-only:
    - Vault directory /var/lib/agents (for MCP server secrets)
    """
    env = setup_utils.detect_environment()
    cprint(f"Setting up hardening for {env}...", "blue", attrs=["bold"])

    # Create adrien user (parameterized by environment)
    create_user("adrien")

    # Lock down SSH logins (same for both)
    lock_down_ssh()

    # Turn on the firewall (same for both)
    setup_firewall()

    # Disable core dumps (same for both)
    disable_core_dumps()

    # Lima-only: create vault directory for MCP server secrets
    if setup_utils.is_lima():
        create_vault_dir()


def setup_firewall():
    """Enable UFW firewall with incoming deny.

    NOTE: Egress deny (default deny outgoing) is DEFERRED. When enabled,
    'ufw enable' hangs requiring interactive input, even with --force,
    yes pipes, or subprocess stdin tricks. This breaks non-interactive
    VM creation. See docs/security-hardening.md for details.

    Current rules:
    - Default deny incoming (except SSH)
    - Default allow outgoing (deferred hardening)
    """
    setup_utils.cached_run(
        "Turn on the firewall",
        [
            "sudo ufw default deny incoming",
            "sudo ufw allow ssh",
            "yes | sudo ufw --force enable",
        ],
    )


def disable_core_dumps():
    """Disable core dumps to prevent secret leakage from crashes."""
    setup_utils.cached_run(
        "Disabling core dumps",
        [
            # Set hard and soft limits to 0
            "echo '* hard core 0' | sudo tee -a /etc/security/limits.conf",
            "echo '* soft core 0' | sudo tee -a /etc/security/limits.conf",
            # Disable setuid core dumps
            "echo 'fs.suid_dumpable=0' | sudo tee -a /etc/sysctl.conf",
            # Apply sysctl changes
            "sudo sysctl -p",
        ],
    )


def create_vault_dir():
    """Create vault directory for MCP server secrets (Lima only)."""
    setup_utils.cached_run(
        "Creating vault directory",
        [
            "sudo mkdir -p /var/lib/agents",
            "sudo chown root:root /var/lib/agents",
            "sudo chmod 700 /var/lib/agents",
        ],
    )


def create_user(user):
    """Create a new user with environment-specific settings.

    Lima: No password, no sudo group (security hardening)
    Digital Ocean: Password prompt, sudo group (admin needs)

    Both: Copy SSH authorized_keys from current user to new user.
    """
    user_home = f"/home/{user}"
    cprint(f"Creating user {user}...", "blue", attrs=["bold"])
    if setup_utils.user_exists(user):
        cprint(f"User {user} already exists\n", "cyan")
        return

    zsh_path = shutil.which("zsh")
    if not zsh_path:
        print("Error: zsh not found in PATH")
        sys.exit(-1)

    if setup_utils.is_lima():
        # Lima: No password, no sudo group
        cprint("Creating user without password or sudo (Lima security mode)", "cyan")
        subprocess.run(
            ["sudo", "useradd", "-b", "/home", "-m", "-s", zsh_path, "-U", user],
            check=True
        )
        cprint(f"Added user {user} (no password, no sudo).\n", "green")
    else:
        # Digital Ocean: Password prompt, sudo group
        password = getpass.getpass(f"Password for user {user}: ")
        password_again = getpass.getpass("Reenter password: ")
        if password != password_again:
            print("Passwords don't match.")
            sys.exit(-1)

        # Generate hash using passlib
        encrypted_password = sha512_crypt.hash(password)

        subprocess.run(
            ["sudo", "useradd", "-b", "/home", "-G", "sudo", "-m",
             "-p", encrypted_password, "-s", zsh_path, "-U", user],
            check=True
        )

        temp_user_status = f'Adding {user} with {len(password)}-char password "{password[:2]}...{password[-2:]}"...'
        cprint(temp_user_status, "magenta", attrs=["bold"], end="\r")
        time.sleep(4.0)
        print(" " * len(temp_user_status), end="\r")  # clear the temp buffer
        cprint(f"Added user {user} (with password and sudo).\n", "green")

    # Setting up the new user (same for both environments)
    # Copy SSH keys from current user (lima user or root) to adrien
    setup_utils.cached_run(
        f"Setting up {user}",
        [
            f"sudo mkdir -p {user_home}/.ssh",
            f"sudo cp -v ~/.ssh/authorized_keys {user_home}/.ssh",
            f"sudo cp -v ~/.ssh/known_hosts {user_home}/.ssh" if os.path.exists(os.path.expanduser("~/.ssh/known_hosts")) else "true",
            f"sudo cp -v ~/dotfiles/setup/ssh_rc.bash {user_home}/.ssh/rc",
            f"sudo chmod 0700 {user_home}/.ssh",
            f"sudo touch {user_home}/.zshrc",
            f"sudo chown -vR {user}:{user} {user_home}",
        ],
    )


def lock_down_ssh():
    """Lock down ssh logins. Mostly, turn off root ssh login."""

    sshd_config_filename = "/etc/ssh/sshd_config"
    cprint(f"Updating {sshd_config_filename}...", "blue", attrs=["bold"])
    if os.path.exists(sshd_config_filename):
        config_changes = [
            ("PasswordAuthentication yes", "PasswordAuthentication no"),
            ("PermitRootLogin yes", "PermitRootLogin no"),
        ]
        sshd_config = open(sshd_config_filename).readlines()
        changed_config = False
        for line_number, config_line in enumerate(sshd_config):
            for change_from, change_to in config_changes:
                if config_line.strip() == change_from.strip():
                    print(f"{line_number+1}: {change_from} -> {change_to}")
                    sshd_config[line_number] = change_to + "\n"
                    changed_config = True
        print(f"changed config: {changed_config}")
        if changed_config:
            temp_file = tempfile.NamedTemporaryFile(mode="w", delete=False)
            temp_file.writelines(sshd_config)
            temp_file.close()
            subprocess.run(
                ["sudo", "chmod", "-v", f"--reference={sshd_config_filename}", temp_file.name],
                check=True
            )
            subprocess.run(
                ["sudo", "mv", "-v", temp_file.name, sshd_config_filename],
                check=True
            )
            print(f"Overwrote {sshd_config_filename}")
            print("Please restart the computer.")
        cprint("Done\n", "green")
    else:
        cprint(f"Could not find {sshd_config_filename}\n", "cyan")


def main():
    """Execution starts here."""
    # These installations require the user to be root.
    if not setup_utils.user_is_root():
        raise RuntimeError("Must run this script as root or with sudo privileges.")

    # Show environment info
    env = setup_utils.detect_environment()
    cprint(f"Environment: {env}", "blue", attrs=["bold"])

    # Run the setup script.
    setup_root()

    # Completion message depends on environment
    if setup_utils.is_digitalocean():
        cprint("Please reboot the computer:", "red", attrs=["bold"])
        print("  sudo reboot")
        print("\nThen SSH in as 'adrien' and run the bootstrap script again.")
    else:
        cprint("Root setup complete!", "green", attrs=["bold"])
        print("\nNow run the bootstrap script as 'adrien' to install user dotfiles:")
        print("  sudo -u adrien bash -c 'cd ~ && bash <(curl ...) lima'")


if __name__ == "__main__":
    main()

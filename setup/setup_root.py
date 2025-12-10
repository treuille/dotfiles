"""
Root-level setup script for dotfiles installation.

Supports two environments:
- Digital Ocean: Full setup including user creation, SSH hardening, firewall
- Lima: Package installation only (user exists, no hardening needed for local VM)
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
            "apt-get purge -y nodejs",
            "curl -fsSL https://deb.nodesource.com/setup_22.x | bash",
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

    # Server hardening (Digital Ocean only - not needed for local Lima VMs)
    if setup_utils.is_digitalocean():
        harden_server()
    else:
        env = setup_utils.detect_environment()
        cprint(f"Skipping server hardening (environment: {env})", "cyan")


def harden_server():
    """Harden the server for public internet exposure (Digital Ocean).

    This includes:
    - Creating the adrien user with password
    - Locking down SSH (disable password auth, root login)
    - Enabling UFW firewall

    Not needed for local Lima VMs where the user already exists
    and network security is handled by the host.
    """
    cprint("Hardening server for Digital Ocean...", "blue", attrs=["bold"])

    # Create a user to SSH into this box.
    create_user("adrien")

    # Lock down ssh logins
    lock_down_ssh()

    # Turn on the firewall
    setup_utils.cached_run(
        "Turn on the firewall",
        [
            "sudo ufw allow ssh",
            "echo y | sudo ufw enable",
        ],
    )


def create_user(user):
    """Create a new user"""
    user_home = f"/home/{user}"
    cprint(f"Creating user {user}...", "blue", attrs=["bold"])
    if setup_utils.user_exists(user):
        cprint(f"User {user} already exists\n", "cyan")
        return
    password = getpass.getpass(f"Password for user {user}: ")
    password_again = getpass.getpass("Reenter password: ")
    if password != password_again:
        print("Passwords don't match.")
        sys.exit(-1)

    # Generate hash using passlib
    encrypted_password = sha512_crypt.hash(password)

    # Create user with sudo privileges
    zsh_path = shutil.which("zsh")
    if not zsh_path:
        print("Error: zsh not found in PATH")
        sys.exit(-1)
    subprocess.run(
        ["sudo", "useradd", "-b", "/home", "-G", "sudo", "-m",
         "-p", encrypted_password, "-s", zsh_path, "-U", user],
        check=True
    )

    temp_user_status = f'Adding {user} with {len(password)}-char password "{password[:2]}...{password[-2:]}"...'
    cprint(temp_user_status, "magenta", attrs=["bold"], end="\r")
    time.sleep(4.0)
    print(" " * len(temp_user_status), end="\r")  # clear the temp buffer
    cprint(f"Added user {user}.\n", "green")

    # Setting up the new user
    setup_utils.cached_run(
        f"Setting up {user}",
        [
            f"sudo mkdir {user_home}/.ssh",
            f"sudo cp -v ~/.ssh/authorized_keys {user_home}/.ssh",
            f"sudo cp -v ~/.ssh/known_hosts {user_home}/.ssh",
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
        print("\nNow run the bootstrap script as the 'adrien' user to install dotfiles.")
        print("If you're in a Lima VM, you may need to:")
        print("  sudo -u adrien -i")
        print("Then run the bootstrap script.")


if __name__ == "__main__":
    main()

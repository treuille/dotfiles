"""
TODO: Add documentation
"""

import sys
import os
import setup_utils
from termcolor import cprint
import getpass
import crypt
import time
import tempfile


def setup_root():
    """These are the installation steps which should happen as root."""
    # Installing cc linker and compiler which cargo will need.
    setup_utils.cached_apt_install("build-essential") 

    # Setup zsh
    setup_utils.cached_run(
        "Setting up zsh",
        [
            "apt install -y zsh",
            "chsh -s $(which zsh)",
        ],
    )

    # Install netstat
    setup_utils.cached_apt_install("net-tools")

    # Install fancy search tools
    setup_utils.cached_apt_install("ripgrep")
    setup_utils.cached_apt_install("fzf")

    # Install lsd, a prettier ls
    setup_utils.cached_apt_install("lsd")

    # Set the timezone properly
    setup_utils.cached_run(
        "Setting timezone",
        [
            "timedatectl set-timezone America/Los_Angeles",
        ],
    )

    # Install neovim, the only way to edit code
    setup_utils.cached_apt_install("neovim")
    
    # Install the latest GitHub Command line tools
    setup_utils.cached_run(
        "Installing GitHub Command line tools",
        [
            "apt-get install wget -y",
            "mkdir -p -m 755 /etc/apt/keyrings",
            "wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null",
            "sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg",
            'echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null',
            "sudo apt update",
            "sudo apt install gh -y"
        ]
    )

#    setup_utils.cached_run(
#         "Installing lazygit",
#         [
#             'curl -L "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_0.36.0_Linux_x86_64.tar.gz" | tar xz -C /usr/local/bin lazygit'
#         ],
#     )

#    print("Early stop: setup_root.")
#     sys.exit(-1)
 
    # Create a user to SSH into this box.
    create_user("adrien")

    # Lock down ssh logins
    lock_down_ssh()

    # Turn on the firewall
    setup_utils.cached_run(
        "Turn on the firewall",
        [
            "ufw allow ssh",
            "echo y | ufw enable",
        ]
    )


def create_user(user):
    """Create a new user"""

    user_home = f"/home/{user}"
    cprint(f"Creating user {user}...", "blue", attrs=["bold"])
    if setup_utils.user_exists(user):
        cprint(f"User {user} already exists\n", "cyan")
    else:
        password = getpass.getpass(f"Password for user {user}: ")
        password_again = getpass.getpass("Reenter password: ")
        if password != password_again:
            print("Passwords don't match.")
            sys.exit(-1)
        encrypted_password = crypt.crypt(password, crypt.mksalt(crypt.METHOD_SHA512))
        add_user_cmd = f"useradd -b /home -G sudo -m -p '{encrypted_password}' -s $(which zsh) -U {user}"
        os.system(add_user_cmd)
        temp_user_status = f'Adding {user} with {len(password)}-char password "{password[:2]}...{password[-2:]}"...'
        cprint(temp_user_status, "magenta", attrs=["bold"], end="\r")
        time.sleep(4.0)
        print(" " * len(temp_user_status), end="\r")  # clear the temp buffer
        cprint(f"Added user {user}.\n", "green")

        # Setting up the new user
        setup_utils.cached_run(
            f"Setting up {user}",
            [
                f"mkdir {user_home}/.ssh",
                f"cp -v ~/.ssh/authorized_keys {user_home}/.ssh",
                f"cp -v ~/.ssh/known_hosts {user_home}/.ssh",
                f"cp -v ~/dotfiles/setup/ssh_rc.bash {user_home}/.ssh/rc",
                f"chmod 0700 {user_home}/.ssh",
                f"touch {user_home}/.zshrc",
                f"chown -vR {user}:{user} {user_home}",
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
            os.system(f"chmod -v --reference={sshd_config_filename} {temp_file.name}")
            os.system(f"mv -v {temp_file.name} {sshd_config_filename}")
            print(f"Overwrote {sshd_config_filename}")
            print("Please restart the computer.")
        cprint("Done\n", "green")
    else:
        cprint(f"Could not find {sshd_config_filename}\n", "cyan")


def main():
    """Execution starts here."""
    # These installations require the user to be root.
    if not setup_utils.user_is_root():
        raise RuntimeError("Must run this script as root.")

    # Run the setup script.
    setup_root()

    # Tell the root user to reboot.
    cprint(f"Please reboot the computer:", "red", attrs=["bold"])
    print("  shutdown -r now")


if __name__ == "__main__":
    main()

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

    # Setup zsh
    setup_utils.cached_run(
        "Setting up zsh",
        [
            "apt install -y zsh",
            "chsh -s $(which zsh)",
        ],
    )

    # setup_utils.cached_run(
    #     "Installing unzip",
    #     [
    #         "apt install -y unzip",
    #     ],
    # )

    setup_utils.cached_run(
        "Installing netstat",
        [
            "apt install -y net-tools",
        ],
    )

    # # See: https://github.com/nodesource/distributions
    # setup_utils.cached_run(
    #     "Installing node",
    #     [
    #         "curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -",
    #         "sudo apt-get install -y nodejs",
    #         #        'curl -sL https://deb.nodesource.com/setup_13.x | sudo -E bash -',
    #         #        'sudo apt-get install -y nodejs',
    #     ],
    # )

    # setup_utils.cached_run(
    #     "Installing yarn",
    #     [
    #         "curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -",
    #         'echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list',
    #         "sudo apt update",
    #         "sudo apt install yarn",
    #     ],
    # )

    setup_utils.cached_run(
        "Installing fancy search tools",
        [
            # Needed for fast fuzzy grep using telescope
            "sudo apt install -y ripgrep",
        ],
    )

    # install rust, then lsd with cargo

    # setup_utils.cached_run(
    #     "Installing lsd",
    #     [
    #         "curl -LJO https://github.com/Peltoche/lsd/releases/download/0.19.0/lsd_0.19.0_amd64.deb",
    #         "sudo apt install ./lsd_0.19.0_amd64.deb",
    #         "rm -rv lsd_0.19.0_amd64.deb",
    #     ],
    # )

    # Set the timezone properly
    setup_utils.cached_run(
        "Setting timezone",
        [
            "timedatectl set-timezone America/Los_Angeles",
        ],
    )

    # setup_utils.cached_run(
    #     "Installing useful commands",
    #     [
    #         "sudo apt install -y poppler-utils",  # gives you pdfimages
    #     ],
    # )

    # setup_utils.cached_run(
    #     "Installing LSP servers",
    #     [
    #         "npm install -g vim-language-server", # vimls
    #         "npm install -g pyright", # python
    #     ]
    # )

    setup_utils.cached_run(
        "Installing nvim",
        [
            'apt install -y neovim',
            # "sudo snap install --beta nvim --classic",
            # "apt install -y make",
            # "apt install -y cmake",
            # "apt install -y g++",
            # "apt install -y pkg-config",
            # "apt install -y libtool-bin",
            # "apt install -y gettext",
            # "apt install -y libgettextpo-dev",
            # "cd ~ && git clone https://github.com/neovim/neovim.git",
            # "cd ~/neovim && make CMAKE_BUILD_TYPE=RelWithDebInfo install",
            # "rm -rfv ~/neovim",
        ]
    )

    setup_utils.cached_run(
        "Installing lazygit",
        [
            'curl -L "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_0.36.0_Linux_x86_64.tar.gz" | tar xz -C /usr/local/bin lazygit'
            # "apt-add-repository --yes ppa:lazygit-team/release",
            # "apt update",
            # "apt install lazygit",
       ]
    )

    # Create a user to SSH into this box.
    create_user("adrien")

    # Lock down ssh logins
    lock_down_ssh()

    # Turn on the firewall
    setup_utils.cached_run(
        "Turn on the firewall",
        [
            "ufw allow ssh",
            "ufw enable",
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
                f"chmod 0700 {user_home}/.ssh",
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


def install_nvim_plugins():
    """Install the nvim and coc plugins."""
    # Would be great to figure out a way to do this automatically
    sys.stdout.write("Install nvim plugins interactively? [y/n] ")
    try:
        if input().lower()[:1] == "y":
            os.system("nvim +PlugInstall")
            os.system('nvim +"CocInstall coc-tsserver coc-pyright"')
    except EOFError:
        cprint("\nSkipping nvim plugins (couldn't read stdin).\n", "cyan")


def both_install():
    """These are the packages which shoild happen for any user."""

    # Removing bash config files.
    setup_utils.cached_run(
        "Removing extraneous home folder files",
        [
            "rm -fv ~/.bashrc ~/.bash_history ~/.bash_logout",
            "rm -fv ~/.cloud-locale-test.skip",
            "rm -fv ~/.zcompdump",
        ],
    )

    # See: https://github.com/junegunn/vim-plug
    setup_utils.cached_run(
        "Installing vim-plug",
        [
            """sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'""",
        ],
    )

    # Install a nice theme for tmux
    # See: https://github.com/odedlaz/tmux-onedark-theme
    tmux_onedark_theme_repo = "https://github.com/odedlaz/tmux-onedark-theme"
    tmux_onedark_theme_path = "~/.local/share/tmux/tmux-onedark-theme"
    setup_utils.cached_run(
        "Installing tmux-onedark-theme",
        [
            f"git clone {tmux_onedark_theme_repo} {tmux_onedark_theme_path}",
        ],
        skip_if=os.path.exists(os.path.expanduser(tmux_onedark_theme_path)),
    )

    # Install another nice theme for tmux using the tmux plugin manager
    tmux_plugin_path = "~/.config/tmux/plugins/tpm"
    tmux_plugin_repo = "https://github.com/tmux-plugins/tpm"
    setup_utils.cached_run(
        "Installing the tmux plugin manager",
        [
            f"git clone {tmux_plugin_repo} {tmux_plugin_path}",
        ],
        skip_if=os.path.exists(os.path.expanduser(tmux_plugin_path)),
    )

    install_nvim_plugins()



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

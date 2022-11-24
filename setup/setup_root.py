"""
TODO: Add documentation
"""

# import time
# import getpass
# import crypt
# import subprocess
# import tempfile
# from termcolor import cprint
import sys
import os
import cached_run


def setup_root():
    """These are the installation steps which should happen as root."""

    # Setup zsh
    cached_run.run_commands(
        "Setting up zsh",
        [
            "apt install -y zsh",
            "chsh -s $(which zsh)",
        ],
    )

    return 
    cached_run.run_commands(
        "Installing unzip",
        [
            "apt install -y unzip",
        ],
    )

    cached_run.run_commands(
        "Installing netstat",
        [
            "apt install -y net-tools",
        ],
    )

    # # See: https://github.com/nodesource/distributions
    # cached_run.run_commands(
    #     "Installing node",
    #     [
    #         "curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -",
    #         "sudo apt-get install -y nodejs",
    #         #        'curl -sL https://deb.nodesource.com/setup_13.x | sudo -E bash -',
    #         #        'sudo apt-get install -y nodejs',
    #     ],
    # )

    # cached_run.run_commands(
    #     "Installing yarn",
    #     [
    #         "curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -",
    #         'echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list',
    #         "sudo apt update",
    #         "sudo apt install yarn",
    #     ],
    # )

    cached_run.run_commands(
        "Installing fancy search tools",
        [
            # Needed for fast fuzzy grep using telescope
            "sudo apt install -y ripgrep",
        ],
    )

    # install rust, then lsd with cargo

    # cached_run.run_commands(
    #     "Installing lsd",
    #     [
    #         "curl -LJO https://github.com/Peltoche/lsd/releases/download/0.19.0/lsd_0.19.0_amd64.deb",
    #         "sudo apt install ./lsd_0.19.0_amd64.deb",
    #         "rm -rv lsd_0.19.0_amd64.deb",
    #     ],
    # )

    # Set the timezone properly
    cached_run.run_commands(
        "Setting timezone",
        [
            "timedatectl set-timezone America/Los_Angeles",
        ],
    )

    # cached_run.run_commands(
    #     "Installing useful commands",
    #     [
    #         "sudo apt install -y poppler-utils",  # gives you pdfimages
    #     ],
    # )

    # cached_run.run_commands(
    #     "Installing LSP servers",
    #     [
    #         "npm install -g vim-language-server", # vimls
    #         "npm install -g pyright", # python
    #     ]
    # )

    cached_run.run_commands(
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

    cached_run.run_commands(
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
    cached_run.run_commands(
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
    if user_exists(user):
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
        cached_run.run_commands(
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
    cached_run.run_commands(
        "Removing extraneous home folder files",
        [
            "rm -fv ~/.bashrc ~/.bash_history ~/.bash_logout",
            "rm -fv ~/.cloud-locale-test.skip",
            "rm -fv ~/.zcompdump",
        ],
    )

    # See: https://github.com/junegunn/vim-plug
    cached_run.run_commands(
        "Installing vim-plug",
        [
            """sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'""",
        ],
    )

    # Install a nice theme for tmux
    # See: https://github.com/odedlaz/tmux-onedark-theme
    tmux_onedark_theme_repo = "https://github.com/odedlaz/tmux-onedark-theme"
    tmux_onedark_theme_path = "~/.local/share/tmux/tmux-onedark-theme"
    cached_run.run_commands(
        "Installing tmux-onedark-theme",
        [
            f"git clone {tmux_onedark_theme_repo} {tmux_onedark_theme_path}",
        ],
        skip_if=os.path.exists(os.path.expanduser(tmux_onedark_theme_path)),
    )

    # Install another nice theme for tmux using the tmux plugin manager
    tmux_plugin_path = "~/.config/tmux/plugins/tpm"
    tmux_plugin_repo = "https://github.com/tmux-plugins/tpm"
    cached_run.run_commands(
        "Installing the tmux plugin manager",
        [
            f"git clone {tmux_plugin_repo} {tmux_plugin_path}",
        ],
        skip_if=os.path.exists(os.path.expanduser(tmux_plugin_path)),
    )

    install_nvim_plugins()


def user_exists(user):
    return bool(subprocess.run(["getent", "passwd", user], capture_output=True).stdout)


def user_is_root():
    """Returns true if this user is root."""
    return os.geteuid() == 0


def main():
    """Execution starts here."""
    # These installations require the user to be root.
    if not user_is_root():
        raise RuntimeError("Must run this script as root.")

    setup_root()

    # # Both root and non-root accounts are setup this way.
    # # both_install()

    # # Tell the root user to reboot.
    # if user_is_root():
    #     cprint(f"Please reboot the computer:", "red", attrs=["bold"])
    #     print("  shutdown -r now")


if __name__ == "__main__":
    main()

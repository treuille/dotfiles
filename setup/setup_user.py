"""
TODO: Add documentation
"""

# import sys
# import os
import setup_utils
# from termcolor import cprint
# import subprocess
# import getpass
# import crypt
# import time
# import tempfile

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
    if setup_utils.user_is_root():
        raise RuntimeError("Should not run this script as root.")

    setup_root()

    # # Both root and non-root accounts are setup this way.
    # # both_install()

    # # Tell the root user to reboot.
    # if setup_utils.user_is_root():
    #     cprint(f"Please reboot the computer:", "red", attrs=["bold"])
    #     print("  shutdown -r now")


if __name__ == "__main__":
    main()

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


def setup_user():
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

    setup_user()

if __name__ == "__main__":
    main()

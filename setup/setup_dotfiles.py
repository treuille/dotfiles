"""
TODO: Add documentation
"""

import setup_utils
import sys
import os
from termcolor import cprint


def install_dotfiles():
    """Install all the dotfiles from the dotfiles dirctory into the home
    directory, moving all backups to ~/dofiles/setup/backup."""
    # Setup a backup dirctory to move old dotfiles.
    home_path = os.path.expanduser("~")
    dotfiles_path = os.path.join(home_path, "dotfiles")
    backup_path = os.path.join(dotfiles_path, "setup/backup")
    setup_utils.cached_run(
        "Setting up backup dirctory",
        [
            f"mkdir -pv {backup_path}",
        ],
        skip_if=os.path.exists(backup_path),
    )

    # Setup a backup dirctory to move old dotfiles.
    for dotfile in os.listdir(dotfiles_path):
        if dotfile in [".git", ".gitignore"] or not dotfile.startswith("."):
            continue
        orignal_dotfile_path = os.path.join(dotfiles_path, dotfile)
        install_dotfile_path = os.path.join(home_path, dotfile)
        backup_dotfile_path = os.path.join(backup_path, dotfile)

        print(f"orignal_dotfile_path: {orignal_dotfile_path}")
        print(f"install_dotfile_path: {install_dotfile_path}")
        print(f"backup_dotfile_path: {backup_dotfile_path}")

        if os.path.exists(install_dotfile_path):
            setup_utils.cached_run(
                f"Backing up {dotfile}",
                [
                    f"mv -v {install_dotfile_path} {backup_dotfile_path}",
                ],
                skip_if=os.path.exists(backup_dotfile_path),
            )
        setup_utils.cached_run(
            f"Installing {dotfile}",
            [
                f"ln -sv {orignal_dotfile_path} {install_dotfile_path}",
            ],
        )

    # Removing bash config files.
    setup_utils.cached_run(
        "Removing extraneous home folder files",
        [
            "rm -fv ~/.bashrc ~/.bash_history ~/.bash_logout",
            "rm -fv ~/.cloud-locale-test.skip",
            "rm -fv ~/.zcompdump",
        ],
    )


def install_rust():
    """Installs in the home directory."""
    # Install rust itself.
    home_path = os.path.expanduser("~")
    cargo_home = os.path.join(home_path, ".local/rust/cargo")
    rustup_home = os.path.join(home_path, ".local/rust/rustup")
    rust_env = f"CARGO_HOME={cargo_home} RUSTUP_HOME={rustup_home}"
    setup_utils.cached_run(
        "Installing rust",
        [
            "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | "
            f"{rust_env} sh -s -- -y",
        ],
        skip_if=(os.path.exists(cargo_home) or os.path.exists(rustup_home)),
    )

    # Additional rust configuration.
    rustup_bin = os.path.join(cargo_home, "bin/rustup")
    cargo_bin = os.path.join(cargo_home, "bin/cargo")
    setup_utils.cached_run(
        "Configuring rust",
        [
            f"{rust_env} {rustup_bin} default stable",
            f"{rust_env} {rustup_bin} component add rls rust-analysis rust-src",
            f"{rust_env} {cargo_bin} install -j4 cargo-watch",
        ],
    )

    # Install lsd, a prettier form of ls.
    setup_utils.cached_run("Installing lsd", [f"{rust_env} {cargo_bin} install -j4 lsd"])


def install_tmux_plugins():
    """These are the packages which shoild happen for any user."""

    # # Install a nice theme for tmux
    # # See: https://github.com/odedlaz/tmux-onedark-theme
    # tmux_onedark_theme_repo = "https://github.com/odedlaz/tmux-onedark-theme"
    # tmux_onedark_theme_path = "~/.local/share/tmux/tmux-onedark-theme"
    # setup_utils.cached_run(
    #     "Installing tmux-onedark-theme",
    #     [
    #         f"git clone {tmux_onedark_theme_repo} {tmux_onedark_theme_path}",
    #     ],
    #     skip_if=os.path.exists(os.path.expanduser(tmux_onedark_theme_path)),
    # )

    # Install the tmux plugin manager
    tmux_plugin_path = "~/.config/tmux/plugins/tpm"
    tmux_plugin_repo = "https://github.com/tmux-plugins/tpm"
    setup_utils.cached_run(
        "Installing the tmux plugin manager",
        [
            f"echo git clone {tmux_plugin_repo} {tmux_plugin_path}",
        ],
        skip_if=os.path.exists(os.path.expanduser(tmux_plugin_path)),
    )


def install_nvim_plugins():
    """Install the nvim and coc plugins."""
    # Install the plugin manager github.com/junegunn/vim-plug
    setup_utils.cached_run(
        "Installing vim-plug",
        [
            """sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'""",
        ],
    )

    # Would be great to figure out a way to do this automatically
    sys.stdout.write("Install nvim plugins interactively? [y/n] ")
    try:
        if input().lower()[:1] == "y":
            os.system("nvim +PlugInstall")
    except EOFError:
        cprint("\nSkipping nvim plugins (couldn't read stdin).\n", "cyan")


def main():
    """Execution starts here."""
    install_dotfiles()
    install_nvim_plugins()
    install_tmux_plugins()
    install_rust()


if __name__ == "__main__":
    main()

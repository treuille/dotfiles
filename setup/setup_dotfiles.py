"""
TODO: Add documentation
"""

import setup_utils
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
    cprint(f"Installing dotfiles...", "blue", attrs=["bold"])
    for dotfile in os.listdir(dotfiles_path):
        if dotfile in [".git", ".gitignore"] or not dotfile.startswith("."):
            continue
        orignal_dotfile_path = os.path.join(dotfiles_path, dotfile)
        install_dotfile_path = os.path.join(home_path, dotfile)
        backup_dotfile_path = os.path.join(backup_path, dotfile)

        cprint(f"Installing {dotfile}", "green")
        if os.path.exists(install_dotfile_path):
            if os.path.exists(backup_dotfile_path):
                os.system(f"rm -rfv {install_dotfile_path}")
            else:
                os.system(f"mv -v {install_dotfile_path} {backup_dotfile_path}")
            assert os.path.exists(backup_dotfile_path)
        assert not os.path.exists(install_dotfile_path)
        os.system(f"ln -sv {orignal_dotfile_path} {install_dotfile_path}")
    cprint(f"Done\n", "green")

    # Removing bash config files.
    setup_utils.cached_run(
        "Removing extraneous home folder files",
        [
            "rm -fv ~/.bashrc ~/.bash_history ~/.bash_logout",
            "rm -fv ~/.cloud-locale-test.skip",
            "rm -fv ~/.zcompdump",
        ],
    )


def install_pure():
    """Installs a prettier prompt for zsh."""
    pure_repo = "https://github.com/sindresorhus/pure.git"
    zsh_plugin_path = os.path.expanduser("~/.local/share/zsh")
    pure_path = os.path.join(zsh_plugin_path, "pure")
    setup_utils.cached_run(
        "Installing pure, a prettier prompt for zsh",
        [f"mkdir -pv {zsh_plugin_path}", f"git clone {pure_repo} {pure_path}"],
        skip_if=os.path.exists(pure_path),
    )


def install_tmux_plugins():
    """Make tmux work with its plugins."""
    tmux_plugin_path = os.path.expanduser("~/.config/tmux/plugins")
    tpm_plugin_path = os.path.join(tmux_plugin_path, "tpm")
    tpm_plugin_repo = "https://github.com/tmux-plugins/tpm"
    setup_utils.cached_run(
        "Installing the tmux plugin manager",
        [
            f"mkdir -pv {tmux_plugin_path}",
            f"git clone {tpm_plugin_repo} {tpm_plugin_path}",
            f"{tpm_plugin_path}/bindings/install_plugins || true",
        ],
        skip_if=os.path.exists(os.path.expanduser(tpm_plugin_path)),
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
        [f"curl https://sh.rustup.rs -sSf | {rust_env} sh -s -- -y"],
        skip_if=(os.path.exists(cargo_home) and os.path.exists(rustup_home)),
    )

    # Additional rust configuration.
    rustup_bin = os.path.join(cargo_home, "bin/rustup")
    # cargo_bin = os.path.join(cargo_home, "bin/cargo")
    setup_utils.cached_run(
        "Configuring rust",
        [
            f"{rust_env} {rustup_bin} default stable",
            f"{rust_env} {rustup_bin} component add rust-analyzer",
        ],
    )


def install_claude_code():
    """Install the Claude Code CLI"""
    setup_utils.cached_run(
        "Installing Claude Code",
        [
            "curl -fsSL https://claude.ai/install.sh | bash",
        ],
    )


def install_neovim():
    """Install neovim from official GitHub releases.

    Uses tarball for ARM64 (AppImage doesn't work on aarch64 Linux).
    Uses AppImage for x86_64.
    """
    home_path = os.path.expanduser("~")
    local_dir = os.path.join(home_path, ".local")
    local_bin = os.path.join(local_dir, "bin")
    nvim_path = os.path.join(local_bin, "nvim")

    if setup_utils.machine_is_arm64():
        # ARM64: Use tarball (AppImage is 32-bit ARM launcher, doesn't work)
        tarball_url = "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-arm64.tar.gz"
        nvim_dir = os.path.join(local_dir, "nvim-linux-arm64")
        setup_utils.cached_run(
            "Installing neovim (tarball for ARM64)",
            [
                f"mkdir -p {local_bin}",
                f"curl -L -o /tmp/nvim-linux-arm64.tar.gz {tarball_url}",
                f"tar -xzf /tmp/nvim-linux-arm64.tar.gz -C {local_dir}",
                f"ln -sf {nvim_dir}/bin/nvim {nvim_path}",
                "rm /tmp/nvim-linux-arm64.tar.gz",
            ],
            skip_if=os.path.exists(nvim_path),
        )
    else:
        # x86_64: Use AppImage
        appimage_url = "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage"
        setup_utils.cached_run(
            "Installing neovim (AppImage for x86_64)",
            [
                f"mkdir -p {local_bin}",
                f"curl -L -o {nvim_path} {appimage_url}",
                f"chmod +x {nvim_path}",
            ],
            skip_if=os.path.exists(nvim_path),
        )


def install_gcloud():
    """Install the Google Cloud SDK.

    Used to authenticate with Google services and access higher API rate limits.
    """
    home_path = os.path.expanduser("~")
    gcloud_install_dir = os.path.join(home_path, ".local/gcloud")
    gcloud_sdk_path = os.path.join(gcloud_install_dir, "google-cloud-sdk")
    setup_utils.cached_run(
        "Installing Google Cloud SDK",
        [
            f"curl https://sdk.cloud.google.com | bash -s -- "
            f"--install-dir={gcloud_install_dir} --disable-prompts",
        ],
        skip_if=os.path.exists(gcloud_sdk_path),
    )


def main():
    """Execution starts here."""
    install_pure()
    install_dotfiles()
    install_tmux_plugins()
    install_neovim()
    # install_rust()
    install_gcloud()
    install_claude_code()

    cprint("Everythign installed. To get all the goodies, run:", "blue", attrs=["bold"])
    print(". ~/.zshrc")


if __name__ == "__main__":
    main()

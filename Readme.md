# Digital Ocean Installation Instructions

1. ssh in as `root`, and run this command:

```sh
bash <(curl https://raw.githubusercontent.com/treuille/dotfiles/main/setup/setup_digital_ocean.bash)
```

2. ssh in, this time as `adrien`, and run the same command.

## Optional installs

1. Install `cargo-watch`

```sh
cargo install -j4 cargo-watch
```

# MacOS Installation Instructions

1. Need to include instructions on installing homebrew itself 

2. Intalled python 3.10
```sh
brew install python@3.10
```

2. Install `rg` for fast nvim telescope searches
```sh
brew install rg
```

3. Installed vim plug
```sh
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
mkdir -v ~/.local/share/nvim/vim-plug
```

4. Installed the tmux plugin manager
```
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

5. EXPERIMENTAL -- Run the setup script.

```sh
zsh ./setup.zsh
```

6. Install lazygit
```sh
brew install lazygit
```

7. Install pure

```sh
mkdir -p ${HOME}/.local/share/zsh/pure
git clone https://github.com/sindresorhus/pure.git ${HOME}/.local/share/zsh/pure
```

# Todo 

1. Setup XDG properly
2. Get nvim and other `.config/`s into this repo 


mkdir -p /Users/atreuille/.local/share/zsh/pure

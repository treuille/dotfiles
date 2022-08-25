# How I did this

1. Need to include instructions on installing homebrew itself 

2. Intalled python 3.10
```sh
brew install python@3.10
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


# Todo 

1. Setup XDG properly
2. Get nvim and other `.config/`s into this repo 



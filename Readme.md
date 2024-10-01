# Digital Ocean Installation Instructions

1. ssh in as `root`, and run this command:

```sh
bash <(curl https://raw.githubusercontent.com/treuille/dotfiles/main/setup/setup_digital_ocean.bash)
```

2. ssh in, this time as `adrien`, and run the same command.

## (Optional) install cargo watch

1. Install `cargo-watch`

```sh
cargo install -j4 cargo-watch
```

# Blink Shell Installation Instructions

Make sure the following settings are set for your host:

### Blink SSH

* **HostName**: *(Ip address of the host)*
* **Port**: `22`
* **User**: `root`*(update to username later in process)*
* **Key**: `Blink3@Elbowpads`
* **SSH Config**: 
```
Compression yes
LocalForward 8501 localhost:8501
ForwardAgent yes
```
* SSH Agent
    * **Agent Forwarding**: `Always`
    * **Forward Keys**: `Blink3@Elbowpads`

### MacBook SSH

Make sure your SSH config has the following structure:

```
Host <HOST>
     HostName <IP ADDRESS>
     Port 22
     User adrien
     ForwardAgent yes
     AddKeysToAgent yes
     IdentitiesOnly yes
     IdentityFile ~/.ssh/id_ed25519
     LocalForward 8501 <IP ADDRESS>:8501
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

5. Install lazygit
```sh
brew install lazygit
```

6. Install pure

```sh
mkdir -p ${HOME}/.local/share/zsh/pure
git clone https://github.com/sindresorhus/pure.git ${HOME}/.local/share/zsh/pure
```

6. Install GitHub Copilot

Start by installing node

```sh
brew install node
```

Then, follow [these instructions](https://github.com/github/copilot.vim).

7. EXPERIMENTAL -- Run the setup script.

```sh
zsh ./setup.zsh
```


# Todo 

* Get everything basically working again from Tahiti
* Automate the installation of Github Copilot as part of the install 

### Finally 

* Merge back into main
* Update the repo back to `main` in
    * This README
    * The setup digital ocean script

## Old Todo Items

1. Setup XDG properly
2. Get nvim and other `.config/`s into this repo 

# Python venv
alias venv-activate="source .venv/bin/activate"
alias venv-create="python3 -m venv .venv"
alias venv-delete="rm -rfv .venv"

# Snowsql
alias snowsql=/Applications/SnowSQL.app/Contents/MacOS/snowsql

# A prettier ls
alias ls=lsd

# Vim keybindings
bindkey -v

# Nvim configuration
export EDITOR=nvim

# Rust
export CARGO_HOME=${HOME}/.local/rust/cargo
export RUSTUP_HOME=${HOME}/.local/rust/rustup
export PATH=${CARGO_HOME}/bin:${PATH}

# Make rust analyzer availalbe as an executable
export PATH=${PATH}:${RUSTUP_HOME}/toolchains/stable-x86_64-unknown-linux-gnu/bin

# Pure, a prettier prompt
fpath+=(${HOME}/.local/share/zsh/pure)
autoload -U promptinit; promptinit
prompt pure

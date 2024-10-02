# Python venv
alias venv-activate="source .venv/bin/activate"
alias venv-create="python3 -m venv .venv ; venv-activate"
alias venv-delete="rm -rfv .venv"

# TODO: Remove this
# # Snowsql
# alias snowsql=/Applications/SnowSQL.app/Contents/MacOS/snowsql

# A prettier ls
alias ls=lsd

# Vim keybindings
bindkey -v

# Nvim configuration
export PATH=${PATH}:/opt/nvim-linux64/bin
export EDITOR=nvim

# A better find
alias fd=fdfind

# Rust
export CARGO_HOME=${HOME}/.local/rust/cargo
export RUSTUP_HOME=${HOME}/.local/rust/rustup
export PATH=${CARGO_HOME}/bin:${PATH}

# TODO: Remove this
# This doesnt' appear necessary, sice the above lines add cargo to the path
# source ~/.local/rust/cargo/env

# Pure, a prettier prompt
fpath+=(${HOME}/.local/share/zsh/pure)
autoload -U promptinit; promptinit
prompt pure

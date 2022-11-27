# export PATH=${PATH}:/Library/Developer/CommandLineTools/Library/Frameworks/Python3.framework/Versions/3.8/bin
# export PATH=${PATH}:/Users/atreuille/Library/Python/3.8/bin
# export CPLUS_INCLUDE_PATH=${CPLUS_INCLUDE_PATH}:/Library/Developer/CommandLineTools/Library/Frameworks/Python3.framework/Versions/3.8/Headers

# Python 3.10 and venv
export PATH=/opt/homebrew/opt/python@3.10/libexec/bin:${PATH}
alias venv-create="python -m venv .venv"
alias venv-delete="rm -rfv .venv"
alias activate="source .venv/bin/activate"

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
fpath+=(/home/adrien/.local/share/zsh/pure)
autoload -U promptinit; promptinit
prompt pure

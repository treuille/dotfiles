# export PATH=${PATH}:/Library/Developer/CommandLineTools/Library/Frameworks/Python3.framework/Versions/3.8/bin
# export PATH=${PATH}:/Users/atreuille/Library/Python/3.8/bin
# export CPLUS_INCLUDE_PATH=${CPLUS_INCLUDE_PATH}:/Library/Developer/CommandLineTools/Library/Frameworks/Python3.framework/Versions/3.8/Headers

# Python 3.10 and venv
export PATH=/opt/homebrew/opt/python@3.10/libexec/bin:${PATH}
alias venv-create="python3 -m venv .venv ; venv-activate"
alias venv-activate="source .venv/bin/activate"
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

# Vincne't cool tsh thingy
function tshaccess() {
    tsh login --proxy teleport.m1.us-west-2.aws-dev.app.snowflake.com:3080 
    tsh clusters 
    tsh login sfc-or-dev-misc-k8s-sandbox1
    tsh login --kube-cluster=sfc-or-dev-misc-k8s-sandbox1 sfc-or-dev-misc-k8s-sandbox1
}

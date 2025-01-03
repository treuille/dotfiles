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
export PATH=${PATH}:/opt/nvim/bin
# export PATH=${PATH}:/opt/nvim-linux64/bin
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

# Add API keys for OpenAI and Anthropic
API_KEY_FILE=${HOME}/.config/nvim/api_keys.toml
RED="\033[31m"
RESET="\033[0m"
if [[ -f ${API_KEY_FILE} ]]; then
    export OPENAI_API_KEY=$(awk -F'= *"|"' '/^openai/ {print $2}' ${API_KEY_FILE})
    export ANTHROPIC_API_KEY=$(awk -F'= *"|"' '/^anthropic/ {print $2}' ${API_KEY_FILE})
elif [[ -z ${API_WARNING_SHOWN} ]]; then
    echo "${RED}Warning: ${API_KEY_FILE} not found${RESET}"
    export API_WARNING_SHOWN=1
fi

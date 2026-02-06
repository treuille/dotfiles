# Python venv
# DEPRECATED: using uv now
alias venv-activate="source .venv/bin/activate"
alias venv-create="python3 -m venv .venv ; venv-activate"
alias venv-delete="rm -rfv .venv"

# --- uv venv helpers ---
alias uv-venv-create="uv venv"                        # creates .venv (fast!)
alias uv-venv-delete="rm -rfv .venv"                  # delete venv
alias uv-venv-shell="source .venv/bin/activate"       # optional manual activation
alias uv-venv-info="uv venv --show"                   # show path, interpreter, etc.

# A prettier ls
alias ls=lsd

# A better find.
# --hidden: search hidden files/dirs (including .claude)
# --no-ignore: search .gitignored files
# --exclude: skip common data directories
alias fd="fdfind --hidden --no-ignore --exclude .git --exclude node_modules --exclude .venv --exclude __pycache__ --exclude .cache --exclude target --exclude build --exclude dist"

# Fix ugly light green background on README files in fd/lsd
# Remove background color (42) from specific file patterns
export LS_COLORS="${LS_COLORS}:*README=01;33:*README.md=01;33:*README.txt=01;33:"

# Vim keybindings
bindkey -v

# Nvim configuration
export PATH=${PATH}:/opt/nvim/bin
export EDITOR=nvim

# Open all files affected by git changes in nvim
alias nvim-diff="git ls-files --modified --others --exclude-standard | xargs nvim"

# Open all files with merge conflicts in nvim
alias nvim-conflict="git diff --name-only --diff-filter=U | xargs nvim"

# A better cat
alias bat="batcat"

# Used by Claude Code and potentially other tools
export PATH=${HOME}/.local/bin:${PATH}

# Brancher: manage parallel working directories tied to Git branches
brancher() {
    local output
    output="$(${HOME}/dotfiles/bin/brancher "$@")"
    local rc=$?
    if [[ $rc -eq 0 && "$output" == cd\ * ]]; then
        eval "$output"
    elif [[ -n "$output" ]]; then
        echo "$output"
    fi
    return $rc
}

# Claude Code XDG config directory
export CLAUDE_CONFIG_DIR=${HOME}/.config/claude

# Claude Code privacy controls
# These disable operational telemetry (separate from the training opt-out toggle
# on claude.ai). Even with training disabled, Claude Code sends telemetry for
# error reporting and usage analytics. These vars disable that additional logging.
# See: https://privacy.claude.com/en/articles/10023580-is-my-data-used-for-model-training
export DISABLE_TELEMETRY=1
export DISABLE_ERROR_REPORTING=1

# Claude Code with Bedrock
export AWS_PROFILE=dauphin
export CLAUDE_CODE_USE_BEDROCK=1
# export ANTHROPIC_MODEL='us.anthropic.claude-opus-4-5-20251101-v1:0'
export ANTHROPIC_MODEL='us.anthropic.claude-opus-4-6-v1'
export ANTHROPIC_DEFAULT_HAIKU_MODEL='us.anthropic.claude-haiku-4-5-20251001-v1:0'
export CLAUDE_CODE_SUBAGENT_MODEL=${ANTHROPIC_DEFAULT_HAIKU_MODEL}
# export ANTHROPIC_SMALL_FAST_MODEL='us.anthropic.claude-haiku-4-5-20251001-v1:0'

# Go
export GOPATH=${HOME}/.local/go
export PATH=$PATH:/usr/local/go/bin:${GOPATH}/bin

# Rust
export CARGO_HOME=${HOME}/.local/rust/cargo
export RUSTUP_HOME=${HOME}/.local/rust/rustup
export PATH=${CARGO_HOME}/bin:${PATH}

# Google Cloud SDK
export CLOUDSDK_ROOT_DIR=${HOME}/.local/gcloud/google-cloud-sdk
export PATH=${CLOUDSDK_ROOT_DIR}/bin:${PATH}
[ -f ${CLOUDSDK_ROOT_DIR}/completion.zsh.inc ] && source ${CLOUDSDK_ROOT_DIR}/completion.zsh.inc

# Pure, a prettier prompt
fpath+=(${HOME}/.local/share/zsh/pure)
autoload -U promptinit; promptinit
prompt pure

# I'm now focused on using copilot completions and
# Claude code, both of which have their own login flows
# so not sure if I need this next part anymore...
#
# # Add API keys for OpenAI and Anthropic
# API_KEY_FILE=${HOME}/.config/nvim/api_keys.toml
# RED="\033[31m"
# RESET="\033[0m"
# if [[ -f ${API_KEY_FILE} ]]; then
#     export OPENAI_API_KEY=$(awk -F'= *"|"' '/^openai/ {print $2}' ${API_KEY_FILE})
#     export ANTHROPIC_API_KEY=$(awk -F'= *"|"' '/^anthropic/ {print $2}' ${API_KEY_FILE})
# elif [[ -z ${API_WARNING_SHOWN} ]]; then
#     echo "${RED}Warning: ${API_KEY_FILE} not found${RESET}"
#     export API_WARNING_SHOWN=1
# fi

# Fzf config
export FZF_DEFAULT_COMMAND='fdfind --type f --hidden --follow --exclude .git --exclude node_modules --exclude .venv --exclude __pycache__ --exclude .cache --exclude target --exclude build --exclude dist'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border"
FZF_CONFIG=${HOME}/.config/fzf/0.44.1
[ -f ${FZF_CONFIG}/completion.zsh ] && source ${FZF_CONFIG}/completion.zsh
[ -f ${FZF_CONFIG}/key-bindings.zsh ] && source ${FZF_CONFIG}/key-bindings.zsh

# Create or join tmux session based on current directory path
# Example: ~/projects/my-app -> projects_my_app
# Example: ~/.config/nvim -> config_nvim
# If session exists, attaches to it. If not, creates new session.
alias tmxa='tmux new-session -A -s $(pwd | sed "s|^$HOME/||" | sed "s/[^a-zA-Z0-9]/_/g" | sed "s/^_//")'

# Fix SSH auth socket for tmux compatibility.
# When connecting via SSH (Digital Ocean) or limactl shell (Lima VM), the
# SSH_AUTH_SOCK path varies. Tmux expects a fixed path (~/.ssh/ssh_auth_sock).
# This creates/updates a symlink so tmux always finds the agent.
if [ -n "$SSH_AUTH_SOCK" ] && [ "$SSH_AUTH_SOCK" != "$HOME/.ssh/ssh_auth_sock" ]; then
    ln -sf "$SSH_AUTH_SOCK" ~/.ssh/ssh_auth_sock
elif [ -z "$SSH_AUTH_SOCK" ] && [ -L ~/.ssh/ssh_auth_sock ]; then
    rm ~/.ssh/ssh_auth_sock
fi

# Enable autosuggestions
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Enable syntax highlighting (must be last)
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh


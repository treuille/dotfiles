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

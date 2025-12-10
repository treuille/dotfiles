# Bootstrap the setup of a development environment by:
#
# 1. Installing the dotfiles repo
# 2. Installing uv and creating a Python virtual environment
# 3. Running the appropriate setup script:
#     - With sudo access: setup_root.py (installs system packages)
#     - Without sudo: setup_dotfiles.py (installs user dotfiles)
#
# Supports three deployment scenarios:
# - Digital Ocean: Run as root first, then as adrien user
# - Lima VM (single user): Run as admin user (has sudo), then as adrien user
# - Lima VM (dauphin): lima-admin installs packages, adrien runs dotfiles only

# Require environment as first argument, optional second argument for phase
if [[ $# -lt 1 ]] || [[ $# -gt 2 ]] || [[ "$1" != "lima" && "$1" != "digitalocean" ]]; then
    echo "Usage: $0 <lima|digitalocean> [user]"
    echo "  lima         - Local Lima VM (no password, no sudo for adrien)"
    echo "  digitalocean - Remote server (password + sudo for adrien)"
    echo "  user         - Optional: force user-only mode (skip root setup)"
    exit 1
fi
export DOTFILES_ENV="$1"
FORCE_USER_MODE=0
if [[ $# -eq 2 ]] && [[ "$2" == "user" ]]; then
    FORCE_USER_MODE=1
fi

# Variables
GIT_REPO="git@github.com:treuille/dotfiles.git"
BRANCH="${DOTFILES_BRANCH:-main}"
DOTFILES_PATH="dotfiles"
SETUP_PATH="${DOTFILES_PATH}/setup"
VENV_PATH="${DOTFILES_PATH}/setup/uv_venv"

# Determine if we have passwordless sudo access (unless forced to user mode)
if [[ $FORCE_USER_MODE -eq 1 ]]; then
    IS_ROOT=1  # Force user mode - pretend no sudo access
else
    sudo -n true &> /dev/null
    IS_ROOT=$?  # $? is 0 (true) if user has passwordless sudo, 1 (false) otherwise
fi

# Tell the user what we're doing at the start of each block.
start_block()
{
    echo -e "\e[1m\e[34m$@...\e[0m"
    set -v
}

# Tell the user that the block is complete.
end_block()
{
    set +v
    echo -e "\e[32mDone\e[0m\n"
}

# Print something in red letters
echo_red()
{
    echo -e "\e[1m\e[31m$@\e[0m"
}

# Display environment info at startup
show_environment()
{
  echo -e "\e[1m\e[34mEnvironment: ${DOTFILES_ENV}\e[0m"

  if [ $IS_ROOT -eq 0 ];
  then
    echo -e "\e[32mRunning with sudo access - will install system packages\e[0m"
    # Only show Lima-specific info during root phase (when we actually create the user)
    if [ "$DOTFILES_ENV" = "lima" ];
    then
      echo -e "\e[36mLima: adrien user will have no password and no sudo\e[0m"
    fi
  else
    echo -e "\e[33mRunning without sudo - will install user dotfiles only\e[0m"
  fi
  echo
}

# Prevent interactive restart dialogs
prevent_restart_dialog()
{
  if [ $IS_ROOT -eq 0 ];
  then
    local needrestart_conf="/etc/needrestart/needrestart.conf"
    if [ -f "$needrestart_conf" ];
    then
      echo_red "Turning off interactive restart during install process...\n"
      # Set restart mode to 'l' (list only, no prompts)
      sudo sed -i "s/^#\$nrconf{restart}\ =\ '.';/\$nrconf{restart} = 'l';/g" "$needrestart_conf"
      # Disable "newer kernel available" prompts (0 = disable, -1 = stderr only)
      sudo sed -i "s/^#\$nrconf{kernelhints}\ =\ -1;/\$nrconf{kernelhints} = 0;/g" "$needrestart_conf"
    else
      echo_red "needrestart.conf not found - skipping restart dialog config"
    fi
  fi
}

# Add GitHub's SSH host key to known_hosts (avoids interactive prompt)
add_github_host_key()
{
  mkdir -p ~/.ssh
  chmod 700 ~/.ssh
  # Use GitHub's published host key (https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/githubs-ssh-key-fingerprints)
  if ! grep -q "github.com" ~/.ssh/known_hosts 2>/dev/null; then
    ssh-keyscan -t ed25519 github.com >> ~/.ssh/known_hosts 2>/dev/null
  fi
}

# Install the dotfiles repo
install_dotfiles()
{
  # Clone the repo
  start_block "Cloning the repo"

  if [[ -d ${DOTFILES_PATH} ]];
  then
    echo_red "Repo \"${DOTFILES_PATH}\" already exists."
  else
    # Check whether we can log into github. If not, something is wrong.
    if [ ! -S "$SSH_AUTH_SOCK" ];
    then
      echo "Unable to log into Github. Exiting."
      exit 255
    fi

    # Add GitHub host key to avoid interactive prompt
    add_github_host_key

    # Clone the repo
    git clone -b ${BRANCH} ${GIT_REPO}
    if [[ $? -ne 0 ]];
    then
      echo_red "Failed to clone branch \"${BRANCH}\" from \"${GIT_REPO}\"."
      exit 1
    fi
  fi

  end_block
}

# Ensure uv is available (install if needed and possible)
install_uv()
{
  start_block "Checking for uv package manager"

  # Check if uv is already installed (by admin or previous run)
  if command -v uv >/dev/null 2>&1;
  then
    echo_red "uv is already installed."
    uv --version || true
    end_block
    # Skip zsh completion setup if no sudo (already done by admin)
    if [ $IS_ROOT -eq 0 ];
    then
      setup_uv_zsh_completion
    fi
    return 0
  fi

  # uv not installed - need to install it
  if [ $IS_ROOT -ne 0 ];
  then
    # No sudo access and uv not installed - can't proceed
    echo_red "ERROR: uv is not installed and you don't have sudo access."
    echo_red ""
    echo_red "Please ask your system administrator (lima-admin) to run:"
    echo_red "  bash <(curl https://raw.githubusercontent.com/treuille/dotfiles/main/setup/setup_bootstrap.bash)"
    echo_red ""
    echo_red "This will install system packages including uv."
    exit 1
  fi

  # Has sudo - install uv system-wide
  echo_red "Installing uv globally into /usr/local/bin"
  curl -LsSf https://astral.sh/uv/install.sh | sudo UV_INSTALL_DIR=/usr/local/bin sh

  # Verify installation
  if ! command -v uv >/dev/null 2>&1;
  then
    echo_red "ERROR: uv not found in PATH after install."
    exit 1
  fi

  uv --version || true
  end_block

  # Setup zsh completion (requires sudo)
  setup_uv_zsh_completion
}

# Setup zsh completion for uv (requires sudo)
setup_uv_zsh_completion()
{
  start_block "Installing zsh completion for uv for all users"
  # Ensure zsh site-functions directory exists
  ZSH_COMPLETION_DIR="/usr/share/zsh/site-functions"
  sudo mkdir -p "$ZSH_COMPLETION_DIR"

  # Generate zsh completion file
  uv generate-shell-completion zsh | sudo tee "${ZSH_COMPLETION_DIR}/_uv" > /dev/null

  # Ensure zsh loads site-functions globally
  ZSHRC_GLOBAL="/etc/zsh/zshrc"
  LINE_TO_ADD='fpath=(/usr/share/zsh/site-functions $fpath)'

  if ! grep -Fq "$LINE_TO_ADD" "$ZSHRC_GLOBAL" 2>/dev/null;
  then
    echo_red "Adding zsh completion path to $ZSHRC_GLOBAL"
    {
      echo ""
      echo "# Added by uv installer script"
      echo "$LINE_TO_ADD"
    } | sudo tee -a "$ZSHRC_GLOBAL" > /dev/null
  else
    echo_red "zsh completion path already in $ZSHRC_GLOBAL"
  fi
  end_block
}

# Create the virtual environment using uv and install the requirements file.
setup_uv_venv()
{
  start_block "Creating uv virtual environment at ${VENV_PATH}"
  if [[ -d ${VENV_PATH} ]];
  then
    echo_red "Virtual environment \"${VENV_PATH}\" already exists."
  else
    uv venv "${VENV_PATH}"
    if [[ $? -ne 0 ]];
    then
      echo_red "Failed to create virtual environment."
      exit 1
    fi
    uv pip install -r ${SETUP_PATH}/requirements.txt --python ${VENV_PATH}/bin/python
    if [[ $? -ne 0 ]];
    then
      echo_red "Failed to install requirements."
      exit 1
    fi
  fi
  end_block
}

# Run a python script using uv run
run_python_script()
{
  if [ $IS_ROOT -eq 0 ];
  then
    PYTHON_SCRIPT="setup_root"
  else
    PYTHON_SCRIPT="setup_dotfiles"
  fi
  echo_red "Executing setup script ${PYTHON_SCRIPT}.py."
  PYTHONPATH=${SETUP_PATH} uv run --python ${VENV_PATH}/bin/python -m ${PYTHON_SCRIPT}
}

# Actually run the script
show_environment
if [ "$DOTFILES_ENV" = "digitalocean" ]; then
  prevent_restart_dialog
fi
install_dotfiles
install_uv
setup_uv_venv
run_python_script

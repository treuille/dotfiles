# Bootstrap the setup of a digital ocean installation by:
#
# 1. Installing the dotfiles repo
# 2. Installing python3 virtual environmnet (venv) if necessary
# 3. Creating a venv
# 4. Running a script in the venv
#     - if root: setup_root.py
#     - not root: setup_user.py

# Variables
GIT_REPO="git@github.com:treuille/dotfiles.git"
BRANCH="${BRANCH:-main}"
DOTFILES_PATH="dotfiles"
SETUP_PATH="${DOTFILES_PATH}/setup"
VENV_PATH="${DOTFILES_PATH}/setup/uv_venv"

# Determine if we have passwordless sudo access
sudo -n true &> /dev/null
IS_ROOT=$?  # $? is 0 (true) if user has passwordless sudo, 1 (false) otherwise

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

# Prevent interactive restart dialogs
prevent_restart_dialog()
{
  if [ $IS_ROOT -eq 0 ];
  then
    echo_red "Turning off interactive restart during install process...\n"
    sudo sed -i "s/^#\$nrconf{restart}\ =\ '.';/\$nrconf{restart} = 'l';/g" /etc/needrestart/needrestart.conf
    if [[ $? -ne 0 ]];
    then
      echo_red "Failed to disable restart dialogs. Continuing anyway..."
    fi
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

# Install uv globally to /usr/local/bin
install_uv()
{
  # Only run if the user has sudo access
  if [ $IS_ROOT -ne 0 ];
  then
    return 255
  fi

  start_block "Installing uv globally into /usr/local/bin"
  # Check if uv is already installed
  if command -v uv >/dev/null 2>&1;
  then
    echo_red "uv is already installed."
    uv --version || true
  else
    # Install uv system-wide
    curl -LsSf https://astral.sh/uv/install.sh | UV_INSTALL_DIR=/usr/local/bin sh

    # Verify installation
    if ! command -v uv >/dev/null 2>&1;
    then
      echo_red "ERROR: uv not found in PATH after install."
      exit 1
    fi

    uv --version || true
  fi
  end_block

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
prevent_restart_dialog
install_dotfiles
install_uv
setup_uv_venv
run_python_script

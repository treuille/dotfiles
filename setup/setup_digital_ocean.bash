# Bootstrap the setup of a digital ocean installation by:
# 
# 1. Installing the dotfiles repo
# 2. Installing python3.10-venv if necessary
# 3. Creating a venv
# 4. Running a script in the venv
#     - if root: setup_root.py
#     - not root: setup_user.py

# Variables
GIT_REPO="git@github.com:treuille/dotfiles.git"
GIT_BRANCH="unified"
DOTFILES_PATH="dotfiles"
SETUP_PATH="${DOTFILES_PATH}/setup"
VENV_PATH="${DOTFILES_PATH}/setup/venv"

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

	 # Actually clone the repo
	 git clone -b ${GIT_BRANCH} ${GIT_REPO}

  fi

  end_block
}

# Install the python3.10-venv required to use Python venv in Ubuntu.
install_python_venv()
{
  # Only run in the user is root.
  if [[ $EUID -ne 0 ]];
  then
	 return 255
  fi
  
  PYTHON_VENV_PACKAGE="python3.10-venv"
  start_block "Installing ${PYTHON_VENV_PACKAGE}."
  dpkg -s ${PYTHON_VENV_PACKAGE} &> /dev/null
  if [[ $? -eq 0 ]];
  then
    echo_red "The package ${PYTHON_VENV_PACKAGE} already exists."
  else
    start_block "Installing ${PYTHON_VENV_PACKAGE}"
    apt update -y
    apt upgrade -y
    apt install python3.10-venv -y
    end_block
  fi
  end_block
}

# Create the virtual environment and install the requirements file.
setup_venv()
{
  start_block "Creating virtual environment at ${VENV_PATH}."
  if [[ -d ${VENV_PATH} ]];
  then
    echo_red "Virtual environment \"${VENV_PATH}\" already exists."
  else
    python3 -m venv "${VENV_PATH}"
    ${VENV_PATH}/bin/pip install -r ${SETUP_PATH}/requirements.txt
  fi
  end_block
}

# Actually run the script
install_dotfiles
install_python_venv
setup_venv
exit 255



exit 255

# 
# 
# # The initial (root) install updates the apt repoe ans installs pipenv.
# bash ~/dotfiles/setup/run_python.bash setup_digital_ocean
# 
# # echo "Setup the python environment." # <- REMOVE
# # 
# # # Run the python setup script.
# # start_block "Setting up python environment"
# # cd ~/dev-env/
# # python3 -m venv .venv
# # .venv/bin/pip install -r requirements.txt
# # end_block
# # 
# # 
# # # Actualy run the sub command
# # echo -e "\e[1m\e[31mRunning Python setup script in $(pwd)\e[0m"
# # echo
# # .venv/bin/python ./setup_env.py
# # # pipenv run python ./setup_env.py

############################
# RUNNING THE SCRIPT STUFF #
############################

# PYTHON_SCRIPT=${1}
# SCRIPT_PATH="${SETUP_PATH}/${PYTHON_SCRIPT}.py"

# # Check for the setup path.
# if [[ ! -f ${SCRIPT_PATH} ]];
# then
#   echo "Missing script ${SCRIPT_PATH}."
#   exit 255
# fi

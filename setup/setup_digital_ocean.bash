# This script boostraps the dev environment so that
# we can use Python to install everything else.
# Note that this file is piped into bash, not sourced.


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

# Check whether we can log into github. If not, something is wrong.
if [ ! -S "$SSH_AUTH_SOCK" ];
then
   echo "Unable to log into Github. Exiting."
   exit 255
fi

# Clone the repo
start_block "Cloning the repo"
GIT_REPO="git@github.com:treuille/dotfiles.git"
cd ~
if [[ ! -d dotfiles ]];
then
    # TODO: GET RID OF THE UNIFIED BRANCH
    git clone -b unified "$GIT_REPO"
fi
end_block

# The initial (root) install updates the apt repoe ans installs pipenv.
if [[ $EUID -eq 0 ]];
then
    # A very existential statement.
    echo -e "\e[1m\e[31mYou are root.\e[0m"
    echo

    # Upgrade apt-get.
    start_block "Setting up apt-get"
    apt update -y
    apt upgrade -y
    apt install python3.10-venv -y
    end_block
else
    echo -e "\e[1m\e[31mRunning as a non-root user.\e[0m"
    echo
fi

bash ~/dotfiles/setup/run_python.bash setup_digital_ocean

# echo "Setup the python environment." # <- REMOVE
# 
# # Run the python setup script.
# start_block "Setting up python environment"
# cd ~/dev-env/
# python3 -m venv .venv
# .venv/bin/pip install -r requirements.txt
# end_block
# 
# 
# # Actualy run the sub command
# echo -e "\e[1m\e[31mRunning Python setup script in $(pwd)\e[0m"
# echo
# .venv/bin/python ./setup_env.py
# # pipenv run python ./setup_env.py

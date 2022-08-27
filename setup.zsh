# Make a file to stash the original dotfiles
ORIGINAL_DOTFILES="$(pwd)/original_dotfiles"
if [[ -d ${ORIGINAL_DOTFILES} ]]; then 
    echo "${ORIGINAL_DOTFILES} already exists."
else
    echo "Creating directory ${ORIGINAL_DOTFILES}."
    mkdir "${ORIGINAL_DOTFILES}"
fi

# Link .zshrc
ZSHRC=${HOME}/.zshrc
DOTFILE_ZSHRC=$(pwd)/.zshrc
ORIGINAL_ZSHRC=${ORIGINAL_DOTFILES}/.zshrc
if [[ -e "${ZSHRC}" ]]; then
    if [[ -e "${ORIGINAL_ZSHRC}" ]]; then 
        echo "Removing ${ZSHRC} without overwriting ${ORIGINAL_ZSHRC}."
        rm -v "${ZSHRC}"
    else
        echo "Moving ${ZSHRC} to ${ORIGINAL_ZSHRC}."
        mv "${ZSHRC}" "${ORIGINAL_ZSHRC}"
    fi
fi
echo "Linking ${ZSHRC} to ${DOTFILE_ZSHRC}."
ln -s "${DOTFILE_ZSHRC}" "${ZSHRC}"

# Link .config
CONFIG=${HOME}/.config
DOTFILE_CONFIG=$(pwd)/.config
ORIGINAL_CONFIG=${ORIGINAL_DOTFILES}/.config
if [[ -e "${CONFIG}" ]]; then
    if [[ -e "${ORIGINAL_CONFIG}" ]]; then 
        echo "Removing ${CONFIG} without overwriting ${ORIGINAL_CONFIG}."
        rm -v "${CONFIG}"
    else
        echo "Moving ${CONFIG} to ${ORIGINAL_CONFIG}."
        mv "${CONFIG}" "${ORIGINAL_CONFIG}"
    fi
fi
echo "Linking ${CONFIG} to ${DOTFILE_CONFIG}."
ln -s "${DOTFILE_CONFIG}" "${CONFIG}"

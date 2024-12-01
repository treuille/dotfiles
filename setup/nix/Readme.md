# Nix-Dev

This is Adrien's environment to do secure, isolated programming on his MacBook.

## Goals

Trying to create a project which allows me to secure, sandboxed command-line programming on my MacBook. The basic struture is

```
my_local_homedir > secure sandbox > nix package manager > local_filesystem
```

1. Everything is run in a secure sandbox, with minimal access to the rest of the computer.
	a. In particular, all local files outside the sandbox are inaccessible
	b. Even installation itself happens inside the sandbox 	
2. I can enter an interactive shell within the sandbox. Inside this shell I have access to:
	a. My dotfiles, including a modern neovim config
	b. A modern python environment with pip and pipenv
	c. A modern rust installation (with the ability to output audio)

## Requirements

- `git`

## Usage goals

Here is how it should feel to use this program

### Installation

**TODO** Something like

```sh
bash <(curl https://raw.githubusercontent.com/treuille/dotfiles/main/setup/setup_digital_ocean.bash)
```

### Usage

This creates an interactive shell which is run inside a 

```sh
run-nix <- enter an interactive shell
```

## Todo

- [ ] Chat with ChatGPT about whether I can use someone else's project
	- [ ] Search for a project which already does this
		- [ ] Ask ChatGPT if such a thing already exists
		- [ ] Google if such a thing already exists
- [ ] Chat with ChatGPT about how I can get this done
- [ ] Finally iterate with it to create an updated goals document that I can paste into this readme
- [ ] Start to actually implement this. Yay!

## Observations

- Dang. This typing is already way faster than I'm used to on my Digital Ocean Box
	- Exciting!

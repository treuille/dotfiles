# Dotfiles Setup

Personal dotfiles for development environments on Digital Ocean and Lima VMs.

## Quick Start

### Lima VM (Local Development)

**Prerequisites**: Create a Lima VM with the `adrien` user using [treuille/dauphin](https://github.com/treuille/dauphin) bootstrap.

1. SSH into your Lima VM as the admin user (with sudo access):

```sh
limactl shell <vm-name>
```

2. Run the bootstrap script (installs system packages):

```sh
export DOTFILES_BRANCH=main
bash <(curl https://raw.githubusercontent.com/treuille/dotfiles/${DOTFILES_BRANCH}/setup/setup_bootstrap.bash)
```

3. Switch to the `adrien` user and run again (installs dotfiles):

```sh
sudo -u adrien -i
export DOTFILES_BRANCH=main
bash <(curl https://raw.githubusercontent.com/treuille/dotfiles/${DOTFILES_BRANCH}/setup/setup_bootstrap.bash)
```

4. Next step: Install [treuille/dauphin](https://github.com/treuille/dauphin) as your life orchestrator.

### Digital Ocean (Remote Server)

1. SSH in as `root`, and run this command:

```sh
export DOTFILES_BRANCH=main
bash <(curl https://raw.githubusercontent.com/treuille/dotfiles/${DOTFILES_BRANCH}/setup/setup_bootstrap.bash)
```

2. SSH in, this time as `adrien`, and run the same command.

3. Copy over the OpenAI key as follows:

```sh
scp <oldhost>:.config/nvim/chatgpt_nvim.txt <newhost>:.config/nvim/chatgpt_nvim.txt
```

## Environment Detection

The setup scripts automatically detect your environment:
- **Lima**: Skips server hardening (user creation, SSH lockdown, firewall)
- **Digital Ocean**: Full setup including security hardening

## (Optional) Install bacon

Install `bacon` (the new `cargo-watch`):

```sh
cargo install --locked bacon
```

See [the website](https://dystroy.org/bacon/).

# Lima VM Setup (via limactl)

Create a Lima VM configured for this dotfiles setup:

```sh
# Create VM (dauphin handles this, but for manual setup:)
limactl create --name=dev --cpus=4 --memory=8 --disk=50 template://ubuntu
limactl start dev
limactl shell dev
```

For full Lima VM bootstrap with `adrien` user pre-configured, use [treuille/dauphin](https://github.com/treuille/dauphin).

# Blink Shell Installation Instructions

Make sure the following settings are set for your host:

### Blink SSH

* **HostName**: *(Ip address of the host)*
* **Port**: `22`
* **User**: `root`*(update to username later in process)*
* **Key**: `Blink3@Elbowpads`
* **SSH Config**: 
```
Compression yes
LocalForward 8501 localhost:8501
ForwardAgent yes
```
* SSH Agent
    * **Agent Forwarding**: `Always`
    * **Forward Keys**: `Blink3@Elbowpads`

### MacBook SSH

Make sure your SSH config has the following structure:

```
Host <HOST>
     HostName <IP ADDRESS>
     Port 22
     User adrien
     ForwardAgent yes
     AddKeysToAgent yes
     IdentitiesOnly yes
     IdentityFile ~/.ssh/id_ed25519
     LocalForward 8501 <IP ADDRESS>:8501
     LocalForward 4867 <IP ADDRESS>:4867
```

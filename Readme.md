# Dotfiles Setup

Personal dotfiles for development environments on Digital Ocean and Lima VMs.

## Quick Start

### Lima VM with Dauphin (Recommended)

**Two-user security model**: `lima-admin` has sudo for system operations, `adrien` has no sudo for security isolation.

**Prerequisites**: Create a Lima VM using [treuille/dauphin](https://github.com/treuille/dauphin).

**Step 1**: As `lima-admin` (has sudo), install system packages:

```sh
limactl shell dauphin
export DOTFILES_BRANCH=main
bash <(curl -fsSL https://raw.githubusercontent.com/treuille/dotfiles/${DOTFILES_BRANCH}/setup/setup_bootstrap.bash)
```

**Step 2**: As `adrien` (no sudo), install user dotfiles:

```sh
limactl shell dauphin --user adrien
export DOTFILES_BRANCH=main
bash <(curl -fsSL https://raw.githubusercontent.com/treuille/dotfiles/${DOTFILES_BRANCH}/setup/setup_bootstrap.bash)
```

**Step 3**: Install [treuille/dauphin](https://github.com/treuille/dauphin) as your life orchestrator.

### Digital Ocean (Remote Server)

1. SSH in as `root`, and run this command:

```sh
export DOTFILES_BRANCH=main
bash <(curl -fsSL https://raw.githubusercontent.com/treuille/dotfiles/${DOTFILES_BRANCH}/setup/setup_bootstrap.bash)
```

2. SSH in, this time as `adrien`, and run the same command.

3. Copy over the OpenAI key as follows:

```sh
scp <oldhost>:.config/nvim/chatgpt_nvim.txt <newhost>:.config/nvim/chatgpt_nvim.txt
```

## Environment & Sudo Detection

The setup scripts automatically detect:

| Condition | Behavior |
|-----------|----------|
| **Has sudo + Digital Ocean** | Full setup: packages, user creation, SSH hardening, firewall |
| **Has sudo + Lima** | Package installation only (no hardening for local VM) |
| **No sudo** | User dotfiles only (assumes packages installed by admin) |

If you run without sudo and system packages aren't installed, you'll see a helpful error message directing you to ask your system administrator to run the script first.

## (Optional) Install bacon

Install `bacon` (the new `cargo-watch`):

```sh
cargo install --locked bacon
```

See [the website](https://dystroy.org/bacon/).

## Manual Lima Setup (without Dauphin)

For a simpler Lima setup where the admin user runs everything:

```sh
limactl create --name=dev --cpus=4 --memory=8 --disk=50 template://ubuntu
limactl start dev
limactl shell dev

# As the default lima user (has sudo):
export DOTFILES_BRANCH=main
bash <(curl -fsSL https://raw.githubusercontent.com/treuille/dotfiles/${DOTFILES_BRANCH}/setup/setup_bootstrap.bash)
```

For the full security-isolated setup with `adrien` user pre-configured, use [treuille/dauphin](https://github.com/treuille/dauphin).

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

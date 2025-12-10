# Dotfiles Setup

Personal dotfiles for development environments.

## Quick Start

### Digital Ocean (Remote Server)

1. SSH in as `root`, and run:

```sh
export DOTFILES_BRANCH=simplify_lima
bash <(curl -fsSL https://raw.githubusercontent.com/treuille/dotfiles/${DOTFILES_BRANCH}/setup/setup_bootstrap.bash) digitalocean
```

2. SSH in as `adrien`, and run the same command.

3. Copy over the OpenAI key:

```sh
scp <oldhost>:.config/nvim/chatgpt_nvim.txt <newhost>:.config/nvim/chatgpt_nvim.txt
```

> **Local Lima VM?** Replace `digitalocean` with `lima` to skip server hardening.

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

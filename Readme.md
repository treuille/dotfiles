# Dotfiles Setup

Personal dotfiles for development environments. Supports two deployment targets:
- **Digital Ocean** - Remote cloud servers for development
- **Lima** - Local macOS VMs with enhanced security for running AI agents

## Environment Differences

The bootstrap script accepts `lima` or `digitalocean` as an argument, which affects user creation and security settings:

| Aspect        | `lima`           | `digitalocean`   |
|---------------|------------------|------------------|
| User adrien   | No pwd, no sudo  | Has pwd & sudo   |
| Root password | Locked           | Set at bootstrap |
| Vault dir     | /var/lib/agents  | Not created      |
| Use case      | AI agent sandbox | Interactive dev  |

### Why the difference?

**Lima VMs** run AI agents that process untrusted content (emails, web pages). If an agent is compromised, the attacker should NOT be able to:
- Escalate to root (no sudo)
- Extract encrypted secrets (vault is root-owned)
- Access the host machine (Lima sandboxing)

**Digital Ocean servers** need interactive administration, so `adrien` retains sudo access for manual maintenance.

## Quick Start

### Digital Ocean (Remote Server)

1. SSH in as `root`, and run:

```sh
export DOTFILES_BRANCH=main; bash <(curl https://raw.githubusercontent.com/treuille/dotfiles/${DOTFILES_BRANCH}/setup/setup_bootstrap.bash) digitalocean
```

2. Reboot, then SSH in as `adrien` and run the same command.

3. Copy over the OpenAI key:

```sh
scp <oldhost>:.config/nvim/chatgpt_nvim.txt <newhost>:.config/nvim/chatgpt_nvim.txt
```

### Lima VM (Local macOS)

For Lima VMs, use the `dauphin` repository which orchestrates the full setup:

```sh
git clone git@github.com:treuille/dauphin.git
cd dauphin
./scripts/dauphin-setup.sh
```

This automatically runs the dotfiles bootstrap with the `lima` flag. See the [dauphin docs](https://github.com/treuille/dauphin) for details.

> **Manual Lima setup?** You can run the bootstrap directly with `lima` instead of `digitalocean`, but using `dauphin-setup.sh` is recommended as it also runs security verification.

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

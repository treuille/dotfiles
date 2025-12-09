# Security Improvements Roadmap

This document tracks security improvements identified during a security review. Items are prioritized by effort (t-shirt size) and security gain.

## Completed

- [x] **Remove exposed GitHub token from README** (Effort: S, Gain: M)
- [x] **Remove hardcoded IP address from README** (Effort: S, Gain: S)
- [x] **Replace `os.system()` with `subprocess.run()`** (Effort: M, Gain: S)
  - Prevents command injection in `setup_root.py`

## Pending Improvements

### High Priority

#### 1. Remove Password Fragment Logging
**File:** `setup/setup_root.py:160`
**Effort:** S | **Security Gain:** M

The password preview leaks first/last 2 characters to terminal output:
```python
temp_user_status = f'Adding {user} with {len(password)}-char password "{password[:2]}...{password[-2:]}"...'
```

**Fix:** Remove password preview entirely or just show length.

---

#### 2. Add Pre-commit Secret Scanning
**Effort:** M | **Security Gain:** L

No automated scanning for accidentally committed secrets.

**Fix:** Install one of:
- `detect-secrets`
- `gitleaks`
- `trufflehog`

Example setup:
```bash
pip install pre-commit detect-secrets
# Add to .pre-commit-config.yaml
```

---

#### 3. Enable GPG Commit Signing
**File:** `.gitconfig`
**Effort:** M | **Security Gain:** M

Commits can be impersonated with just name/email configuration.

**Fix:** Add to `.gitconfig`:
```ini
[commit]
    gpgsign = true
[user]
    signingkey = <YOUR_GPG_KEY_ID>
```

---

### Medium Priority

#### 4. Verify Downloads Before Execution
**Effort:** L | **Security Gain:** M

Multiple `curl | bash` patterns create supply chain risk:
- `setup_bootstrap.bash` - uv installer
- `setup_root.py` - NodeSource setup
- `setup/README.md` - rustup

**Fix:** Download scripts first, verify checksums/signatures, then execute.

---

#### 5. Harden `eval` in Shell Wrapper
**File:** `.zshrc:51`
**Effort:** M | **Security Gain:** S

The brancher wrapper uses `eval "$output"`. Currently guarded by prefix check but fragile.

```zsh
if [[ $rc -eq 0 && "$output" == cd\ * ]]; then
    eval "$output"
```

**Fix:** Consider stricter validation or using a different IPC mechanism.

---

### Low Priority

#### 6. Remove SSH Key Names from Documentation
**Files:** `setup/README.md`, `Readme.md`
**Effort:** S | **Security Gain:** XS

References to "Blink@Elbowpads" reveal key naming conventions.

---

#### 7. Clean Setup Cache Directory
**Location:** `~/.local/cache/digital_ocean_setup/`
**Effort:** S | **Security Gain:** XS

Add cleanup step to remove cached installation records after setup completes.

---

#### 8. Parameterize Timezone
**File:** `setup/setup_root.py:83`
**Effort:** S | **Security Gain:** XS

Hardcoded "America/Los_Angeles" reveals geographic location.

**Fix:** Make configurable or prompt during setup.

---

## Security Practices Already in Place

- SSH hardening (password auth disabled, root login disabled)
- UFW firewall enabled by default
- API keys properly gitignored
- Password hashing with SHA512 (passlib)
- AI plugins disabled by default
- Bash scripts use `set -euo pipefail`
- Credentials loaded via environment variables

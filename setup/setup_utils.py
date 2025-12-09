"""
This file lets you run a set of commands and cache them so that they
they needn't be run a second time.
"""

from termcolor import cprint
import os
import sys
import hashlib
import pickle
import subprocess
from typing import Optional, Literal
import platform
import socket

# This is the command to install apt packages
APT_INSTALL = "sudo DEBIAN_FRONTEND=noninteractive apt install -y"

# Environment types
Environment = Literal["lima", "digitalocean"]


def detect_environment() -> Environment:
    """Detect whether we're running in a Lima VM or Digital Ocean.

    Lima VMs have specific markers:
    - /etc/lima-cidata/ directory exists (lima cloud-init data)
    - /.limactl or /lima.yaml existence
    - LIMA_CIDATA_* environment variables

    Returns "lima" or "digitalocean".
    """
    # Check for Lima cloud-init data directory (most reliable)
    if os.path.isdir("/etc/lima-cidata"):
        return "lima"

    # Check for Lima environment variables
    for key in os.environ:
        if key.startswith("LIMA_"):
            return "lima"

    # Check for lima in the hostname (common pattern)
    hostname = socket.gethostname().lower()
    if "lima" in hostname:
        return "lima"

    # Default to Digital Ocean
    return "digitalocean"


def is_lima() -> bool:
    """Returns True if running in a Lima VM."""
    return detect_environment() == "lima"


def is_digitalocean() -> bool:
    """Returns True if running on Digital Ocean."""
    return detect_environment() == "digitalocean"


def machine_is_arm64():
    """Determine if the machine architecture is ARM64."""
    return platform.machine() == "aarch64"

def cached_run(title, commands, skip_if=False):
    """Runs the given set of commands, prepending the title."""
    # Inidcate the command we're running
    cprint(f"{title}...", "blue", attrs=["bold"])

    # Create the cache filename
    hasher = hashlib.sha256()
    hasher.update(pickle.dumps((title, commands)))
    cache_folder = os.path.expanduser("~/.local/cache/dotfiles_setup")
    cache_filename = f"{hasher.hexdigest()}_{title.lower().replace(' ', '_')}.txt"
    cache_filename = os.path.join(cache_folder, cache_filename)

    # Skip running the command if the skip_if command is true.
    if skip_if:
        cprint("Skipping", "cyan")
        print()
        return

    # Skip running the command if we already have it cached
    if os.path.exists(cache_filename):
        cprint("Already done", "cyan")
        print()
        return

    # Run the commmands
    for command in commands:
        cprint(command, attrs=["bold"])
        return_value = os.system(command)
        if return_value != 0:
            cprint(f"Error: {return_value}", "red", attrs=["bold"])
            sys.exit(return_value)

    # Write the cached file.
    os.makedirs(cache_folder, exist_ok=True)
    with open(cache_filename, "w") as cached_command_record:
        cached_command_record.writelines("\n".join(commands) + "\n")
    print("Wrote:", cache_filename)
    cprint("Done", "green")
    print()


def cached_apt_install(package: str, title: Optional[str] = None):
    """Istall a package using apt and the cached_run mechanism."""
    # Give a standard title if none given
    if title == None:
        title = "Installing " + package

    # Run apt install on the package
    cached_run(title, [f"{APT_INSTALL} {package}"])


def user_exists(user):
    """Returns true if the named user exists"""
    return bool(subprocess.run(["getent", "passwd", user], capture_output=True).stdout)


def user_is_root():
    """Returns true if this user has passwordless sudo access."""
    try:
        # Try to run a harmless sudo command with -n flag (non-interactive)
        # This will fail if user needs a password for sudo
        result = subprocess.run(
            ["sudo", "-n", "true"],
            capture_output=True,
            text=True
        )
        return result.returncode == 0
    except Exception:
        return False

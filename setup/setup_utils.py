"""
This file lets you run a set of commands and cache them so that they
they needn't be run a second time.
"""
from termcolor import cprint
import os
import sys
import hashlib
import pickle
import xdg
import subprocess

def cached_run(title, commands, skip_if=False):
    """Runs the given set of commands, prepending the title."""
    # Inidcate the command we're running
    cprint(f'{title}...', 'blue', attrs=['bold'])

    # Create the cache filename
    hasher = hashlib.sha256()
    hasher.update(pickle.dumps((title, commands)))
    cache_folder = os.path.join(xdg.XDG_CACHE_HOME, 'dev-env')
    cache_filename = f"{hasher.hexdigest()}_{title.lower().replace(' ', '_')}.txt"
    cache_filename = os.path.join(cache_folder, cache_filename)

    # Skip running the command if the skip_if command is true.
    if skip_if:
        cprint('Skipping', 'cyan')
        print()
        return

    # Skip running the command if we already have it cached
    if os.path.exists(cache_filename):
        cprint('Already done', 'cyan')
        print()
        return

    # Run the commmands
    for command in commands:
        cprint(command, attrs=['bold'])
        return_value = os.system(command)
        if return_value != 0:
            cprint(f'Error: {return_value}', 'red', attrs=['bold'])
            sys.exit(return_value)

    # Write the cached file.
    os.makedirs(cache_folder, exist_ok=True)
    with open(cache_filename, 'w') as cached_command_record:
        cached_command_record.writelines('\n'.join(commands) + '\n')
    print('Wrote:', cache_filename)
    cprint('Done', 'green')
    print()

def user_exists(user):
    """Returns true if the named user exists"""
    return bool(subprocess.run(["getent", "passwd", user], capture_output=True).stdout)

def user_is_root():
    """Returns true if this user is root."""
    return os.geteuid() == 0


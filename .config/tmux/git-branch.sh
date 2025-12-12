#!/bin/bash
# Get git branch for tmux status line
# Usage: git-branch.sh /path/to/directory

cd "$1" 2>/dev/null || { echo "No repo"; exit 0; }
branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
[ -n "$branch" ] && echo "${branch}" || echo "◌"
# [ -n "$branch" ] && echo "${branch}" || echo "∅"

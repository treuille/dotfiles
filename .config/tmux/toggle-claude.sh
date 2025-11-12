#!/usr/bin/env bash

# Find pane running claude in the current window
claude_pane=$(tmux list-panes -F '#{pane_id} #{pane_current_command}' | awk '/claude$/ {print $1; exit}')

if [ -n "$claude_pane" ]; then
    # Claude is running in this window, kill it
    tmux kill-pane -t "$claude_pane"
else
    # No Claude in this window, open it
    tmux split-window -h -c '#{pane_current_path}' 'zsh -i -c claude'
fi

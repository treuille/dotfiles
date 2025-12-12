#!/bin/bash
# Generate git branch pills for all panes in current window
# Usage: pane-branches.sh

# Catppuccin Mocha palette
# Base colors
ROSEWATER="#f5e0dc"
FLAMINGO="#f2cdcd"
PINK="#f5c2e7"
MAUVE="#cba6f7"
RED="#f38ba8"
MAROON="#eba0ac"
PEACH="#fab387"
YELLOW="#f9e2af"
GREEN="#a6e3a1"
TEAL="#94e2d5"
SKY="#89dceb"
SAPPHIRE="#74c7ec"
BLUE="#89b4fa"
LAVENDER="#b4befe"

# Text colors
TEXT="#cdd6f4"
SUBTEXT1="#bac2de"
SUBTEXT0="#a6adc8"

# Surface colors
OVERLAY2="#9399b2"
OVERLAY1="#7f849c"
OVERLAY0="#6c7086"
SURFACE2="#585b70"
SURFACE1="#45475a"
SURFACE0="#313244"

# Base colors
BASE="#1e1e2e"
MANTLE="#181825"
CRUST="#11111b"

# Alias for active color
ACTIVE="$ROSEWATER" # <- I like this a lot
ACTIVE="$PINK" # <- I like this maybe more?
ACTIVE="$PEACH" # <- I like this maybe more
ACTIVE="$YELLOW" # <- I like this maybe more

# Alias for background
BG="$MANTLE"

# Get all panes in current window
tmux list-panes -F '#{pane_id} #{pane_current_path} #{pane_active}' | while read -r pane_id pane_path is_active; do
    # Get git branch for this pane's directory
    branch=$(cd "$pane_path" 2>/dev/null && git rev-parse --abbrev-ref HEAD 2>/dev/null)
    [ -z "$branch" ] && branch="◌"

    if [ "$is_active" = "1" ]; then
        # Active pane - highlighted (mauve icon pill + surface0 text pill)
        printf "#[fg=${ACTIVE},bg=${BG}]#[fg=${CRUST},bg=${ACTIVE}] #[fg=${TEXT},bg=${SURFACE0}] %s #[fg=${SURFACE0},bg=${BG}]#[default] " "$branch"
    else
        # Inactive pane - dimmed (surface1 icon pill + surface0 text pill)
        printf "#[fg=${SURFACE1},bg=${BG}]#[fg=${OVERLAY1},bg=${SURFACE1}] #[fg=${SUBTEXT0},bg=${SURFACE0}] %s #[fg=${SURFACE0},bg=${BG}]#[default] " "$branch"
    fi
done

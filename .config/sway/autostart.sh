#!/bin/bash
# Sway autostart script - launches apps based on which monitors are connected

# Wait for Sway to fully initialize
sleep 2

# Get list of connected outputs
outputs=$(swaymsg -t get_outputs | jq -r '.[].name')

# Check which monitors are connected
is_home=false
is_work_l3=false
is_work_l5=false

if echo "$outputs" | grep -q "DP-3"; then
    is_home=true
fi

if echo "$outputs" | grep -q "DP-1\|DP-2"; then
    is_work_l3=true
fi

if echo "$outputs" | grep -q "DP-6\|DP-7"; then
    is_work_l5=true
fi

# Always start these apps
swaymsg 'workspace 1; exec kitty'
swaymsg 'workspace 2; exec ~/.local/bin/zen'
swaymsg 'workspace 4; exec ~/.local/bin/zen'

# Only start work apps if work monitors are detected
if $is_work_l3 || $is_work_l5; then
    echo "Work monitors detected, starting work apps..."
    swaymsg 'workspace 3; exec teams-for-linux'
    swaymsg 'workspace 3; exec webex'
else
    swaymsg 'workspace 3; exec discord'
fi

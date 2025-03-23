# Sway Window Manager Configuration

## Table of Contents
1. [Key Variables](#key-variables)
2. [Monitor Configuration](#monitor-configuration)
3. [Workspace Configuration](#workspace-configuration)
4. [Key Bindings](#key-bindings)
5. [Window Decorations](#window-decorations)
6. [Status Bar](#status-bar)
7. [Associated Scripts](#associated-scripts)

## Key Variables

```
set $mod Mod1
set $term foot
set $menu wofi --show drun -i
```

- `$mod`: Set to Alt key (Mod1)
- `$term`: Terminal emulator set to foot
- `$menu`: Application launcher set to wofi

## Monitor Configuration

```
set $monitor2 DP-3  # main monitor
set $monitor3 HDMI-A-2 #secondary monitor

output $monitor2 resolution 3840x2560 position 0,0
output $monitor3 resolution 1920x1080 position 3840,0

output $monitor2 scale 2
```

- Configures the monitors
- Sets resolution and position for external monitors
- Scales the 4k monitor to keep pixel density but make everything larger on the screen

## Workspace Configuration

```
set $ws1 "Productivity"
set $ws2 "Leisure"
set $ws3 "Flex"
set $ws4 "Dump"

workspace $ws1 output $monitor2
workspace $ws2 output $monitor2
workspace $ws4 output $monitor2
workspace $ws3 output $monitor3
```

- Defines four named workspaces
- Assigns workspaces to specific monitors
- Configures default layouts for workspaces

## Key Bindings

- `$mod+Return`: Open terminal
- `$mod+Shift+q`: Kill focused window
- `$mod+d`: Open application launcher
- `$mod+Shift+c`: Reload configuration
- `$mod+Shift+e`: Exit Sway
- `$mod+Space`: Play/pause current video
- `$mod+Shift+s`: Screenshot tool
- `$mod+[h|j|k|l]`: Move focus
- `$mod+Shift+[h|j|k|l]`: Move windows
- `$mod+[1-4]`: Switch to workspace
- `$mod+Shift+[1-4]`: Move container to workspace
- `$mod+[b|v]`: Horizontal/vertical splits
- `$mod+[s|w|e]`: Change layout styles
- `$mod+f`: Fullscreen
- `$mod+Shift+space`: Toggle floating
- `$mod+Shift+b`: Toggle Discord window (custom script)

## Window Decorations

```
default_border pixel 4
gaps inner 5
gaps outer 5
focus_follows_mouse no
```

- Removes title bars
- Sets inner and outer gaps
- Disables focus on hover

## Status Bar

```
bar {
  swaybar_command waybar
}
```

Uses Waybar as the status bar.

## Associated Scripts

### power_menu.sh

A custom power menu script that provides options for logout, suspend, reboot, and shutdown using wofi.

Usage: Bind to a key combination (not shown in the provided config)

### toggle_discord.sh

A script to toggle the Discord window between workspaces.

Usage: Bound to `$mod+Shift+b`

Key features:
- Swaps Discord with the currently focused window
- Focuses Discord when swapped
- Remembers the previous window for swapping back

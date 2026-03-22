# Waybar GNOME-Style Menu System

A polished, GNOME-like menu system for Sway + Waybar using Rofi.

## Available Menus

### 🎛️ Audio Control
**Location:** Waybar - "Vol" indicator  
**Click:** Opens audio menu  
**Right-click:** Toggle mute  

**Features:**
- Volume control (+5%/-5% increments)
- Mute/unmute
- Switch output devices (speakers, headphones, etc.)
- Switch input devices (microphones)
- Quick access to Sound Settings (pavucontrol)

### 🌐 Network Manager
**Location:** Waybar - "WiFi" or "Eth" indicator  
**Click:** Opens network menu

**Features:**
- Current connection status with signal strength
- Connect/disconnect WiFi
- Visual signal strength indicators (▂▄▆█)
- Secure network indicators (🔒)
- Password prompt for secured networks
- Scan for new networks
- Quick VPN access
- Network settings (nm-connection-editor)

### 🔐 VPN Manager
**Location:** Waybar - "VPN" indicator  
**Click:** Opens VPN menu

**Features:**
- Current VPN status
- Quick connect/disconnect
- List all configured VPN connections
- Add new VPN connections
- Visual indicators for active connections

### 💻 System Information
**Location:** Waybar - "System" indicator  
**Click:** Opens system menu

**Features:**
- CPU usage and load average
- CPU temperature
- Memory usage (used/total)
- Disk usage
- GPU info (if NVIDIA GPU present)
- System uptime
- Launch Task Manager (htop)
- Launch System Monitor (gnome-system-monitor or btop)

### 📅 Calendar & Time
**Location:** Waybar - Clock display  
**Click:** Opens calendar menu

**Features:**
- Current date and time
- Week number
- Monthly calendar view
- World clock (multiple timezones)
- Time & date settings

### ⚡ Power Menu
**Location:** Waybar - "Power" indicator  
**Click:** Opens power menu

**Features:**
- Lock screen (swaylock)
- Log out (with confirmation)
- Suspend
- Reboot (with confirmation)
- Power off (with confirmation)

## Visual Features

### Modern GNOME-Style Design
- **Translucent backgrounds** with blur effects
- **Tokyo Night color scheme** - dark, modern, easy on the eyes
- **Smooth hover animations** - visual feedback on interaction
- **Smart positioning** - menus appear near their waybar icons
- **Professional typography** - JetBrainsMono Nerd Font with icons
- **Color-coded modules:**
  - System: Green (#a6e3a1)
  - VPN: Blue (#89b4fa)
  - Power: Pink (#f38ba8)
  - Network: Cyan (#7dcfff)
  - Audio: Purple (#bb9af7)
  - Clock: Orange (#e0af68)

### Interaction Design
- **Hover effects** - modules glow on hover with subtle shadows
- **Visual hierarchy** - clear separation of sections with dividers
- **Icon consistency** - Nerd Font icons throughout
- **Smart selection** - currently active items clearly marked
- **Confirmation dialogs** - for destructive actions (reboot, shutdown, logout)

## Configuration Files

### Rofi Themes
- `~/.config/rofi/gnome-style.rasi` - Base theme
- `~/.config/rofi/power-menu.rasi` - Power menu (bottom-right)
- `~/.config/rofi/audio-menu.rasi` - Audio menu (bottom-center)
- `~/.config/rofi/network-menu.rasi` - Network menu (bottom-center)
- `~/.config/rofi/system-menu.rasi` - System menu (bottom-left)

### Waybar Configuration
- `~/.config/waybar/config.jsonc` - Main config
- `~/.config/waybar/modules.json` - Module definitions
- `~/.config/waybar/style.css` - Visual styling

### Menu Scripts
- `~/.local/bin/waybar-audio-menu` - Audio control
- `~/.local/bin/waybar-network-menu` - Network management
- `~/.local/bin/waybar-vpn-menu` - VPN management
- `~/.local/bin/waybar-vpn-status` - VPN status indicator
- `~/.local/bin/waybar-system-menu` - System information
- `~/.local/bin/waybar-system-status` - System status indicator
- `~/.local/bin/waybar-power-menu` - Power options
- `~/.local/bin/waybar-calendar-menu` - Calendar & time

## Keyboard Navigation

All menus support:
- **Arrow keys** - Navigate options
- **Enter** - Select option
- **Escape** - Close menu
- **Type to search** - Filter options by typing

## Customization

### Change Colors
Edit `~/.config/rofi/gnome-style.rasi` and modify the color variables:
- `bg-main` - Background color
- `fg-main` - Text color
- `bg-selected` - Selected item background
- `info-color`, `success-color`, `warning-color`, `error-color` - Accent colors

### Change Position
Each menu theme has location settings:
- `location: south` - Bottom of screen
- `location: south east` - Bottom-right
- `location: south west` - Bottom-left
- Adjust `x-offset` and `y-offset` for fine-tuning

### Change Font
Edit `~/.config/rofi/gnome-style.rasi`:
```css
font: "Your Font Name Size";
```

## Dependencies

Required packages:
- `waybar` - Status bar
- `rofi` - Menu system
- `pulseaudio-utils` or `pipewire-pulse` - Audio control
- `networkmanager` - Network management
- `swaylock` - Screen locking

Optional packages:
- `pavucontrol` - Advanced audio settings
- `nm-connection-editor` - Network configuration GUI
- `gnome-system-monitor` - System monitor GUI
- `htop` / `btop` - Terminal system monitors
- `notify-send` - Desktop notifications

## Tips

1. **Hover over modules** to see them highlight
2. **Right-click audio** for quick mute toggle
3. **Scroll on workspaces** to switch between them
4. **Click calendar** to see monthly view and world time
5. **System menu** refreshes on each open to show current stats

## Troubleshooting

### Waybar not showing
```bash
pkill waybar
waybar -c ~/.config/waybar/config.jsonc -s ~/.config/waybar/style.css &
```

### Menu doesn't open
Check if scripts are executable:
```bash
chmod +x ~/.local/bin/waybar-*
```

### Wrong colors/theme
Verify rofi config is linked:
```bash
ls -la ~/.config/rofi
```

### Font icons not showing
Install JetBrainsMono Nerd Font:
```bash
# You'll need to install this - I can't run sudo commands
# Check your distro's package manager
```

Enjoy your polished, professional desktop environment! 🎉

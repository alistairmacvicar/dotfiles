# 🎨 Your GNOME-Style Waybar Menu System

## ✅ What's Been Set Up

You now have a **polished, professional menu system** that mimics GNOME's behavior, built with:
- **Waybar** - Modern status bar
- **Rofi** - Beautiful menu system
- **Custom scripts** - Comprehensive functionality

## 🎯 How to Use Your Menus

### Click on These Waybar Modules:

1. **"Vol"** → Audio menu (volume, devices)
2. **"WiFi" / "Eth"** → Network menu (connect to WiFi, manage connections)
3. **"VPN"** → VPN menu (connect/disconnect VPNs)
4. **"System"** → System info (CPU, RAM, disk usage)
5. **Clock** → Calendar & world clock
6. **"Power"** → Power options (lock, logout, reboot, shutdown)

## 🎨 Visual Style

Your menus feature:
- **Dark translucent background** (Tokyo Night color scheme)
- **Smooth hover effects** on waybar modules
- **Icons throughout** using Nerd Fonts
- **Smart positioning** - menus appear near their icons
- **Professional typography** with JetBrainsMono

## 📍 Menu Locations

- **Power Menu** → Bottom-right corner
- **Audio/Network/VPN** → Bottom-center
- **System** → Bottom-left
- **Calendar** → Bottom-center

## ⌨️ Keyboard Controls

In any menu:
- **Arrow keys** - Navigate
- **Enter** - Select
- **Escape** - Close
- **Type** - Search/filter

## 🎵 Audio Menu Features
- Adjust volume in 5% increments
- Quick mute/unmute (or right-click waybar icon)
- Switch output devices (headphones, speakers, etc.)
- Switch input devices (microphones)
- Launch pavucontrol for advanced settings

## 🌐 Network Menu Features
- See current connection & signal strength
- Visual signal indicators: ▂▄▆█
- Connect to WiFi networks (with password prompt)
- Disconnect WiFi
- Scan for new networks
- Quick VPN access
- Launch network settings

## 🔐 VPN Menu Features
- See active VPN connection
- Quick connect/disconnect
- List all configured VPNs
- Add new VPN connections

## 💻 System Menu Features
- Real-time CPU usage & load
- Memory usage (used/total %)
- Disk usage
- CPU temperature
- GPU info (if NVIDIA)
- System uptime
- Launch htop/btop/system-monitor

## 📅 Calendar Menu Features
- Current date & time
- Week number
- Monthly calendar view
- World clock (multiple timezones)
- Access time settings

## ⚡ Power Menu Features
- **Lock** - Lock screen with swaylock
- **Log Out** - Exit Sway (with confirmation)
- **Suspend** - Suspend system
- **Reboot** - Restart (with confirmation)
- **Shutdown** - Power off (with confirmation)

## 🎨 Customization

### Change Colors
Edit: `~/.config/rofi/theme.rasi`

The main color variables are at the top:
```css
bg0: #1a1b26f5;  /* Background */
bg1: #16161ef0;  /* Input field background */
bg2: #283457;    /* Selected item */
fg0: #c0caf5;    /* Text */
fg2: #7dcfff;    /* Highlighted text */
```

### Change Font
Edit both files:
- `~/.config/rofi/theme.rasi` → `font: "YourFont 11";`
- `~/.config/waybar/style.css` → `font-family: "YourFont", ...;`

### Adjust Menu Positioning
Each script has positioning in its rofi call:
- `location: south` = bottom center
- `location: southeast` = bottom right
- `location: southwest` = bottom left
- Adjust `x-offset` and `y-offset` values

## 📁 File Locations

### Rofi Configuration
- `~/.config/rofi/config.rasi` - Main config
- `~/.config/rofi/theme.rasi` - Visual theme

### Waybar Configuration
- `~/.config/waybar/config.jsonc` - Main config
- `~/.config/waybar/modules.json` - Module definitions
- `~/.config/waybar/style.css` - Visual styling

### Menu Scripts (all in `~/.local/bin/`)
- `waybar-audio-menu` - Audio control
- `waybar-calendar-menu` - Calendar & time
- `waybar-network-menu` - Network management
- `waybar-power-menu` - Power options
- `waybar-system-menu` - System information
- `waybar-vpn-menu` - VPN management
- `waybar-system-status` - System status indicator
- `waybar-vpn-status` - VPN status indicator

## 🔧 Troubleshooting

### Menu doesn't open when clicking
```bash
# Check if scripts are executable
chmod +x ~/.local/bin/waybar-*

# Test a menu manually
waybar-audio-menu
```

### Waybar not showing
```bash
# Restart waybar
pkill waybar
waybar -c ~/.config/waybar/config.jsonc -s ~/.config/waybar/style.css &
```

### Rofi looks wrong
```bash
# Test the theme
echo -e "Test 1\nTest 2" | rofi -dmenu -theme ~/.config/rofi/theme.rasi -p "Test"
```

### Icons not showing
You need **JetBrainsMono Nerd Font** installed. To install it, run:
```bash
sudo apt install fonts-jetbrains-mono  # Ubuntu/Debian
# OR download from: https://www.nerdfonts.com/
```

## 🎉 Additional Features

### Right-Click Actions
- **Audio module** → Quick mute toggle
- **Volume scroll** → Adjust volume

### Smart Behaviors
- **System status** updates every 5 seconds
- **VPN status** updates every 5 seconds
- **Network menu** shows signal strength in real-time
- **Confirmation dialogs** for destructive actions
- **Password prompts** for secured WiFi networks

### Notifications
Many actions trigger desktop notifications:
- "Connected to WiFi"
- "VPN Connected"
- "Audio device switched"
- etc.

## 📝 Pro Tips

1. **Hover over modules** to see them highlight
2. **Type in menus** to filter options quickly
3. **Check the system menu** for resource usage at a glance
4. **Use the calendar** to check week numbers
5. **World clock** in calendar menu for timezone conversions

## 🚀 Next Steps

Want to enhance further? Consider:
- Adding more custom modules to waybar
- Creating keyboard shortcuts for menus (in sway config)
- Customizing notification behavior
- Adding weather, media controls, etc.

---

**Enjoy your polished, GNOME-like desktop environment!** 🎨✨

Everything should now feel smooth, professional, and intuitive - just like a full desktop environment, but with the flexibility of Sway!

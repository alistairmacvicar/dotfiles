#!/bin/bash

#############################################################################
# System Installation Script for Ubuntu
# Sets up a fresh Ubuntu system with Sway, essential apps, and dotfiles
#############################################################################

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
DOTFILES_DIR="$HOME/dotfiles"
DOTFILES_REPO="https://github.com/xKaimac/dotfiles.git"

#############################################################################
# Helper Functions
#############################################################################

print_step() {
    echo -e "${BLUE}==>${NC} ${GREEN}$1${NC}"
}

print_warning() {
    echo -e "${YELLOW}Warning:${NC} $1"
}

print_error() {
    echo -e "${RED}Error:${NC} $1"
}

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

#############################################################################
# System Update and Base Packages
#############################################################################

install_base_packages() {
    print_step "Updating system and installing base packages..."
    
    sudo apt update
    sudo apt upgrade -y
    
    # Essential build tools and dependencies
    sudo apt install -y \
        build-essential \
        git \
        curl \
        wget \
        unzip \
        software-properties-common \
        apt-transport-https \
        ca-certificates \
        gnupg \
        lsb-release \
        python3 \
        python3-pip \
        python3-venv \
        jq \
        ripgrep \
        fd-find \
        fzf \
        stow
}

#############################################################################
# Sway and Wayland Dependencies
#############################################################################

install_sway_environment() {
    print_step "Installing Sway and Wayland environment..."
    
    sudo apt install -y \
        sway \
        swaybg \
        swaylock \
        swayidle \
        waybar \
        mako-notifier \
        wl-clipboard \
        xdg-desktop-portal-wlr \
        grim \
        slurp \
        wf-recorder \
        wtype \
        wlsunset \
        dex \
        xwayland \
        dunst
}

#############################################################################
# Compositor and Window Manager Utilities
#############################################################################

install_wm_utilities() {
    print_step "Installing window manager utilities..."
    
    sudo apt install -y \
        picom \
        network-manager-gnome \
        volumeicon-alsa \
        pavucontrol \
        pulseaudio \
        pipewire \
        pipewire-pulse \
        libnotify-bin
}

#############################################################################
# Terminal and Shell Tools
#############################################################################

install_terminal_tools() {
    print_step "Installing terminal emulator and shell tools..."
    
    # Kitty terminal
    sudo apt install -y kitty
    
    # Tmux
    sudo apt install -y tmux
    
    # Additional shell tools
    sudo apt install -y \
        bash-completion \
        shellcheck \
        btop \
        htop \
        ncdu \
        tree \
        ranger
}

#############################################################################
# Rofi (Application Launcher)
#############################################################################

install_rofi() {
    print_step "Installing Rofi application launcher..."
    
    sudo apt install -y rofi
}

#############################################################################
# Neovim
#############################################################################

install_neovim() {
    print_step "Installing Neovim..."
    
    # Install from Ubuntu PPA for latest version
    sudo add-apt-repository -y ppa:neovim-ppa/unstable
    sudo apt update
    sudo apt install -y neovim
    
    # Install neovim dependencies
    sudo apt install -y \
        python3-neovim \
        xclip \
        xsel
    
    # Install Node.js for LSP servers
    if ! command_exists node; then
        print_step "Installing Node.js..."
        curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
        sudo apt install -y nodejs
    fi
    
    # Install additional LSP dependencies
    sudo npm install -g neovim tree-sitter-cli
}

#############################################################################
# Discord
#############################################################################

install_discord() {
    print_step "Installing Discord..."
    
    if ! command_exists discord; then
        wget -O /tmp/discord.deb "https://discord.com/api/download?platform=linux&format=deb"
        sudo apt install -y /tmp/discord.deb
        rm /tmp/discord.deb
    else
        print_warning "Discord already installed"
    fi
}

#############################################################################
# Microsoft Teams (teams-for-linux)
#############################################################################

install_teams() {
    print_step "Installing Microsoft Teams..."
    
    if ! command_exists teams-for-linux; then
        # Install teams-for-linux from flatpak or snap
        if command_exists flatpak; then
            flatpak install -y flathub com.github.IsmaelMartinez.teams_for_linux
        else
            sudo snap install teams-for-linux
        fi
    else
        print_warning "Teams already installed"
    fi
}

#############################################################################
# Cisco Webex
#############################################################################

install_webex() {
    print_step "Installing Cisco Webex..."
    
    if ! command_exists webex; then
        # Download and install Webex
        wget -O /tmp/webex.deb "https://binaries.webex.com/WebexDesktop-Ubuntu-Official-Package/Webex.deb"
        sudo apt install -y /tmp/webex.deb
        rm /tmp/webex.deb
    else
        print_warning "Webex already installed"
    fi
}

#############################################################################
# Zen Browser
#############################################################################

install_zen_browser() {
    print_step "Installing Zen Browser..."
    
    ZEN_DIR="$HOME/.local/zen"
    ZEN_BIN="$HOME/.local/bin/zen"
    
    if [ ! -f "$ZEN_BIN" ]; then
        mkdir -p "$HOME/.local/bin"
        mkdir -p "$ZEN_DIR"
        
        # Download latest Zen Browser (adjust URL as needed)
        print_warning "Zen Browser requires manual download from https://zen-browser.app/"
        print_warning "After downloading, extract to $ZEN_DIR and create symlink at $ZEN_BIN"
        
        # Create placeholder script
        cat > "$ZEN_BIN" << 'EOF'
#!/bin/bash
# Zen Browser launcher
# Download Zen Browser from https://zen-browser.app/
# Extract to ~/.local/zen/ and update this script
exec "$HOME/.local/zen/zen" "$@"
EOF
        chmod +x "$ZEN_BIN"
    else
        print_warning "Zen Browser already installed"
    fi
}

#############################################################################
# Fonts
#############################################################################

install_fonts() {
    print_step "Installing fonts..."
    
    # Install basic fonts
    sudo apt install -y \
        fonts-noto \
        fonts-noto-color-emoji \
        fonts-font-awesome \
        fonts-powerline
    
    # Install JetBrains Mono Nerd Font
    FONT_DIR="$HOME/.local/share/fonts"
    mkdir -p "$FONT_DIR"
    
    if [ ! -d "$FONT_DIR/JetBrainsMono" ]; then
        print_step "Installing JetBrains Mono Nerd Font..."
        NERD_FONT_VERSION="v3.1.1"
        wget -O /tmp/JetBrainsMono.zip "https://github.com/ryanoasis/nerd-fonts/releases/download/${NERD_FONT_VERSION}/JetBrainsMono.zip"
        unzip -q /tmp/JetBrainsMono.zip -d "$FONT_DIR/JetBrainsMono"
        rm /tmp/JetBrainsMono.zip
    fi
    
    # Copy Monaspace fonts from dotfiles if they exist
    if [ -d "$DOTFILES_DIR/.local/share/fonts/Monaspace" ]; then
        print_step "Copying Monaspace fonts from dotfiles..."
        cp -r "$DOTFILES_DIR/.local/share/fonts/Monaspace" "$FONT_DIR/"
    fi
    
    # Rebuild font cache
    fc-cache -fv
}

#############################################################################
# Additional Development Tools
#############################################################################

install_dev_tools() {
    print_step "Installing development tools..."
    
    # Git configuration
    if ! git config --global user.name >/dev/null 2>&1; then
        print_warning "Please configure git:"
        echo "  git config --global user.name 'Your Name'"
        echo "  git config --global user.email 'your.email@example.com'"
    fi
    
    # Lazygit
    if ! command_exists lazygit; then
        LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
        curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
        tar xf lazygit.tar.gz lazygit
        sudo install lazygit /usr/local/bin
        rm lazygit lazygit.tar.gz
    fi
    
    # GitHub CLI
    if ! command_exists gh; then
        curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
        sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
        sudo apt update
        sudo apt install -y gh
    fi
    
    # Flameshot (screenshot tool)
    sudo apt install -y flameshot
}

#############################################################################
# Dotfiles Setup
#############################################################################

setup_dotfiles() {
    print_step "Setting up dotfiles..."
    
    # Clone dotfiles if not present
    if [ ! -d "$DOTFILES_DIR" ]; then
        print_step "Cloning dotfiles repository..."
        git clone --recurse-submodules "$DOTFILES_REPO" "$DOTFILES_DIR"
        cd "$DOTFILES_DIR"
        git submodule update --init --recursive
    else
        print_warning "Dotfiles directory already exists at $DOTFILES_DIR"
    fi
    
    # Create necessary directories
    mkdir -p ~/.config
    mkdir -p ~/.local/bin
    mkdir -p ~/.local/share
    
    print_step "Creating symlinks for configuration files..."
    
    # Symlink configs
    declare -a configs=(
        "nvim"
        "sway"
        "rofi"
        "kitty"
        "waybar"
        "wofi"
        "picom"
        "dunst"
        "btop"
        "lazygit"
        "tmux-sessionizer"
        "foot"
        "systemd"
        "autostart"
        "environment.d"
    )
    
    for config in "${configs[@]}"; do
        if [ -e "$DOTFILES_DIR/.config/$config" ]; then
            # Backup existing config
            if [ -e "$HOME/.config/$config" ] && [ ! -L "$HOME/.config/$config" ]; then
                print_warning "Backing up existing $config to $HOME/.config/${config}.backup"
                mv "$HOME/.config/$config" "$HOME/.config/${config}.backup"
            fi
            
            # Create symlink
            ln -sf "$DOTFILES_DIR/.config/$config" "$HOME/.config/$config"
            print_step "Linked ~/.config/$config"
        fi
    done
    
    # Symlink home directory files
    ln -sf "$DOTFILES_DIR/.tmux.conf" "$HOME/.tmux.conf"
    ln -sf "$DOTFILES_DIR/.bashrc" "$HOME/.bashrc"
    ln -sf "$DOTFILES_DIR/.inputrc" "$HOME/.inputrc"
    
    # Symlink local bin scripts
    if [ -d "$DOTFILES_DIR/.local/bin" ]; then
        for script in "$DOTFILES_DIR/.local/bin"/*; do
            script_name=$(basename "$script")
            ln -sf "$script" "$HOME/.local/bin/$script_name"
        done
        print_step "Linked ~/.local/bin scripts"
    fi
    
    # Symlink tmux directory
    if [ -d "$DOTFILES_DIR/.tmux" ]; then
        ln -sf "$DOTFILES_DIR/.tmux" "$HOME/.tmux"
    fi
    
    # Make scripts executable
    chmod +x "$HOME/.local/bin"/* 2>/dev/null || true
    chmod +x "$HOME/.config/sway"/*.sh 2>/dev/null || true
}

#############################################################################
# Post-Installation Configuration
#############################################################################

post_install() {
    print_step "Running post-installation tasks..."
    
    # Add user to necessary groups
    sudo usermod -aG input "$USER" || true
    sudo usermod -aG video "$USER" || true
    
    # Enable pipewire
    systemctl --user enable pipewire pipewire-pulse 2>/dev/null || true
    
    # Create backgrounds directory
    mkdir -p "$HOME/Pictures/backgrounds"
    
    print_step "Installation complete!"
    echo ""
    print_warning "Post-installation steps:"
    echo "1. Log out and log back in for group changes to take effect"
    echo "2. Select 'Sway' from your display manager login screen"
    echo "3. Download a background image to ~/Pictures/backgrounds/cozy_room.png"
    echo "4. Configure git with your name and email if not already done"
    echo "5. Run 'gh auth login' to authenticate with GitHub"
    echo "6. Download Zen Browser from https://zen-browser.app/ and extract to ~/.local/zen/"
    echo "7. Source your new bashrc: source ~/.bashrc"
    echo ""
    print_step "Enjoy your new system!"
}

#############################################################################
# Main Installation Flow
#############################################################################

main() {
    echo "╔════════════════════════════════════════════════════════════╗"
    echo "║     Ubuntu System Installation Script                      ║"
    echo "║     Setting up Sway, Neovim, and essential tools          ║"
    echo "╚════════════════════════════════════════════════════════════╝"
    echo ""
    
    # Prompt for confirmation
    read -p "This will install packages and modify your system. Continue? (y/N) " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_error "Installation cancelled"
        exit 1
    fi
    
    # Run installation steps
    install_base_packages
    install_sway_environment
    install_wm_utilities
    install_terminal_tools
    install_rofi
    install_neovim
    install_discord
    install_teams
    install_webex
    install_zen_browser
    install_fonts
    install_dev_tools
    setup_dotfiles
    post_install
}

# Run main function
main "$@"

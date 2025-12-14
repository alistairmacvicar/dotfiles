# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export LUA_PATH="./?.lua;./?/init.lua;./lua/?/init.lua;;"

# Dotfiles management alias
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Ctrl+o to swap from headphones to speakers
swap_audio_output() {
  local HEADPHONES="alsa_output.usb-audio-techn_AT2020USB_-00.analog-stereo"
  local SPEAKERS="alsa_output.usb-DELL_Dell_Speakerphone_SP3022_0-02.analog-stereo"
  local CURRENT_SINK=$(pactl get-default-sink)

  if [ "$CURRENT_SINK" = "$HEADPHONES" ]; then
    echo "Switching to speakers"
    pactl set-default-sink "$SPEAKERS"
  else
    echo "Switching to headphones"
    pactl set-default-sink "$HEADPHONES"
  fi
}
bind -x '"\C-o": swap_audio_output'

# Ctrl+t to open tmux-sessioniser
tmux_sessionizer() {
  ~/.local/bin/tmux-sessionizer
}
bind -x '"\C-t": tmux-sessionizer'

# Bitwarden wrapper function to auto-export session key
bw() {
  local BW_BIN=$(command -v bw)
  
  if [ "$1" = "login" ]; then
    # Run bw login with all arguments
    "$BW_BIN" "$@"
    local login_status=$?
    
    # If login succeeded, unlock and export session key
    if [ $login_status -eq 0 ]; then
      echo "Login successful. Unlocking and exporting session key..."
      export BW_SESSION=$("$BW_BIN" unlock --raw)
      if [ -n "$BW_SESSION" ]; then
        echo "BW_SESSION exported successfully"
      fi
    fi
    return $login_status
  else
    # Pass through all other bw commands
    "$BW_BIN" "$@"
  fi
}

# Git-aware prompt
parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

# Prompt colors
COLOR_RESET='\[\033[0m\]'
COLOR_USER='\[\033[01;32m\]'      # Green
COLOR_PATH='\[\033[01;34m\]'      # Blue
COLOR_GIT='\[\033[01;33m\]'       # Yellow

# Set prompt: user@host:path (git-branch) $
PS1="${COLOR_USER}\u@\h${COLOR_RESET}:${COLOR_PATH}\w${COLOR_RESET} ${COLOR_GIT}\$(parse_git_branch)${COLOR_RESET}\$ "

# Wine isolation - prevent Wine from intercepting native operations
export WINEDLLOVERRIDES="winemenubuilder.exe=d"
export WINE_DONT_USE_XDG_DIRECTORIES=1

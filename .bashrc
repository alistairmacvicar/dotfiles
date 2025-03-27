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

# Ctrl+F for fzf directory navigation
fzf_cd() {
  cd $(find * -type d | fzf)
}

bind -x '"\C-f": fzf_cd'

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
tmux_sessioniser() {
  ~/.local/bin/tmux-sessioniser
}
bind -x '"\C-t": tmux_sessioniser'

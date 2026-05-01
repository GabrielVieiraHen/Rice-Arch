#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
# MacOS minimal prompt
PS1='\[\e[34m\] \[\e[32m\]\u \[\e[33m\]\W \[\e[36m\]❯ \[\e[0m\]'

# Load fastfetch with a random image from kitty terminal folder
if command -v fastfetch &> /dev/null; then
    IMG_DIR="$HOME/.config/kitty/images-terminal"
    if [ -d "$IMG_DIR" ]; then
        IMG=$(find "$IMG_DIR" -type f | shuf -n 1)
        if [ -n "$IMG" ]; then
            fastfetch --logo "$IMG" --logo-type kitty --logo-width 25
        else
            fastfetch
        fi
    else
        fastfetch
    fi
fi
# Terminal Sound Effect (Open/Close)
# Check if running in Kitty
if [[ "$TERM" == "xterm-kitty" ]]; then
    if [ -z "$KITTY_SOUND_OPEN" ]; then
        (pw-play ~/.config/kitty/sound-terminal.wav >/dev/null 2>&1 &)
        export KITTY_SOUND_OPEN=1
    fi
    trap '(pw-play ~/.config/kitty/sound-terminal.wav >/dev/null 2>&1 &)' EXIT
fi


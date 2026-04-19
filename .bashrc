#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias ll='ls -la --color=auto'
alias la='ls -A --color=auto'
alias cls='clear'

# Import pywal colors for shell
(cat ~/.cache/wal/sequences &)

# ---- Beautiful Minimal Prompt ----
# Dynamically reads pywal colors
_get_wal_color() {
    local idx=$1
    sed -n "$((idx+1))p" ~/.cache/wal/colors 2>/dev/null
}

_build_prompt() {
    local exit_code=$?
    local C0='\[\e[0m\]'        # Reset
    
    # Read pywal accent colors
    local accent=$(_get_wal_color 3)   # Most vibrant (red for this wallpaper)
    local accent2=$(_get_wal_color 5)  # Secondary
    local accent3=$(_get_wal_color 6)  # Tertiary
    local fg=$(_get_wal_color 7)       # Foreground
    
    # Fallbacks
    [[ -z "$accent" ]] && accent="#D51A25"
    [[ -z "$accent2" ]] && accent2="#976366"
    [[ -z "$accent3" ]] && accent3="#B76A8A"
    [[ -z "$fg" ]] && fg="#cfc7c7"
    
    # Convert hex to ANSI 24-bit color
    _hex_fg() {
        local hex="${1#\#}"
        printf '\[\e[38;2;%d;%d;%dm\]' "0x${hex:0:2}" "0x${hex:2:2}" "0x${hex:4:2}"
    }
    
    local CA=$(_hex_fg "$accent")
    local CA2=$(_hex_fg "$accent2")
    local CA3=$(_hex_fg "$accent3")
    local CFG=$(_hex_fg "$fg")
    
    # Error indicator
    local indicator="❯"
    if [[ $exit_code -ne 0 ]]; then
        indicator="${CA}✘${C0}"
    fi
    
    # Directory (just basename for clean look)
    local dir="${PWD/#$HOME/~}"
    
    # Git branch (lightweight)
    local git_branch=""
    if git rev-parse --is-inside-work-tree &>/dev/null 2>&1; then
        git_branch=" ${CA2} $(git branch --show-current 2>/dev/null)${C0}"
    fi
    
    PS1="\n${CA2}╭─${C0} ${CA}${C0}${CFG} \u${C0} ${CA3}in${C0} ${CA}${dir}${C0}${git_branch}\n${CA2}╰─${C0} ${CA}${indicator}${C0} "
}

PROMPT_COMMAND=_build_prompt

# Kitty font fix
export TERM=xterm-256color

# ---- Aesthetic Apps (Auto-Sync) ----
clock() {
    # Force use color 3 (accent)
    tty-clock -c -B -C 3 -t "$@"
}

lava() {
    # Radius reduced to 4 for smaller, better looking balls
    lavat -c red -r 3 -R 2 -G "$@"
}

lava() {
    # Use color 3 from palette
    lavat -c magenta -r 8 -R 2 -G "$@"
}

lava() {
    (cat ~/.cache/wal/sequences &)
    lavat -c red -r 8 -R 2 -G "$@"
}

lava() {
    # Read hex colors from pywal for truecolor gradient
    local c1=$(sed -n '2p' ~/.cache/wal/colors | tr -d '#')
    local c2=$(sed -n '4p' ~/.cache/wal/colors | tr -d '#')
    lavat -g -c "$c1" -k "$c2" -r 8 -R 2 -G "$@"
}

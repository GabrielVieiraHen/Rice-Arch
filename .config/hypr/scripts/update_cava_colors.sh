#!/bin/bash
# Generates cava config with pywal gradient colors
# Run this after wal to update cava colors, then send SIGUSR2 to reload

source ~/.cache/wal/colors.sh 2>/dev/null

cat > ~/.config/cava/config << EOF
[general]
framerate = 60
bars = 0
bar_width = 2
bar_spacing = 1

[input]
method = pulse

[output]
method = noncurses
orientation = bottom
channels = mono

[color]
background = default
foreground = default

gradient = 1
gradient_count = 4
gradient_color_1 = '${color2:-#A2101F}'
gradient_color_2 = '${color3:-#D51A25}'
gradient_color_3 = '${color6:-#B76A8A}'
gradient_color_4 = '${color5:-#976366}'

[smoothing]
noise_reduction = 66
EOF

# Reload all running cava instances (color only, no restart needed)
pkill -SIGUSR2 cava 2>/dev/null

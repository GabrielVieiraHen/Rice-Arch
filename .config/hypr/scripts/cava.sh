#!/bin/bash

# Waybar Cava Script with Pywal colors
config_file="/tmp/waybar_cava_config"

# Read pywal colors for gradient
source ~/.cache/wal/colors.sh 2>/dev/null

# Strip # from hex colors
C2="${color2:1}"
C3="${color3:1}"
C5="${color5:1}"
C6="${color6:1}"

cat <<EOF > "$config_file"
[general]
framerate = 60
bars = 14

[output]
method = raw
raw_target = /dev/stdout
data_format = ascii
ascii_max_range = 7

[color]
gradient = 1
gradient_count = 4
gradient_color_1 = '${color2:-#A2101F}'
gradient_color_2 = '${color3:-#D51A25}'
gradient_color_3 = '${color6:-#B76A8A}'
gradient_color_4 = '${color5:-#976366}'

[smoothing]
noise_reduction = 60
EOF

killall -9 cava 2>/dev/null

cava -p "$config_file" | sed -u 's/;//g; s/[0-7]/#&/g; s/0/ /g; s/1/▂/g; s/2/▃/g; s/3/▄/g; s/4/▅/g; s/5/▆/g; s/6/▇/g; s/7/█/g; s/#//g'

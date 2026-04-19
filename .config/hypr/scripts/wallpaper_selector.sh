#!/bin/bash

WALLPAPER_DIR="$HOME/Imagens/Wallpapers"

# Check if directory is empty
if [ -z "$(ls -A $WALLPAPER_DIR)" ]; then
    rofi -e "Nenhum wallpaper encontrado em $WALLPAPER_DIR"
    exit 1
fi

# List images in Rofi
SELECTED_WALLPAPER=$(ls -1 "$WALLPAPER_DIR" | grep -iE '\.(png|jpg|jpeg|webp)$' | rofi -dmenu -i -p "󰸉 Wallpaper" -theme-str 'window {width: 600px;}')

if [ -z "$SELECTED_WALLPAPER" ]; then
    exit 0
fi

WALLPAPER_PATH="$WALLPAPER_DIR/$SELECTED_WALLPAPER"

# Set wallpaper
awww img "$WALLPAPER_PATH" --transition-type none

# 1. Force Pywal to generate everything and APPLY to terminals
# Removendo o -n para ele forçar a aplicação das sequências
wal -i "$WALLPAPER_PATH" --saturate 0.8

# 2. Update all configs
source ~/.cache/wal/colors.sh

cat > ~/.cache/wal/colors-hyprland.conf << EOF
\$foreground = rgb(${foreground:1})
\$backgroundCol = rgb(${background:1})
\$color0 = rgb(${color0:1})
\$color1 = rgb(${color1:1})
\$color2 = rgb(${color2:1})
\$color3 = rgb(${color3:1})
\$color4 = rgb(${color4:1})
\$color5 = rgb(${color5:1})
\$color6 = rgb(${color6:1})
\$color7 = rgb(${color7:1})
\$color8 = rgb(${color8:1})
\$color9 = rgb(${color9:1})
\$color10 = rgb(${color10:1})
\$color11 = rgb(${color11:1})
\$color12 = rgb(${color12:1})
\$color13 = rgb(${color13:1})
\$color14 = rgb(${color14:1})
\$color15 = rgb(${color15:1})
EOF

# ---- Reload ----
hyprctl reload
bash ~/.config/hypr/scripts/update_cava_colors.sh

killall -9 waybar 2>/dev/null
sleep 0.2
nohup waybar >/dev/null 2>&1 &

# Garante que as cores novas fiquem salvas no Kitty
for socket in /tmp/kitty*; do
    kitty @ --to "$socket" set-colors -a -c ~/.cache/wal/colors-kitty.conf 2>/dev/null
done

notify-send -i "$WALLPAPER_PATH" "🎨 Tema Atualizado" "Cores aplicadas!" -t 2000 -r 8888

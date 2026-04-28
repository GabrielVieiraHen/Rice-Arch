#!/usr/bin/env bash

WALLPAPERS_DIR="$HOME/.wallpapers/images"
# Fallback se a pasta não existir
if [ ! -d "$WALLPAPERS_DIR" ]; then
    WALLPAPERS_DIR="$HOME/.wallpapers"
fi

# Gera a lista para o rofi e guarda a seleção
SELECTED=$( (
cd "$WALLPAPERS_DIR" || exit 1
for img in *.{jpg,jpeg,png,gif}; do
    if [ -f "$img" ]; then
        # O formato \0icon\x1f... diz ao rofi para mostrar a miniatura da imagem
        echo -en "$img\0icon\x1f$WALLPAPERS_DIR/$img\n"
    fi
done
) | rofi -dmenu -p "Wallpaper" -show-icons -theme-str '
configuration { show-icons: true; }
window { width: 60%; height: 60%; border-radius: 15px; padding: 20px; }
listview { columns: 4; lines: 3; spacing: 20px; layout: vertical; }
element { orientation: vertical; padding: 10px; border-radius: 10px; }
element-icon { size: 10em; horizontal-align: 0.5; }
element-text { horizontal-align: 0.5; }
' )

if [ -n "$SELECTED" ]; then
    IMG="$WALLPAPERS_DIR/$SELECTED"
    # 1. Definir o wallpaper com awww instantaneamente
    awww img "$IMG" --transition-type none --transition-duration 0
    
    # 2. Gerar cores dinâmicas com matugen (Modo Vibrante)
    matugen image "$IMG" -m dark -t scheme-vibrant --source-color-index 0
fi

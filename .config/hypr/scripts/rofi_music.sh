#!/bin/bash

THEME="$HOME/.config/rofi/music.rasi"
TMP_DIR="/tmp/rofi_music"
COVER="$TMP_DIR/cover.png"
RAW_COVER="$TMP_DIR/raw_cover"
TITLE="Sem música tocando"
ARTIST="Desconhecido"
STATUS="Stopped"

mkdir -p "$TMP_DIR"
rm -f "$COVER" "$RAW_COVER"

if playerctl status >/dev/null 2>&1; then
    STATUS=$(playerctl status)
    TITLE=$(playerctl metadata --format "{{ title }}")
    ARTIST=$(playerctl metadata --format "{{ artist }}")
    ALBUM_ART=$(playerctl metadata mpris:artUrl)

    if [ ${#TITLE} -gt 35 ]; then
        TITLE="${TITLE:0:32}..."
    fi
    if [ ${#ARTIST} -gt 30 ]; then
        ARTIST="${ARTIST:0:27}..."
    fi

    if [[ "$ALBUM_ART" == file://* ]]; then
        cp "${ALBUM_ART#file://}" "$RAW_COVER" 2>/dev/null
        convert "$RAW_COVER" -resize 400x400^ -gravity center -extent 400x400 "$COVER" 2>/dev/null || cp "/home/gabriel/Imagens/logos/logo.png" "$COVER"
    elif [[ "$ALBUM_ART" == http* ]]; then
        wget -qO "$RAW_COVER" "$ALBUM_ART"
        convert "$RAW_COVER" -resize 400x400^ -gravity center -extent 400x400 "$COVER" 2>/dev/null || cp "/home/gabriel/Imagens/logos/logo.png" "$COVER"
    else
        cp "/home/gabriel/Imagens/logos/logo.png" "$COVER"
    fi
fi

if [ ! -f "$COVER" ]; then
    cp "/home/gabriel/Imagens/logos/logo.png" "$COVER"
fi

if [ "$STATUS" = "Playing" ]; then
    PLAY_ICON="󰏤"
else
    PLAY_ICON="󰐊"
fi

OPTIONS="󰒮\n$PLAY_ICON\n󰒭"
MSG="<span size='large' weight='bold'>$TITLE</span>
<span size='small'>$ARTIST</span>"

CHOICE=$(echo -e "$OPTIONS" | rofi -dmenu \
    -theme "$THEME" \
    -mesg "$MSG" \
    -a 1 \
    -selected-row 1)

case "$CHOICE" in
    "󰒮") playerctl previous ;;
    "󰏤"|"󰐊") playerctl play-pause ;;
    "󰒭") playerctl next ;;
esac

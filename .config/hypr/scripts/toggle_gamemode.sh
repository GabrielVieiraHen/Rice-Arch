#!/bin/bash

BASENAME="$1"
SYS_PATH="$2"
ACTION="$3" # "on" ou "off"
APP_NAME="$4"

LOCAL_DESKTOP="$HOME/.local/share/applications/${BASENAME}"

# 1. Se não existe na pasta local, copia do sistema
if [ ! -f "$LOCAL_DESKTOP" ]; then
    if [ -f "$SYS_PATH" ]; then
        cp "$SYS_PATH" "$LOCAL_DESKTOP"
    else
        echo "Erro: Atalho $SYS_PATH não encontrado."
        exit 1
    fi
fi

# 2. Limpa o gamemoderun (para evitar duplicatas)
sed -i 's/^Exec=gamemoderun /Exec=/g' "$LOCAL_DESKTOP"

# 3. Injeta o gamemoderun se a ação for "on"
if [ "$ACTION" == "on" ]; then
    sed -i 's/^Exec=/Exec=gamemoderun /g' "$LOCAL_DESKTOP"
    notify-send "GameMode" "$APP_NAME agora abrirá com Alta Performance!" -u normal
else
    notify-send "GameMode" "$APP_NAME voltou ao modo normal." -u normal
fi

# Atualiza o banco de dados de atalhos do sistema (pro Rofi enxergar na hora)
update-desktop-database ~/.local/share/applications

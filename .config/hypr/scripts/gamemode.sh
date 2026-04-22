#!/bin/bash

# Função para recarregar as cores nos terminais (SEM TOCAR NO HYPRLAND.CONF)
reload_colors_terminals() {
    # Update Cava
    bash ~/.config/hypr/scripts/update_cava_colors.sh

    # Send colors to all open terminals
    for pts in /dev/pts/[0-9]*; do
        cat ~/.cache/wal/sequences > "$pts" 2>/dev/null
    done
    for socket in /tmp/kitty*; do
        kitty @ --to "$socket" set-colors -a -c ~/.cache/wal/colors-kitty.conf 2>/dev/null
    done
}

HYPRGAMEMODE=$(hyprctl getoption animations:enabled | awk 'NR==1{print $2}')
if [ "$HYPRGAMEMODE" = 1 ] ; then
    # ---- ATIVAR MODO GAMER EXTREMO ----
    
    # 1. Cores: Aplicar tema Verde/Preto no Pywal (gera colors.sh e sequences, mas não colors-hyprland.conf)
    wal --theme gaming
    reload_colors_terminals

    # 2. Hyprland: Cortar todos os efeitos visuais, gaps e TRANSPARÊNCIA
    # Usamos o hyprctl para forçar a cor da borda verde TAMBÉM, sem escrever em arquivo para evitar bug de auto-reload.
    hyprctl --batch "\
        keyword animations:enabled 0;\
        keyword decoration:shadow:enabled 0;\
        keyword decoration:blur:enabled 0;\
        keyword general:gaps_in 0;\
        keyword general:gaps_out 0;\
        keyword general:border_size 1;\
        keyword decoration:rounding 0;\
        keyword decoration:active_opacity 1.0;\
        keyword decoration:inactive_opacity 1.0;\
        keyword general:col.active_border rgb(00ff00) rgb(00ff00) 45deg"
        
    # 3. Daemon de Sistema: Ativar Feral GameMode e salvar PID
    if command -v gamemoded >/dev/null; then
        nohup gamemoded -r >/dev/null 2>&1 &
        echo $! > /tmp/gamemode_pid
    fi

    notify-send "Game Mode" "Ativado: Sistema de alta performance (Sem Transparência e Gaps)" -u critical
else
    # ---- DESATIVAR MODO GAMER ----
    
    # 1. Cores: Restaurar tema anterior do Wallpaper
    wal -R
    
    # 2. Recriar arquivo de cores do Hyprland com as cores do Wallpaper
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

    reload_colors_terminals

    # 3. Hyprland: Restaurar config original (que tem as animações, gaps e transparência)
    hyprctl reload
    
    # 4. Daemon de Sistema: Desligar Feral GameMode
    if [ -f /tmp/gamemode_pid ]; then
        kill $(cat /tmp/gamemode_pid) 2>/dev/null
        rm /tmp/gamemode_pid
    fi

    notify-send "Game Mode" "Desativado: Efeitos Visuais e Transparência Restaurados"
fi

# Avisar a Waybar para mudar o ícone
pkill -RTMIN+8 waybar

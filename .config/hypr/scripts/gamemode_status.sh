#!/bin/bash
HYPRGAMEMODE=$(hyprctl getoption animations:enabled | awk 'NR==1{print $2}')
if [ "$HYPRGAMEMODE" = 1 ] ; then
    echo '{"text": "", "class": "normal", "tooltip": "Modo Normal (Clique para ativar Modo Gaming)"}'
else
    echo '{"text": "", "class": "gaming", "tooltip": "Game Mode Ativo (Clique para desativar)"}'
fi

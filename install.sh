#!/usr/bin/env bash

# Arch Linux Rice Installer - GabrielVieiraHen

# Cores
GREEN='\033[1;32m'
BLUE='\033[1;34m'
RED='\033[1;31m'
NC='\033[0m'

echo -e "${BLUE}Bem-vindo ao instalador do Rice-Arch!${NC}"
echo -e "${GREEN}Este script vai instalar todas as dependências e aplicar as configurações.${NC}"
sleep 2

# Verificar se yay está instalado
if ! command -v yay &> /dev/null; then
    echo -e "${RED}yay não encontrado. A instalar yay...${NC}"
    sudo pacman -S --needed git base-devel
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay && makepkg -si --noconfirm
    rm -rf /tmp/yay
fi

# Instalar pacotes base e dependências do AUR
echo -e "${BLUE}A instalar dependências...${NC}"
yay -S --needed \
    hyprland waybar rofi-wayland kitty \
    matugen-bin quickshell-git swww cava \
    lavat fastfetch mpv ffmpeg gamemoded \
    power-profiles-daemon pipewire pipewire-pulse \
    ttf-jetbrains-mono-nerd

# Criar backup
echo -e "${BLUE}A criar backup das tuas configurações atuais em ~/.config-backup...${NC}"
mkdir -p ~/.config-backup
for folder in hypr waybar quickshell rofi matugen kitty cava fastfetch; do
    if [ -d "$HOME/.config/$folder" ]; then
        mv "$HOME/.config/$folder" "$HOME/.config-backup/"
    fi
done

# Instalar novos ficheiros
echo -e "${BLUE}A copiar ficheiros de configuração...${NC}"
cp -r .config/* ~/.config/
cp .bashrc ~/

# Garantir permissões de execução
chmod +x ~/.config/rofi/wallpaper.sh
chmod +x ~/.config/hypr/scripts/quickshell/wallpaper/matugen_reload.sh

echo -e "${GREEN}Instalação Concluída! Reinicia a tua sessão ou computador para aplicar as alterações.${NC}"

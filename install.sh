#!/usr/bin/env bash
# ╔══════════════════════════════════════════════════════════════════╗
# ║          Rice-Arch — Instalador Automático Completo             ║
# ║          by gabesvr | github.com/gabesvr/Rice-Arch              ║
# ╚══════════════════════════════════════════════════════════════════╝

set -euo pipefail

# ── Cores ────────────────────────────────────────────────────────────
GREEN='\033[1;32m'
BLUE='\033[1;34m'
CYAN='\033[1;36m'
YELLOW='\033[1;33m'
RED='\033[1;31m'
BOLD='\033[1m'
NC='\033[0m'

# ── Funções utilitárias ───────────────────────────────────────────────
info()    { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[OK]${NC} $1"; }
warn()    { echo -e "${YELLOW}[AVISO]${NC} $1"; }
error()   { echo -e "${RED}[ERRO]${NC} $1"; exit 1; }
section() { echo -e "\n${BOLD}${CYAN}══════════════════════════════════════${NC}"; echo -e "${BOLD}${CYAN}  $1${NC}"; echo -e "${BOLD}${CYAN}══════════════════════════════════════${NC}"; }

# ── Banner ────────────────────────────────────────────────────────────
clear
echo -e "${CYAN}"
cat << 'EOF'
  ____  _            _             _         _
 |  _ \(_) ___ ___  / \   _ __ __| |__     | |
 | |_) | |/ __/ _ \/  /  | '__/ __|  _ \   | |
 |  _ <| | (_|  __/\  \  | | | (__| | | |  |_|
 |_| \_\_|\___\___| \/  |_|  \___|_| |_|  (_)

           by gabesvr — Hyprland Rice para Arch
EOF
echo -e "${NC}"
echo -e "${BOLD}Este script vai configurar o teu sistema do zero.${NC}"
echo -e "Clonado de: ${CYAN}https://github.com/gabesvr/Rice-Arch${NC}\n"
sleep 2

# ── Verificar Arch Linux ──────────────────────────────────────────────
section "1/9 — Verificando Sistema"
if ! command -v pacman &>/dev/null; then
    error "Este script é apenas para Arch Linux!"
fi
success "Arch Linux detetado."

# ── Instalar yay (AUR helper) ─────────────────────────────────────────
section "2/9 — AUR Helper (yay)"
if ! command -v yay &>/dev/null; then
    info "yay não encontrado. A instalar..."
    sudo pacman -S --needed --noconfirm git base-devel
    git clone https://aur.archlinux.org/yay.git /tmp/yay-install
    cd /tmp/yay-install && makepkg -si --noconfirm
    cd - && rm -rf /tmp/yay-install
    success "yay instalado!"
else
    success "yay já está instalado ($(yay --version | head -1))."
fi

# ── Ativar Multilib (para Steam e libs 32-bit) ────────────────────────
section "3/9 — Ativando Multilib (Steam / Gaming)"
if grep -q "^\[multilib\]" /etc/pacman.conf; then
    success "Multilib já está ativo."
else
    info "Ativando repositório multilib..."
    sudo sed -i '/^#\[multilib\]/{N;s/#\[multilib\]\n#Include/[multilib]\nInclude/}' /etc/pacman.conf
    sudo pacman -Sy --noconfirm
    success "Multilib ativado!"
fi

# ── Instalar todos os pacotes ─────────────────────────────────────────
section "4/9 — Instalando Pacotes"

info "Atualizando sistema..."
sudo pacman -Syu --noconfirm

# ─ Pacotes do repositório oficial ─────────────────────────────
PACMAN_PKGS=(
    # Wayland / Display
    hyprland
    xorg-xwayland
    wayland-protocols
    sddm                           # Display Manager

    # Barra / UI
    waybar

    # Terminal
    kitty

    # Ficheiros
    thunar
    gvfs
    tumbler

    # Rofi launcher
    rofi-wayland

    # Áudio
    pipewire
    pipewire-pulse
    pipewire-alsa
    wireplumber
    pavucontrol
    playerctl
    cava

    # Media
    mpv
    ffmpeg

    # Screenshot / Clipboard
    grim
    slurp
    swappy
    wl-clipboard
    cliphist

    # Utilitários de sistema
    inotify-tools
    brightnessctl
    nwg-look
    nwg-displays
    qt5ct
    qt6ct
    xsettingsd
    gtk-engine-murrine

    # Performance / GameMode
    gamemode
    lib32-gamemode
    power-profiles-daemon

    # Gaming
    steam
    lib32-mesa
    lib32-vulkan-icd-loader

    # Fontes
    ttf-jetbrains-mono-nerd
    ttf-font-awesome
    noto-fonts
    noto-fonts-emoji

    # Temas / Ícones
    arc-gtk-theme
    papirus-icon-theme

    # Notificações
    libnotify
    dunst

    # Hicolor icon fallback
    hicolor-icon-theme

    # Python (para scripts do rice)
    python
    python-gobject

    # Utils
    git
    curl
    wget
    unzip
    jq
)

info "A instalar pacotes do pacman..."
sudo pacman -S --needed --noconfirm "${PACMAN_PKGS[@]}"
success "Pacotes oficiais instalados!"

# ─ Pacotes do AUR ─────────────────────────────────────────────
AUR_PKGS=(
    awww                    # Wallpaper daemon (animações)
    quickshell              # Shell QML (painéis, widgets)
    matugen-bin             # Cores dinâmicas baseadas no wallpaper
    fastfetch               # Sistema info (terminal)
    vesktop-bin             # Discord melhorado (Vencord)
    hyprpicker              # Color picker para Wayland
    swww                    # (backup wallpaper daemon)
    gammastep               # Night mode
)

info "A instalar pacotes do AUR via yay..."
yay -S --needed --noconfirm "${AUR_PKGS[@]}"
success "Pacotes AUR instalados!"

# ─ Pacotes NVIDIA (se tiver GPU NVIDIA) ───────────────────────
section "4b/9 — Drivers NVIDIA"
if lspci | grep -qi nvidia; then
    info "GPU NVIDIA detetada! A instalar libs 32-bit..."
    NVIDIA_PKGS=(
        lib32-nvidia-utils
        lib32-opencl-nvidia
        nvidia-utils
        opencl-nvidia
        libva-nvidia-driver
    )
    sudo pacman -S --needed --noconfirm "${NVIDIA_PKGS[@]}" || warn "Alguns pacotes NVIDIA falharam (normal se usas drivers opensource)"
    success "NVIDIA 32-bit libs instaladas!"
else
    info "Sem GPU NVIDIA detetada. A saltar..."
fi

# ── Backup das configs atuais ─────────────────────────────────────────
section "5/9 — Backup das Configs Atuais"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_DIR="$HOME/.config-backup-$TIMESTAMP"

CONFIGS_TO_BACKUP=(hypr waybar quickshell rofi matugen kitty cava fastfetch mpv gtk-3.0 gtk-4.0 qt5ct nwg-look nwg-displays xsettingsd waypaper vesktop)

mkdir -p "$BACKUP_DIR"
for folder in "${CONFIGS_TO_BACKUP[@]}"; do
    if [ -d "$HOME/.config/$folder" ]; then
        cp -a "$HOME/.config/$folder" "$BACKUP_DIR/"
        info "Backup: ~/.config/$folder → $BACKUP_DIR/"
    fi
done

# Backup do .bashrc
[ -f "$HOME/.bashrc" ] && cp "$HOME/.bashrc" "$BACKUP_DIR/.bashrc"

success "Backup guardado em: $BACKUP_DIR"

# ── Instalar os dotfiles ──────────────────────────────────────────────
section "6/9 — Instalando Dotfiles"

# Copiar todas as configs do repo para ~/.config/
info "A copiar configurações..."
cp -a .config/. "$HOME/.config/"

# Copiar .bashrc
if [ -f ".bashrc" ]; then
    cp .bashrc "$HOME/.bashrc"
    success ".bashrc instalado!"
fi

# ─ Permissões de execução para todos os scripts ────────────────
info "A definir permissões dos scripts..."
find "$HOME/.config/hypr/scripts" -name "*.sh" -exec chmod +x {} \;
find "$HOME/.config/rofi" -name "*.sh" -exec chmod +x {} \;
find "$HOME/.config" -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true
success "Permissões definidas!"

# ── Configurar pasta de Wallpapers ────────────────────────────────────
section "7/9 — Wallpapers"
if [ ! -d "$HOME/.wallpapers/images" ]; then
    mkdir -p "$HOME/.wallpapers/images"
    warn "Pasta ~/.wallpapers/images/ criada!"
    warn "Adiciona os teus wallpapers lá antes de iniciar o Hyprland."
else
    success "Pasta de wallpapers já existe."
fi

# ── Configurar SDDM (Display Manager) ────────────────────────────────
section "8/9 — Display Manager (SDDM)"

# Criar config do SDDM para Wayland/Hyprland
sudo mkdir -p /etc/sddm.conf.d/
sudo tee /etc/sddm.conf.d/hyprland.conf > /dev/null << 'SDDM_CONF'
[General]
DisplayServer=wayland
GreeterEnvironment=QT_WAYLAND_SHELL_INTEGRATION=layer-shell

[Wayland]
CompositorCommand=Hyprland
SDDM_CONF

# Ativar SDDM (desativar outros display managers primeiro)
for DM in gdm lightdm lxdm; do
    if systemctl is-enabled "$DM" &>/dev/null; then
        warn "Desativando $DM..."
        sudo systemctl disable "$DM" 2>/dev/null || true
    fi
done

sudo systemctl enable sddm
success "SDDM configurado e ativado!"

# ── Ativar Serviços Systemd ───────────────────────────────────────────
section "9/9 — Ativando Serviços"

SERVICES=(
    "power-profiles-daemon"
    "gamemode"
)

for svc in "${SERVICES[@]}"; do
    if systemctl list-unit-files | grep -q "^$svc"; then
        sudo systemctl enable --now "$svc" 2>/dev/null || warn "$svc não pôde ser ativado"
        success "$svc ativado!"
    fi
done

# Pipewire (serviço do utilizador)
systemctl --user enable --now pipewire pipewire-pulse wireplumber 2>/dev/null || warn "Pipewire: reinicia a sessão para ativar"
success "Pipewire audio ativado!"

# ── Firefox — Config Wayland ──────────────────────────────────────────
info "Configurando Firefox para Wayland nativo..."
FIREFOX_PROFILE_DIR="$HOME/.mozilla/firefox"
if [ -d "$FIREFOX_PROFILE_DIR" ]; then
    # Aplicar user.js em todos os perfis
    for profile_dir in "$FIREFOX_PROFILE_DIR"/*/; do
        if [[ -f "$profile_dir/prefs.js" ]]; then
            cat > "$profile_dir/user.js" << 'FIREFOX_CONF'
// Firefox — Otimizações Wayland + Performance
user_pref("media.ffmpeg.vaapi.enabled", true);
user_pref("media.hardware-video-decoding.force-enabled", true);
user_pref("gfx.webrender.all", true);
user_pref("gfx.x11-egl.force-enabled", false);
user_pref("widget.use-xdg-desktop-portal.file-picker", 1);
user_pref("widget.use-xdg-desktop-portal.mime-handler", 1);
FIREFOX_CONF
            success "Firefox: user.js aplicado em $profile_dir"
        fi
    done
else
    info "Firefox sem perfil existente — configuração será aplicada na primeira abertura."
fi

# ── Resumo Final ──────────────────────────────────────────────────────
echo ""
echo -e "${BOLD}${GREEN}╔══════════════════════════════════════════════════════╗${NC}"
echo -e "${BOLD}${GREEN}║         🎉 Instalação Completa! 🎉                  ║${NC}"
echo -e "${BOLD}${GREEN}╚══════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${CYAN}Próximos passos:${NC}"
echo ""
echo -e "  ${BOLD}1.${NC} Adiciona wallpapers em ${YELLOW}~/.wallpapers/images/${NC}"
echo -e "  ${BOLD}2.${NC} Reinicia o sistema: ${YELLOW}sudo reboot${NC}"
echo -e "  ${BOLD}3.${NC} O ${BOLD}SDDM${NC} vai abrir → escolhe ${BOLD}Hyprland${NC} na lista de sessões"
echo -e "  ${BOLD}4.${NC} ${BOLD}Steam${NC} já tem multilib ativado — abre e faz login normalmente"
echo -e "  ${BOLD}5.${NC} ${BOLD}Vesktop (Discord)${NC} está instalado — abre com ${YELLOW}vesktop${NC}"
echo ""
echo -e "${YELLOW}Atalhos principais:${NC}"
echo -e "  ${BOLD}Super + T${NC}          → Kitty (terminal)"
echo -e "  ${BOLD}Super + F${NC}          → Firefox"
echo -e "  ${BOLD}Super + E${NC}          → Thunar (ficheiros)"
echo -e "  ${BOLD}Super${NC} (soltar)     → Rofi (launcher de apps)"
echo -e "  ${BOLD}Super + W${NC}          → Seletor de Wallpaper"
echo -e "  ${BOLD}Super + Alt + G${NC}    → Menu GameMode"
echo -e "  ${BOLD}Super + Shift + S${NC}  → Screenshot de região"
echo ""
echo -e "Backup das tuas configs antigas: ${YELLOW}$BACKUP_DIR${NC}"
echo ""

<h1 align="center">Rice-Arch 🍚</h1>

<p align="center">
  <strong>Setup pessoal do Arch Linux — Hyprland + Glassmorphism + Cores dinâmicas</strong><br>
  Clone → instala → reinicia. Fica como estava.
</p>

<p align="center">
  <img src="preview.png" width="90%" alt="Preview do Rice" />
</p>

---

## ✨ Features

| Componente | Ferramenta |
|---|---|
| **Gestor de Janelas** | Hyprland (Wayland, animações fluidas) |
| **Display Manager** | SDDM (com sessão Wayland automática) |
| **Barra** | Waybar (glassmorphism, transparente) |
| **Shell/Widgets** | Quickshell (volume, rede, bateria, wallpaper, gamemode) |
| **Terminal** | Kitty (com som ao abrir + FastFetch automático) |
| **Cores Dinâmicas** | Matugen (cores mudam com o wallpaper — terminal, cava, waybar) |
| **Launcher** | Rofi (grid de ícones, glassmorphism) |
| **Wallpaper** | awww (transições animadas) |
| **Discord** | Vesktop / Vencord (com temas customizados) |
| **Gaming** | GameMode + Steam (multilib ativado automaticamente) |
| **Audio Visual** | CAVA (com shaders e cores do wallpaper) |
| **Browser** | Firefox (Wayland nativo, aceleração hardware) |

---

## 👀 Previews

#### 📡 Painel de Rede Wi-Fi
<p align="center"><img src="screenshots/wifi.png" width="80%" /></p>

#### 🔋 Gestão de Energia e Performance
<p align="center"><img src="screenshots/bateria.png" width="80%" /></p>

#### 🔊 Controlo de Áudio
<p align="center"><img src="screenshots/audio.png" width="80%" /></p>

#### 🎬 Terminal Kitty (com FastFetch + som de abertura)
https://github.com/gabesvr/Rice-Arch/raw/main/screenshots/video.mp4

---

## 🚀 Instalação Rápida

> **Requisito:** Arch Linux com conexão à internet. O script trata de tudo o resto.

```bash
# 1. Clona o repositório
git clone https://github.com/gabesvr/Rice-Arch.git
cd Rice-Arch

# 2. Dá permissão ao instalador
chmod +x install.sh

# 3. Executa
./install.sh
```

O script vai:
- ✅ Instalar o `yay` (AUR helper) se não estiver
- ✅ Ativar o repositório **multilib** (obrigatório para Steam)
- ✅ Instalar **todos os pacotes** (Hyprland, Waybar, Kitty, Steam, Vesktop, etc.)
- ✅ Instalar libs **NVIDIA 32-bit** automaticamente (se detetar GPU NVIDIA)
- ✅ Configurar e ativar o **SDDM** como display manager
- ✅ Fazer **backup** das tuas configs atuais com timestamp
- ✅ Copiar todos os **dotfiles** para `~/.config/`
- ✅ Configurar **Firefox** para Wayland nativo com aceleração de hardware
- ✅ Ativar serviços: `power-profiles-daemon`, `gamemode`, `pipewire`

> ⚠️ Faz backup manual dos teus ficheiros importantes antes de correr!

---

## 📋 Pós-Instalação

Depois do script terminar:

1. **Adiciona wallpapers** em `~/.wallpapers/images/` (qualquer formato — jpg, png, etc.)
2. **Reinicia:** `sudo reboot`
3. No **SDDM**, escolhe **Hyprland** na lista de sessões
4. **Steam** → abre e faz login (multilib já está ativo)
5. **Vesktop** → `vesktop` no terminal para abrir o Discord

---

## ⌨️ Atalhos de Teclado

| Atalho | Ação |
|---|---|
| `Super + T` | Terminal (Kitty) |
| `Super + F` | Browser (Firefox) |
| `Super + E` | Ficheiros (Thunar) |
| `Super` (soltar) | Launcher de Apps (Rofi) |
| `Super + W` | Seletor de Wallpaper |
| `Super + Q` | Fechar janela |
| `Super + V` | Janela flutuante |
| `Super + M` | Ecrã cheio |
| `Super + S` | Workspace especial (scratchpad) |
| `Super + Alt + G` | Menu GameMode |
| `Super + Shift + S` | Screenshot de região (editor) |
| `Print` | Screenshot ecrã inteiro → clipboard |
| `Super + Shift + C` | Color Picker |
| `Super + Shift + V` | Histórico de Clipboard |
| `Super + 1-0` | Ir para workspace # |
| `Super + Shift + 1-0` | Mover janela para workspace # |
| `Super + Shift + L` | Suspender |
| `Ctrl + Super + Espaço` | Play/Pause media |

---

## 📦 Pacotes Instalados

<details>
<summary>Ver lista completa</summary>

**Wayland / Display**
`hyprland` `xorg-xwayland` `sddm` `wayland-protocols`

**Barra / UI**
`waybar` `rofi-wayland` `dunst`

**Terminal**
`kitty` `fastfetch`

**Ficheiros**
`thunar` `gvfs` `tumbler`

**Audio**
`pipewire` `pipewire-pulse` `pipewire-alsa` `wireplumber` `pavucontrol` `playerctl` `cava`

**Media**
`mpv` `ffmpeg`

**Screenshot / Clipboard**
`grim` `slurp` `swappy` `wl-clipboard` `cliphist`

**Gaming**
`steam` `gamemode` `lib32-gamemode` `lib32-mesa`

**NVIDIA (auto-detetado)**
`lib32-nvidia-utils` `lib32-opencl-nvidia` `libva-nvidia-driver`

**Performance**
`power-profiles-daemon` `brightnessctl`

**AUR**
`awww` `quickshell` `matugen-bin` `vesktop-bin` `hyprpicker`

**Fontes**
`ttf-jetbrains-mono-nerd` `ttf-font-awesome` `noto-fonts` `noto-fonts-emoji`

**Temas**
`arc-gtk-theme` `papirus-icon-theme`

**Qt / GTK**
`qt5ct` `qt6ct` `nwg-look` `nwg-displays` `xsettingsd`

</details>

---

## ⚙️ Estrutura do Rice

```
~/.config/
├── hypr/               # Hyprland config + scripts
│   ├── hyprland.conf   # Config principal
│   ├── monitors.conf   # Configuração de monitores
│   └── scripts/
│       ├── quickshell/ # Todos os widgets QML
│       ├── qs_manager.sh
│       └── toggle_gamemode.sh
├── waybar/             # Barra superior
├── kitty/              # Terminal (+ sons + imagens)
├── rofi/               # Launcher de apps
├── matugen/            # Templates de cores dinâmicas
├── cava/               # Visualizador de áudio + shaders
├── quickshell/         # Entry point QML
├── fastfetch/          # Info do sistema
└── vesktop/            # Discord (temas)
~/.bashrc               # Shell config + fastfetch + sons
~/.wallpapers/images/   # Os teus wallpapers (cria tu)
```

---

Feito de madrugada, com amor, para não depender de rices de outros. 🙃

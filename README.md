# Rice-Arch 🍚

Bem-vindo ao meu setup pessoal do Arch Linux. 
Foquei-me num design minimalista, com vidro (glassmorphism), cores que se adaptam automaticamente ao wallpaper e controlos nativos fluidos. Tudo foi pensado para ser rápido, leve e agradável de usar.

### 👀 Previews

Aqui estão os detalhes do ambiente e como cada parte funciona:

#### 📡 Menu de Internet Rápido
Com apenas um clique na Waybar, tens acesso a um painel moderno com efeito de vidro para te ligares ao Wi-Fi em segundos.
<p align="center">
  <img src="screenshots/wifi.png" width="80%" />
</p>

#### 🔋 Gestão de Energia e Performance
Tens o controlo total do PC. Podes gerir o consumo ou ativar a máxima performance com um clique.
<p align="center">
  <img src="screenshots/bateria.png" width="80%" />
</p>

#### 🔊 Controlo de Áudio
Sliders precisos e visuais para alterar o volume ou silenciar o sistema.
<p align="center">
  <img src="screenshots/audio.png" width="80%" />
</p>

#### 🎬 O Terminal Perfeito (Com Som)
Terminal Kitty a puxar as cores precisas do Wallpaper, animações, Fastfetch super leve e um detalhe brutal: sons personalizados a abrir e fechar a janela! (Assiste ao vídeo abaixo com o som ligado)

https://github.com/GabrielVieiraHen/Rice-Arch/raw/main/screenshots/video.mp4

---

### ✨ Features
- **Gestor de Janelas:** Hyprland (rápido e fluido)
- **Barra:** Waybar (transparente e responsiva)
- **Painéis de Controlo:** Quickshell (estilo nativo com sliders de volume, menus de rede e bateria)
- **Cores Dinâmicas:** Matugen (todas as cores do sistema, do terminal ao CAVA, mudam consoante o teu wallpaper automaticamente)
- **Terminal:** Kitty (com Fastfetch minimalista e um som subtil ao abrir/fechar)
- **Visualizador de Áudio:** CAVA e Lavat (com as cores extraídas pela paleta do wallpaper)

---

### 🚀 Instalação Rápida

Se quiseres usar este setup no teu Arch, criei um script que faz quase tudo por ti. Ele instala as dependências necessárias e copia os ficheiros.

1. Abre o teu terminal e clona o repositório:
```bash
git clone https://github.com/GabrielVieiraHen/Rice-Arch.git
cd Rice-Arch
```

2. Executa o instalador mágico:
```bash
chmod +x install.sh
./install.sh
```

> **Aviso:** O script faz backup da tua pasta `~/.config` atual para `~/.config-backup`, mas confirma sempre os teus ficheiros importantes antes de correr!

---

Sente-te à vontade para explorar os dotfiles, modificar ao teu gosto ou usar partes disto no teu próprio setup!

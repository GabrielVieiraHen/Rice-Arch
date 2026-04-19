# 👁️ Gabriel's Cyberpunk Red Rice

Um setup minimalista, ultra-rápido e agressivo para Arch Linux, focado em performance para jogos e estética Dark/Neon.

![Setup Preview](./preview.png)

## 🚀 Destaques
- **Window Manager:** [Hyprland](https://hyprland.org/) (Bordas Neon Animadas)
- **Barra:** [Waybar](https://github.com/Alexays/Waybar) (Design flutuante e minimalista)
- **Terminal:** [Kitty](https://sw.kovidgoyal.net/kitty/) (Configurado para baixa latência em jogos)
- **Cores:** [Pywal](https://github.com/dylanaraps/pywal) (Sincronia total entre wallpaper, janelas e apps)
- **Aesthetic:** `tty-clock` e `lavat` integrados com a paleta dinâmica.

## 🛠️ Comandos Customizados
Adicionados ao meu `.bashrc`:
- `clock`: Relógio grande e centralizado que muda de cor com o wallpaper.
- `lava`: Luminária de lava com efeitos de gravidade e cores dinâmicas.

## 🎨 Design System
O sistema gera automaticamente a paleta de cores baseada no wallpaper atual:
- **Janelas:** Bordas com gradiente neon (Red/Pink).
- **Cava:** Visualizador de áudio com gradiente sincronizado.
- **Waybar:** Totalmente transparente para foco total no wallpaper.

## 📦 Instalação

1. Clone o repositório:
   ```bash
   git clone https://github.com/GabrielVieiraHen/Rice-Arch.git
   ```

2. Aplique as configurações (faça backup das suas antes!):
   ```bash
   cp -r .config/* ~/.config/
   cp .bashrc ~/
   ```

3. Recarregue o sistema:
   ```bash
   hyprctl reload
   ```

---
*Desenvolvido com foco em estética minimalista e performance máxima.*

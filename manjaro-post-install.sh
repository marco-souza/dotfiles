#! /bin/bash

# load other files
source ./scripts/useful-functions.sh

echo "[os] Installing System dependencies"

ensure_installed yay
ensure_installed mise
ensure_installed nvim
ensure_installed stow
ensure_installed tmux
ensure_installed zsh
ensure_installed yt-dlp
ensure_installed fprintd
ensure_installed libfprint
ensure_installed ripgrep
ensure_installed github-cli
ensure_installed inotify-tools
ensure_installed blueman

echo "[os] System dependencies installed - enter to continue"

read continue
clear

echo "[docker] install docker tools"

ensure_installed docker
ensure_installed docker-compose
ensure_installed docker-mcp

sudo usermod -aG docker $USER

sudo systemctl enable docker.service
sudo systemctl start docker.service

echo "[docker] docker tools installed - enter to continue"

read continue
clear

echo "[mcp] Enable MCP servers via docker-mcp"

docker mcp server enable playwright
docker mcp server enable context7
docker mcp server enable obsidian
docker mcp server enable fetch
docker mcp server enable time

echo "[mcp] MCP servers enabled - enter to continue"

read continue
clear

echo "[hypr] install hyprland"

# hyprland
yay -Syu --noconfirm hyprland hyprlauncher playerctl \
  wpctl brightnessctl xdg-desktop-portal-hyprland \
  dunst hypridle hyprlock hyprsunset hyprpolkitagent \
  hyprcursor hypremoji \
  qt5-wayland qt6-wayland pipewire wireplumber \
  sans-serif noto-fonts \
  grim slurp cliphist \
  waybar pavucontrol btop

echo "[stow] apply dotfiles to the system"

stow_config mise
stow_config zsh
stow_config tmux
stow_config ghostty
stow_config amp
stow_config zed
stow_config gemini
stow_config hyprland

echo "[stow] Can I reset stow configs files to avoid local changes? [y/N]"
read reset_stow

if [ "$reset_stow" = "y" ] || [ "$reset_stow" = "Y" ]; then
  echo "[stow] resetting stow configs"

  git reset --hard
fi

clear

echo "[zsh] zsh setup"
setup_zsh

echo "[omz] Oh My Zsh setup"
setup_omz

echo "[mise] Installing dependencies"
mise install

echo "[os] Installing System Applications"

ensure_installed steam
ensure_installed ghostty
ensure_installed zen-twilight
ensure_installed localsend-bin
ensure_installed brave-bin
ensure_installed 1password-beta
ensure_installed 1password-cli

echo "[tui] Installing terminal apps"

ensure_installed k9s
ensure_installed lazygit
ensure_installed lazydocker

# echo "[games] install steam native"
# ensure_installed steam-native "steam-native-runtime vulkan-intel lib32-vulkan-intel"

echo "[games] Installing Lutris"

ensure_installed lutris-git \
  "lutris-git lib32-mesa vulkan-intel lib32-vulkan-intel vulkan-icd-loader lib32-vulkan-icd-loader"

echo "[games] Installed successfully"

read continue
clear

echo "[ai] Installing Agentic IDEs"

ensure_installed zed
ensure_installed antigravity

echo "[games] Agentic IDEs installed successfully"
read continue
clear

if [ ! -f /etc/1password/custom_allowed_browsers ]; then
  echo "[op] configuring 1password to allow zen-twilight as browser"

  sudo mkdir /etc/1password
  sudo touch /etc/1password/custom_allowed_browsers
  echo "zen-twilight" | sudo tee -a /etc/1password/custom_allowed_browsers
fi

echo ""
echo "[op] now open 1password, sign in, and setup ssh integration"
echo ""
echo "     [press any key to continue]"

read next

clear

echo "[op] setup wakatime credentials"

if [ -f $HOME/.wakatime.cfg ]; then
  echo "[op]   Wakatime config file already exists"
  echo ""
  echo "     [press 'r' to reset, any key to continue]"
  read next

  if [ "$next" = "r" ]; then
    echo "[op]   Backing up existing Wakatime config to $HOME/.wakatime.cfg.bkp"
    mv $HOME/.wakatime.cfg $HOME/.wakatime.cfg.bkp

    setup_wakatime_config
  fi
else
  setup_wakatime_config
fi

clear

echo "[op] setup git config"

# check if git config --global was set
git_name_set=$(git config --global user.name || echo "")
git_email_set=$(git config --global user.email || echo "")

if [ -n "$git_name_set" ] && [ -n "$git_email_set" ]; then
  echo "[op]   Git global config already set"
  echo ""
  echo "     Name:  $git_name_set"
  echo "     Email: $git_email_set"
  echo ""
  echo "     [press 'e' to edit, any key to skip]"
  read next
fi

if [ "$next" = "e" ] || [ -z "$git_name_set" ] || [ -z "$git_email_set" ]; then
  echo "[op]   What is your name?"
  read name

  echo "[op]   What is your email?"
  read email

  git config --global user.email $email
  git config --global user.name $name

  git config --global init.defaultBranch main
fi

clear

echo "[nvim] Setting up nvim..."

if [ -d $HOME/.config/nvim/.git/  ]; then
  echo "[nvim]   nvim already configured"
  echo ""
  echo "     [press 'r' to reset, any key to skip]"
  read next

  if [ "$next" = "r" ]; then
    echo "[nvim]   Backing up existing nvim config to $HOME/.config/nvim.bkp"
    mv $HOME/.config/nvim $HOME/.config/nvim.bkp

    setup_nvim
  fi
else
  setup_nvim
fi

clear

echo "[npm] Installing global npm packages"

setup_npm_globals && clear

echo "[evdi] Setup evdi module for displaylink"

setup_evdi && clear

echo "[fingerprint] Setting up fingerprint authentication"

setup_fingerprint && clear

echo ""
echo "[complete] Manjaro post install script finished! 🎉"
echo ""
echo "     It's recommended to restart your computer now."
echo ""

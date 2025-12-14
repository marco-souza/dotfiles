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
ensure_installed fprintd-enroll "fprintd libfprint"
ensure_installed rg ripgrep
ensure_installed gh github-cli
ensure_installed inotifywait inotify-tools

echo "[hypr] install hyprland"

# hyprland
yay -Syu --noconfirm hyprland hyprlauncher playerctl \
  wpctl brightnessctl xdg-desktop-portal-hyprland \
  dunst hypridle hyprlock hyprsunset hyprpolkitagent \
  qt5-wayland qt6-wayland pipewire wireplumber \
  sans-serif noto-fonts \
  grim ensure_installed slurp cliphist \
  waybar

echo "[stow] apply dotfiles to the system"

stow_config mise
stow_config zsh
stow_config tmux
stow_config ghostty
stow_config amp
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
ensure_installed localsend localsend-bin
ensure_installed brave brave-bin
ensure_installed 1password 1password-beta
ensure_installed op 1password-cli
# ensure_installed steam-native "steam-native-runtime vulkan-intel lib32-vulkan-intel"
ensure_installed lutris "lutris-git lib32-mesa vulkan-intel lib32-vulkan-intel vulkan-icd-loader lib32-vulkan-icd-loader"

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

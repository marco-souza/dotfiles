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
ensure_installed rg ripgrep

echo "[stow] apply dotfiles to the system"

stow_config mise
stow_config zsh --adopt
stow_config tmux
stow_config ghostty

git reset --hard

echo "[mise] Installing dependencies"

mise install

echo "[os] Installing System Applications"

ensure_installed ghostty
ensure_installed localsend localsend-bin
ensure_installed brave brave-bin
ensure_installed zen-twilight zen-twilight-bin
ensure_installed 1password 1password-beta
ensure_installed op 1password-cli
ensure_installed steam-native "steam-native-runtime vulkan-intel lib32-vulkan-intel"

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

#!/bin/bash

# load other files
source ./scripts/useful-functions.sh

echo "[os] Installing Homebrew"
if ! command -v brew &> /dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

echo "[os] Installing System dependencies"

ensure_installed mise
ensure_installed nvim
ensure_installed stow
ensure_installed tmux
ensure_installed zsh
ensure_installed ripgrep rg
ensure_installed gh github-cli
ensure_installed fzf fzf
ensure_installed bat bat
ensure_installed eza eza

echo "[stow] apply dotfiles to the system"

stow_config mise
stow_config zsh
stow_config tmux
stow_config ghostty
stow_config amp

echo "[stow] Can I reset stow configs files to avoid local changes? [y/N]"
read reset_stow

if [ "$reset_stow" = "y" ] || [ "$reset_stow" = "Y" ]; then
  echo "[stow] resetting stow configs"
  git reset --hard
fi

clear

echo "[mise] Installing dependencies"
mise install

echo "[os] Installing System Applications"

ensure_cask_installed ghostty ghostty
ensure_cask_installed localsend localsend
ensure_cask_installed brave brave-browser
ensure_cask_installed 1password 1password
ensure_cask_installed obsidian obsidian

clear

echo "[macos] Configuring system defaults [y/N]"
read configure_defaults

if [ "$configure_defaults" = "y" ] || [ "$configure_defaults" = "Y" ]; then
  configure_macos_defaults
fi

clear

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

if [ -d $HOME/.config/nvim/.git/ ]; then
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

echo ""
echo "[complete] macOS post install script finished! 🎉"
echo ""

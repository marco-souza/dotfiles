#! /bin/bash

# load other files
source ./scripts/useful-functions.sh

echo "[os] Installing System dependencies"

ensure_installed yay
ensure_installed mise
ensure_installed nvim
ensure_installed stow
ensure_installed tmux

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


echo ""
echo "[op] Ok, now open 1password, sign in, and setup ssh + git"
echo ""
echo "     [press any key to continue]"

read next


echo "[op] setup Wakatime credentials"

wakatime_api_secret=$(op item get $(op item list | grep wakatime | awk '{ print $1 }') --fields "label=API Secret" --reveal)

if [ -z "$wakatime_api_secret" ]; then
  echo "[op]   Wakatime API Secret not found in 1password. Please create an item in 1password with the label 'Wakatime' and a field 'API Secret' containing your Wakatime API key."
  exit 1
fi

if [ -f $HOME/.wakatime.cfg ]; then
  echo "[op]   Wakatime config file already exists. Backing up to $HOME/.wakatime.cfg.bkp"
  mv $HOME/.wakatime.cfg $HOME/.wakatime.cfg.bkp
fi

echo $wakatime_api_secret > $HOME/.wakatime.cfg

echo "[op] setup git config"

# check if git config --global was set
git_name_set=$(git config --global user.name || echo "")
git_email_set=$(git config --global user.email || echo "")

if [ -n "$git_name_set" ] && [ -n "$git_email_set" ]; then
  echo "[op]   Git global config already set. Skipping..."
  echo ""
  echo "     Name:  $git_name_set"
  echo "     Email: $git_email_set"
  echo ""
  echo "     [press any key to continue]"
  read next
  exit 0
else
  echo "[op]   What is your name?"
  read name

  echo "[op]   What is your email?"
  read email

  git config --global user.email $email
  git config --global user.name $name
fi


echo "[nvim] Setting up nvim..."

mv $HOME/.config/nvim $HOME/.config/nvim.bkp

git clone git@github.com:marco-souza/scratch.nvim.git $HOME/.config/nvim

nvim --headless +"Lazy! sync" +qa

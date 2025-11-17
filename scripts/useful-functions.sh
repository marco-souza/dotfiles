function detect_os() {
  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "linux"
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo "macos"
  else
    echo "unknown"
  fi
}

function ensure_installed() {
  cmd=$1
  install_cmd=${2:-$1}

  # has command? skip
  if [[ -x $(command -v $cmd) ]]; then
    return
  fi

  os=$(detect_os)

  if [[ "$os" == "linux" ]]; then
    if [[ -x $(command -v yay) ]]; then
      yay -Syu $install_cmd --noconfirm
    else
      sudo pamac install $install_cmd --no-confirm
    fi
  elif [[ "$os" == "macos" ]]; then
    brew install $install_cmd
  fi
}

function mise_ensure_installed() {
  cmd=$1
  install_cmd=${2:-$1}

  if [[ ! -x $(command -v $cmd) ]]; then
    mise use -g $install_cmd
  fi
}

function npm_ensure_installed() {
  cmd=$1
  install_cmd=${2:-$1}

  if [[ ! -x $(command -v $cmd) ]]; then
    npm install -g $install_cmd
  fi
}

function stow_config() {
  package=$1
  flags=$2

  cd stow
  stow $flags --target $HOME $package --adopt
  cd ..
}

function setup_wakatime_config() {
  wakatime_api_secret=$(op item get $(op item list | grep wakatime | awk '{ print $1 }') --fields "label=API Secret" --reveal)

  if [ -z "$wakatime_api_secret" ]; then
    echo "[op]   Wakatime API Secret not found in 1password. Please create an item in 1password with the label 'Wakatime' and a field 'API Secret' containing your Wakatime API key."
    exit 1
  fi

echo "
[settings]
debug = false
api_key = $wakatime_api_secret
" > $HOME/.wakatime.cfg
}

function setup_nvim() {
  echo "[nvim]   Cloning scratch.nvim config"
  git clone git@github.com:marco-souza/nvim.git $HOME/.config/nvim

  echo "[nvim]   Installing plugins"
  nvim --headless +"Lazy! sync" +qa
}

function setup_npm_globals() {
  npm_ensure_installed tsc typescript
  npm_ensure_installed eslint eslint
  npm_ensure_installed prettier prettier
  npm_ensure_installed biome @biomejs/biome

  # LSP
  npm_ensure_installed emmet-language-server emmet-language-server
  npm_ensure_installed typescript-language-server typescript-language-server
  npm_ensure_installed tailwindcss-language-server @tailwindcss/language-server

  # AI
  npm_ensure_installed amp @sourcegraph/amp@latest
  npm_ensure_installed gemini @google/gemini-cli
  npm_ensure_installed copilot @github/copilot
}

function ensure_cask_installed() {
  cmd=$1
  install_cmd=${2:-$1}

  if [[ -x $(command -v $cmd) ]]; then
    return
  fi

  brew install --cask $install_cmd
}

function setup_evdi() {
  # installing DisplayLink
  # run uname to discover version
  pamac install displaylink "linux612-headers evdi-dkms displaylink"

  export EVDI_VERSION=${1:-1.14.11}

  # re-build displaylink to support linux 6+
  cd /tmp/
  rm ./evdi -rf

  git clone https://github.com/DisplayLink/evdi /tmp/evdi
  sudo cp -r /tmp/evdi/module/* /usr/src/evdi-$EVDI_VERSION/

  # build and install dkms evdi driver for displaylink (Linux 6+)
  sudo dkms build -m evdi -v $EVDI_VERSION --force
  sudo dkms install -m evdi -v $EVDI_VERSION --force

  sudo systemctl enable displaylink
  sudo systemctl start displaylink

  echo 'All good! Please restart you system to ensure it works fine.'

  cd -
}

function configure_macos_defaults() {
  echo "[macos] Configuring system defaults..."

  # Set hostname (requires interaction)
  # sudo scutil --set ComputerName "Your Mac Name"

  # Show hidden files
  defaults write com.apple.finder AppleShowAllFiles -bool true

  # Show path bar
  defaults write com.apple.finder ShowPathbar -bool true

  # Show status bar
  defaults write com.apple.finder ShowStatusBar -bool true

  # Use list view in Finder
  defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

  # Disable press-and-hold for keys
  defaults write -g ApplePressAndHoldEnabled -bool false

  # Set fast key repeat
  defaults write -g KeyRepeat -int 2
  defaults write -g InitialKeyRepeat -int 15

  # Hide dock automatically
  defaults write com.apple.dock autohide -bool true

  # Dock size
  defaults write com.apple.dock tilesize -int 36

  # Enable full keyboard access (Tab in dialogs)
  defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

  # Set clock format
  defaults write com.apple.menuextra.clock DateFormat -string "HH:mm"

  killall Finder Dock SystemUIServer 2>/dev/null

  echo "[macos] System defaults applied"
}

# update packages

os=$(detect_os)

if [[ "$os" == "linux" ]]; then
  if [[ -x $(command -v yay) ]]; then
    sudo yay -Syu --noconfirm
  else
    sudo pamac update --no-confirm
  fi
elif [[ "$os" == "macos" ]]; then
  brew update
  brew upgrade
fi

function setup_zsh() {
  # Set zsh as default shell
  if [ "$SHELL" != "/bin/zsh" ]; then
    echo "[zsh] Setting zsh as default shell"
    chsh -s /bin/zsh
  fi
}

function setup_omz() {
  omz_install() {
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  }

  OMZ_HOME=$HOME/.oh-my-zsh
  if [ ! -d $OMZ_HOME ]; then
    echo "[omz] Installing Oh My Zsh"
    omz_install
  else
    echo "[omz] Oh My Zsh already installed, wanna reset it? [y/N]"
    read reset_omz

    if [ "$reset_omz" = "y" ] || [ "$reset_omz" = "Y" ]; then
      echo "[omz] resetting Oh My Zsh"
      rm -rf $OMZ_HOME
      omz_install
    fi
  fi
}

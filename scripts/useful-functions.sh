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

  os=$(detect_os)

  if [[ "$os" == "linux" ]]; then
    # has command? skip
    if [ "$(yay -Q | grep -c "$install_cmd")" -gt 0 ]; then
      echo "- $install_cmd already installed"
      return
    fi

    if [[ -x $(command -v yay) ]]; then
      yay -Syu "$install_cmd" --noconfirm
    else
      sudo pamac install "$install_cmd" --no-confirm
    fi

  elif [[ "$os" == "macos" ]]; then
    # has command? skip
    if [ "$(brew list --versions "$install_cmd" | wc -l)" -gt 0 ]; then
      echo "- $install_cmd already installed"
      return
    fi

    brew install "$install_cmd"
  fi
}

function mise_ensure_installed() {
  cmd=$1
  install_cmd=${2:-$1}

  if [[ ! -x "$(command -v "$cmd")" ]]; then
    mise use -g "$install_cmd"
  fi
}

function npm_ensure_installed() {
  cmd=$1
  install_cmd=${2:-$1}

  if [[ ! -x "$(command -v "$cmd")" ]]; then
    npm install -g "$install_cmd"
  fi
}

function stow_config() {
  package=$1
  flags=$2

  echo "  * stowing $package"

  cd stow || return

  stow "$flags" --target "$HOME" "$package" --adopt
  cd ..
}

function setup_wakatime_config() {
  wakatime_api_secret=$(op item get "$(op item list | grep wakatime | awk '{ print $1 }')" --fields "label=API Secret" --reveal)

  if [ -z "$wakatime_api_secret" ]; then
    echo "[op]   Wakatime API Secret not found in 1password. Please create an item in 1password with the label 'Wakatime' and a field 'API Secret' containing your Wakatime API key."
    exit 1
  fi

  echo "
[settings]
debug = false
api_key = $wakatime_api_secret
" >"$HOME/.wakatime.cfg"
}

function setup_nvim() {
  echo "[nvim]   Cloning scratch.nvim config"
  git clone git@github.com:marco-souza/nvim.git "$HOME/.config/nvim"

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

  if [[ -x $(command -v "$cmd") ]]; then
    return
  fi

  brew install --cask "$install_cmd"
}

function setup_evdi() {
  # installing DisplayLink
  # run uname to discover version
  pamac install displaylink "linux612-headers evdi-dkms displaylink"

  export EVDI_VERSION=${1:-1.14.11}

  # re-build displaylink to support linux 6+
  cd /tmp/ || return
  rm -rf ./evdi

  git clone https://github.com/DisplayLink/evdi /tmp/evdi
  sudo cp -r /tmp/evdi/module/* "/usr/src/evdi-$EVDI_VERSION/"

  # build and install dkms evdi driver for displaylink (Linux 6+)
  sudo dkms build -m evdi -v "$EVDI_VERSION" --force
  sudo dkms install -m evdi -v "$EVDI_VERSION" --force

  sudo systemctl enable displaylink
  sudo systemctl start displaylink

  echo 'All good! Please restart you system to ensure it works fine.'

  cd - || return
}

function configure_macos_defaults() {
  echo "[macos] Configuring system defaults..."

  # Set hostname (requires interaction)
  sudo scutil --set ComputerName "m3o.osx"

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
  if [ ! -d "$OMZ_HOME" ]; then
    echo "[omz] Installing Oh My Zsh"
    omz_install
  else
    echo "[omz] Oh My Zsh already installed, wanna reset it? [y/N]"
    read -r reset_omz

    if [ "$reset_omz" = "y" ] || [ "$reset_omz" = "Y" ]; then
      echo "[omz] resetting Oh My Zsh"
      rm -rf "$OMZ_HOME"
      omz_install
    fi
  fi
}

function setup_fingerprint() {
  echo "[fingerprint] Checking for fingerprint reader..."

  # Check if fprintd is installed
  if ! command -v fprintd-list &>/dev/null; then
    echo "[fingerprint] fprintd not installed, skipping setup"
    return
  fi

  echo "[fingerprint] Running fprintd-list to test reader..."
  if ! fprintd-list; then
    echo "[fingerprint] No fingerprint reader detected"
    return
  fi

  echo ""
  echo "[fingerprint] Configuring PAM for fingerprint authentication..."
  echo ""

  # Configure /etc/pam.d/sudo
  echo "[fingerprint] Setting up /etc/pam.d/sudo"
  sudo bash -c 'cat > /etc/pam.d/sudo << EOF
#%PAM-1.0
auth sufficient pam_fprintd.so
auth sufficient pam_unix.so try_first_pass likeauth nullok
auth required pam_deny.so
account         include         system-auth
session         include         system-auth
EOF'

  # Configure /etc/pam.d/system-login for system login
  echo "[fingerprint] Setting up /etc/pam.d/system-login"

  # Backup original file
  if [ ! -f /etc/pam.d/system-login.bkp ]; then
    sudo cp /etc/pam.d/system-login /etc/pam.d/system-login.bkp
    echo "[fingerprint] Backed up original to /etc/pam.d/system-login.bkp"
  fi

  # Check if pam_fprintd.so is already in the file
  if ! sudo grep -q "pam_fprintd.so" /etc/pam.d/system-login; then
    sudo sed -i '1i auth sufficient pam_fprintd.so' /etc/pam.d/system-login
    echo "[fingerprint] Added pam_fprintd.so to /etc/pam.d/system-login"
  else
    echo "[fingerprint] /etc/pam.d/system-login already configured"
  fi

  echo ""
  echo "[fingerprint] Enroll your fingerprint?"
  echo "  Press Enter to enroll, or 'skip' to skip for now"
  read -r enroll_choice

  if [ "$enroll_choice" != "skip" ]; then
    fprintd-enroll
    echo "[fingerprint] Fingerprint enrollment complete!"
  fi

  echo ""
  echo "[fingerprint] Setup complete. Fingerprint will now work for:"
  echo "    - sudo commands"
  echo "    - System login"
  echo ""
  echo "[fingerprint] If you need to recover PAM settings:"
  echo "    - sudo cp /etc/pam.d/system-login.bkp /etc/pam.d/system-login"
  echo ""
}

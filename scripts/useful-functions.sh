function ensure_installed() {
  cmd=$1
  install_cmd=${2:-$1}

  # has command? skip
  if [[ -x $(command -v $cmd) ]]; then
    return
  fi


  if [[ -x $(command -v yay) ]]; then
    yay -Syu $install_cmd --noconfirm
  else
    sudo pamac install $install_cmd --no-confirm
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
  stow $flags --target $HOME $package
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
  git clone git@github.com:marco-souza/scratch.nvim.git $HOME/.config/nvim

  echo "[nvim]   Installing plugins"
  nvim --headless +"Lazy! sync" +qa
}

function setup_npm_globals() {
  npm_ensure_installed tsc typescript
  npm_ensure_installed eslint eslint
  npm_ensure_installed prettier prettier
  npm_ensure_installed biome @biomejs/biome

  # LSP
  npm_ensure_installed typescript-language-server typescript-language-server
  npm_ensure_installed tailwindcss-language-server @tailwindcss/language-server

  # AI
  npm_ensure_installed amp @sourcegraph/amp@latest
  npm_ensure_installed gemini @google/gemini-cli
  npm_ensure_installed copilot @github/copilot
}

# update packages

if [[ -x $(command -v yay) ]]; then
  sudo yay -Syu --noconfirm
else
  sudo pamac update --no-confirm
fi

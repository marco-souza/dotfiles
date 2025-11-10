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

function stow_config() {
  package=$1
  flags=$2

  cd stow
  stow $flags --target $HOME $package
  cd ..
}

# update packages

if [[ -x $(command -v yay) ]]; then
  sudo yay -Syu --noconfirm
else
  sudo pamac update --no-confirm
fi

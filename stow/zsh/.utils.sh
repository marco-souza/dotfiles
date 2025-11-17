#! /usr/bin/env zsh

mcd() { mkdir $1; cd $1; }

# kill
tid() {
    ps -ax | grep -i $1 | grep -v 0:00.00 | awk '{ print $1 }' | uniq
}
ak() { kill -9 $(tid $1) }

# Workon (tmux)
workon() {
  [ ! -d $1 ] && mkdir $1;

  if [ -e $1/.env.sh ]; then
    tmux neww -c $1 "source $1/.env.sh; zsh"
  fi

  tmux neww -c $1
}

# Git
mug() { gl && gco $1 && gl && gco - && gm -Xours $1 }

rug() { gl && gco $1 && gl && gco - && grb $1 }

function source_omz() {
  # Path to your oh-my-zsh installation
  export ZSH="$HOME/.oh-my-zsh"
  if [ ! -e $ZSH ]; then
    git clone https://github.com/ohmyzsh/ohmyzsh.git $ZSH
  fi

  # Theme configuration
  export ZSH_THEME="amuse"
  export ZSH_CUSTOM=$ZSH/custom
  export ZSH_PLUGINS_HOME=$ZSH/custom/plugins

  # Oh-My-Zsh settings
  export UPDATE_ZSH_DAYS=3
  export ENABLE_CORRECTION="true"
  export COMPLETION_WAITING_DOTS="true"
  export HIST_STAMPS="%d.%m.%y %T"

  # Use powerline
  export USE_POWERLINE="true"

  # Has weird character width
  # Example:
  #    is not a diamond
  export HAS_WIDECHARS="false"


  # Plugins setup
  plugins=(
    git
    npm
    mise
    tmux

    zsh-autosuggestions
    zsh-syntax-highlighting
  )

  # download autosuggestions
  ZSH_AUTOSUGGESTIONS=$ZSH_PLUGINS_HOME/zsh-autosuggestions
  if [ ! -e $ZSH_AUTOSUGGESTIONS ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_AUTOSUGGESTIONS
  fi

  ZSH_SYNTAX_HIGHLIGHTING=$ZSH_PLUGINS_HOME/zsh-syntax-highlighting
  if [ ! -e $ZSH_SYNTAX_HIGHLIGHTING ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting $ZSH_SYNTAX_HIGHLIGHTING
  fi

  # Source manjaro-zsh-configuration
  if [[ -e /usr/share/zsh/manjaro-zsh-config ]]; then
    source /usr/share/zsh/manjaro-zsh-config
  fi

  # Use manjaro zsh prompt
  if [[ -e /usr/share/zsh/manjaro-zsh-prompt ]]; then
    source /usr/share/zsh/manjaro-zsh-prompt
  fi

  source $ZSH/oh-my-zsh.sh
}

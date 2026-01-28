#! /bin/bash

# Setup environment variables
export EDITOR="nvim"
export BROWSER="zen-twilight"

# Enchance PATH discovery
path_list=(
    "$HOME/.local/bin"
    "$HOME/.mise/bin"
    "$HOME/.cargo/bin"
    "$HOME/.npm-global/bin"
    "$HOME/.bun/bin"
)
for p in "${path_list[@]}"; do
  if [[ -d "$p" && ":$PATH:" != *":$p:"* ]]; then
    export PATH="$PATH:$p"
  fi
done

eval "$(mise activate)"

source $HOME/.utils.sh

source_omz

source $HOME/.aliases
source $HOME/.completions

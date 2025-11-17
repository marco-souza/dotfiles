#! /bin/bash

# Setup environment variables
export EDITOR="nvim"
export BROWSER="zen-twilight"

eval "$(mise activate)"

source $HOME/.utils.sh

source_omz

source $HOME/.aliases
source $HOME/.completions

#! /bin/bash

# Setup environment variables
export EDITOR="nvim"
export BROWSER="zen-twilight"

# Use powerline
USE_POWERLINE="true"

# Has weird character width
# Example:
#    is not a diamond
HAS_WIDECHARS="false"

source $HOME/.aliases
source $HOME/.completions
source $HOME/.utils.sh

eval "$(mise activate)"

source_omz

if [ -x "$(command -v yay)" ]; then
  source_manjaro
fi

# AGENTS.md - Repository Guide

## Project Overview

Dotfiles and post-installation scripts for Manjaro Linux and macOS. Uses GNU Stow to manage configurations. Automates system setup, dependency installation, and dotfile linking.

## Structure

- **macos-post-install.sh** / **manjaro-post-install.sh**: Main entry scripts for system setup
- **scripts/useful-functions.sh**: Shared functions for package management, configuration, and setup
- **stow/**: Configuration directories via GNU Stow (symlinks to $HOME):
  - **mise/**: Version manager configuration
  - **zsh/**: Shell configuration (.zshrc, plugins)
  - **tmux/**: Terminal multiplexer configuration
  - **ghostty/**: Terminal emulator configuration
  - **amp/**: Amp AI tool configuration (settings.json)
  - **zed/**: Zed editor configuration (settings.json)
  - **hyprland/**: Window manager config (Linux only)

## Key Commands

### Run Installation

```bash
./macos-post-install.sh  # macOS
./manjaro-post-install.sh  # Manjaro Linux
```

### Apply/Update Dotfiles

```bash
source scripts/useful-functions.sh
stow_config <package>  # e.g., stow_config zsh
```

### Check OS Detection

```bash
source scripts/useful-functions.sh
detect_os  # Returns 'linux' or 'macos'
```

## Key Functions

- `ensure_installed <cmd> [install_name]`: Install via yay/pamac (Linux) or brew (macOS)
- `ensure_cask_installed <cmd> [install_name]`: Homebrew Cask (macOS only)
- `stow_config <package>`: Link dotfiles using Stow
- `setup_nvim`, `setup_npm_globals`, `setup_zsh`, `setup_omz`: Framework setup
- `detect_os`: Identify OS

## Code Style

- **Bash**: POSIX-compliant with bash-specific features; use `function` keyword
- **Quoting**: Always quote variables (`"$var"`) to handle spaces
- **Error handling**: Check command existence with `command -v` or `[[ -x ]]`
- **Naming**: Snake_case for functions, UPPERCASE for environment variables
- **Comments**: Use `#` with `[tag]` prefix (e.g., `[os]`, `[stow]`, `[nvim]`)
- **Input**: Use `read` for interactive prompts with descriptive messages

## Important Notes

- All dotfile configs are symlinked to home directory via Stow
- Scripts source `useful-functions.sh` for shared utilities
- 1Password (`op` CLI) integration for credentials (Wakatime, SSH)
- Git configuration is prompted during setup

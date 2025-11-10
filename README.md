# Dotfiles for Manjaro Setup

## Overview

This repository contains a collection of dotfiles and scripts to set up and configure a Manjaro Linux system. It automates the installation of essential packages, applies configurations, and sets up development tools to ensure a smooth post-installation experience.

## Directory Structure

- **`manjaro-post-install.sh`**: Main script to execute the post-installation steps.
- **`scripts/`**: Contains utility scripts.
  - **`useful-functions.sh`**: Defines reusable functions for package management and configuration setup.

## Features

### 1. Post-Install Script

The `manjaro-post-install.sh` automates:
- Installing System Dependencies:
  - Tools like `yay`, `mise`, `nvim`, `stow`, `tmux`, and others.
- Configuration Management:
  - Utilizes GNU Stow to manage and apply dotfiles for `mise`, `zsh`, `tmux`, `ghostty`.
- Application Installations:
  - Installs applications like `ghostty`, `localsend`, `brave`, `1password`, `steam-native`, etc.
- Manual Steps:
  - Guides the user to configure `1password` and set up SSH and Wakatime credentials.
- Neovim Configuration:
  - Sets up `nvim`, including cloning a configuration repository and installing plugins.

### 2. Utility Functions

Defined in `scripts/useful-functions.sh`:
- **`ensure_installed`**:
  - Checks if a command/tool is installed; if not, installs it via `yay` or `pamac`.
- **`mise_ensure_installed`**:
  - Similar function, but uses `mise` for installation.
- **`stow_config`**:
  - Applies dotfiles using GNU Stow, targeting the home directory.

## How to Use

1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/dotfiles.git
   cd dotfiles
   ```

2. Run the post-install script:
   ```bash
   ./manjaro-post-install.sh
   ```

3. Follow the prompts to complete manual steps.

## Customization

- Update `manjaro-post-install.sh` to include additional applications or configurations as needed.
- Add your dotfiles into the respective folders under `stow/` and use `stow_config` to apply them.


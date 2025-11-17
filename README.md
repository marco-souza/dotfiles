# Dotfiles for Linux & macOS Setup

## Overview

This repository contains a collection of dotfiles and scripts to set up and configure both Manjaro Linux and macOS systems. It automates the installation of essential packages, applies configurations, and sets up development tools to ensure a smooth post-installation experience and maintains consistency across both operating systems.

## Directory Structure

- **`manjaro-post-install.sh`**: Main script to execute post-installation steps on Manjaro Linux.
- **`macos-post-install.sh`**: Main script to execute post-installation steps on macOS.
- **`scripts/`**: Contains utility scripts.
  - **`useful-functions.sh`**: Defines reusable functions for package management and configuration setup. Supports both Linux and macOS.

## Features

### 1. Post-Install Scripts

#### Manjaro Linux (`manjaro-post-install.sh`)
Automates:
- Installing System Dependencies via `yay`/`pamac`:
  - Tools like `mise`, `nvim`, `stow`, `tmux`, `zsh`, and others.
- Configuration Management:
  - Utilizes GNU Stow to manage and apply dotfiles for `mise`, `zsh`, `tmux`, `ghostty`.
- Application Installations:
  - Installs applications like `ghostty`, `localsend`, `brave`, `1password`, `steam-native`, etc.
- Manual Steps:
  - Guides the user to configure `1password` and set up SSH and Wakatime credentials.
- Neovim Configuration:
  - Sets up `nvim`, including cloning a configuration repository and installing plugins.

#### macOS (`macos-post-install.sh`)
Automates:
- Homebrew Installation:
  - Installs Homebrew if not present.
- Installing System Dependencies via Homebrew:
  - Tools like `mise`, `nvim`, `stow`, `tmux`, `zsh`, `fzf`, `bat`, `eza`, and others.
- Configuration Management:
  - Utilizes GNU Stow to manage and apply dotfiles for `mise`, `zsh`, `tmux`, `ghostty`, `amp`.
- System Defaults Configuration:
  - Configures Finder, Dock, keyboard repeat, and other macOS system settings.
- Application Installations:
  - Installs applications via Homebrew Cask: `ghostty`, `1password`, `raycast`, `arc`, `warp`, etc.
- Neovim Configuration:
  - Sets up `nvim` with custom configuration repository and plugins.

### 2. Utility Functions

Defined in `scripts/useful-functions.sh`:
- **`detect_os()`**:
  - Detects the operating system (linux or macos).
- **`ensure_installed`**:
  - Checks if a command/tool is installed; if not, installs it via package manager.
  - Uses `yay`/`pamac` on Linux, `brew` on macOS.
- **`ensure_cask_installed`**:
  - Installs GUI applications via Homebrew Cask on macOS.
- **`mise_ensure_installed`**:
  - Similar function, but uses `mise` for installation.
- **`npm_ensure_installed`**:
  - Installs packages via `npm` globally.
- **`stow_config`**:
  - Applies dotfiles using GNU Stow, targeting the home directory.
- **`configure_macos_defaults()`**:
  - Configures macOS system defaults (Finder, Dock, keyboard, etc.).
- **`setup_nvim()`**:
  - Clones and initializes Neovim configuration.
- **`setup_npm_globals()`**:
  - Installs essential npm packages globally (TypeScript, ESLint, Prettier, LSPs, AI tools).
- **`setup_wakatime_config()`**:
  - Sets up Wakatime configuration from 1Password API secret.

## How to Use

1. Clone this repository:
   ```bash
   git clone https://github.com/marco-souza/dotfiles.git
   cd dotfiles
   ```

2. Run the appropriate post-install script for your OS:

   **For Manjaro Linux:**
   ```bash
   ./manjaro-post-install.sh
   ```

   **For macOS:**
   ```bash
   ./macos-post-install.sh
   ```

3. Follow the prompts to complete manual steps (git config, 1Password setup, etc.).

## Customization

- Update `manjaro-post-install.sh` or `macos-post-install.sh` to include additional applications or configurations as needed.
- Add your dotfiles into the respective folders under `stow/` and use `stow_config` to apply them.
- Modify `configure_macos_defaults()` in `scripts/useful-functions.sh` to customize macOS system settings.
- Extend `ensure_installed()` to add support for additional package managers if needed.

## OS-Specific Notes

### macOS
- Homebrew is automatically installed if not present.
- System defaults are applied during setup (Finder, Dock, keyboard settings).
- Additional utilities installed: `fzf`, `bat`, `eza` for enhanced terminal experience.
- Applications installed via Cask: `raycast`, `arc`, `warp`, `obsidian`.

### Manjaro Linux
- Uses `yay` as the default AUR helper (falls back to `pamac` if unavailable).
- Includes support for gaming tools (`lutris`, `steam-native`).
- Configures DisplayLink support via `evdi` module for multi-display setups.


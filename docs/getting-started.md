# Getting Started

This guide walks you through setting up your system using the dotfiles repository. It covers prerequisites, installation steps for both macOS and Manjaro Linux, and basic usage of the configuration management system.

## Prerequisites

### Common Requirements

- **Git** -- required to clone the repository.
- **Bash** -- all scripts are written in Bash and assume a Bash-compatible shell.
- **Internet connection** -- required for downloading packages and cloning remote repositories.

### macOS

- **macOS 12 (Monterey) or later** is recommended.
- **Xcode Command Line Tools** -- install with `xcode-select --install` if not already present.
- **Homebrew** -- the macOS post-install script will install it automatically if missing, but you can install it manually from [brew.sh](https://brew.sh) beforehand.

### Manjaro Linux

- **Manjaro Linux** with an up-to-date base installation.
- **yay** (AUR helper) -- the primary package manager used by the scripts. If unavailable, the scripts fall back to `pamac`.
- **sudo** access -- many packages require elevated privileges to install.

### Optional (Both Platforms)

- **1Password and 1Password CLI (`op`)** -- used for retrieving Wakatime API keys and SSH credential management. If you do not use 1Password, you can skip or manually handle those steps during installation.
- **An SSH key** -- for cloning the Neovim configuration repository (which uses a `git@github.com:` URL).

## Installation

### Step 1: Clone the Repository

```bash
git clone https://github.com/marco-souza/dotfiles.git
cd dotfiles
```

### Step 2: Run the Post-Install Script

Choose the script that matches your operating system.

#### macOS

```bash
./macos-post-install.sh
```

This script will:

1. Install Homebrew (if not present).
2. Install system dependencies via `brew`: `mise`, `nvim`, `stow`, `tmux`, `zsh`, `gh`, `fzf`, `bat`, `eza`, `ripgrep`, `mole`.
3. Apply dotfile configurations using GNU Stow for: `mise`, `zsh`, `tmux`, `ghostty`, `amp`, `zed`, `gemini`, `opencode`.
4. Set Zsh as the default shell and install Oh My Zsh.
5. Run `mise install` to install language runtimes and developer tools.
6. Install GUI applications via Homebrew Cask: Ghostty, LocalSend, Brave, 1Password, Obsidian.
7. Optionally configure macOS system defaults (Finder, Dock, keyboard settings).
8. Prompt for 1Password sign-in and SSH integration setup.
9. Set up Wakatime credentials (via 1Password CLI).
10. Configure Git global settings (name, email, default branch).
11. Clone and set up the Neovim configuration.
12. Install global npm packages (TypeScript, ESLint, Prettier, language servers, AI tools).

#### Manjaro Linux

```bash
./manjaro-post-install.sh
```

This script will:

1. Update the system via `yay` or `pamac`.
2. Install system dependencies: `yay`, `fakeroot`, `pkg-config`, `mise`, `nvim`, `stow`, `tmux`, `zsh`, `yt-dlp`, `fprintd`, `libfprint`, `ripgrep`, `github-cli`, `inotify-tools`, `blueman`, `flameshot`, `wdisplays`.
3. Install and enable Tailscale VPN.
4. Install and configure Docker and Docker Compose.
5. Enable MCP (Model Context Protocol) servers via `docker-mcp`: Playwright, Context7, Obsidian, Fetch, Time.
6. Install Hyprland and the full Hypr ecosystem (Waybar, HyprLock, HyprIdle, etc.).
7. Apply dotfile configurations using GNU Stow for: `mise`, `zsh`, `tmux`, `ghostty`, `amp`, `zed`, `gemini`, `hyprland`, `grim`, `flameshot`, `opencode`.
8. Set Zsh as the default shell and install Oh My Zsh.
9. Run `mise install` to install language runtimes and developer tools.
10. Install GUI applications: Steam, Ghostty, Zen Twilight browser, LocalSend, Brave, 1Password.
11. Install terminal tools: `k9s`, `lazygit`, `lazydocker`.
12. Install gaming tools: Lutris (with Vulkan support).
13. Install agentic IDEs: Zed, Antigravity.
14. Configure 1Password browser integration for Zen Twilight.
15. Set up Wakatime credentials, Git config, Neovim, and global npm packages.
16. Set up DisplayLink support via the EVDI module (for multi-monitor setups).
17. Configure fingerprint authentication (if a compatible reader is detected).

### Step 3: Follow Interactive Prompts

Both scripts are interactive. You will be prompted to:

- **Reset stow configs** -- optionally run `git reset --hard` to discard local changes to stow-managed files before they are re-linked.
- **Configure 1Password** -- sign in and set up SSH integration.
- **Set up Wakatime** -- credentials are pulled from 1Password. If a config already exists, you can choose to reset it.
- **Configure Git** -- enter your name and email for `git config --global`, or edit existing values.
- **Set up Neovim** -- the script clones a custom Neovim configuration. If one already exists, you can reset it.

### Step 4: Restart (Manjaro Linux)

After the Manjaro post-install script completes, a system restart is recommended to ensure all services (Docker, Tailscale, DisplayLink, fingerprint) are fully active.

## Basic Usage

### Applying a Single Stow Package

You do not need to re-run the entire post-install script to update or apply a single configuration. Source the utility functions and use `stow_config`:

```bash
source scripts/useful-functions.sh
stow_config zsh
```

This creates symlinks from the stow package directory into your home directory. For example, `stow_config zsh` links `stow/zsh/.zshrc` to `~/.zshrc`.

### Installing a Package

Use the cross-platform `ensure_installed` function:

```bash
source scripts/useful-functions.sh
ensure_installed ripgrep
```

This will use `yay`/`pamac` on Linux or `brew` on macOS.

### Checking the Detected OS

```bash
source scripts/useful-functions.sh
detect_os
```

Returns `linux`, `macos`, or `unknown`.

## Troubleshooting

### Stow Conflicts

If `stow_config` reports conflicts, it means a file already exists at the target location and is not a symlink managed by Stow. The scripts use the `--adopt` flag, which moves existing files into the stow package directory and creates the symlink. After adoption, you can optionally run `git reset --hard` to restore the repository's version of the file.

### Missing `yay` on Manjaro

If `yay` is not available, the scripts fall back to `pamac`. However, some AUR packages may not be installable via `pamac`. Install `yay` first:

```bash
sudo pacman -S yay
```

### Homebrew Not Found on macOS

The macOS script installs Homebrew automatically. If it fails, install it manually:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Then re-run the post-install script.

### 1Password CLI Errors

If you do not use 1Password, the Wakatime setup step will fail. You can skip it and manually create `~/.wakatime.cfg`:

```ini
[settings]
debug = false
api_key = YOUR_API_KEY_HERE
```

### Neovim Clone Fails

The Neovim configuration is cloned via SSH (`git@github.com:marco-souza/nvim.git`). Make sure your SSH key is added to your GitHub account and the SSH agent is running.

## Next Steps

- See [Configuration](configuration.md) for details on each stow package and how to customize them.
- See [Functions Reference](functions-reference.md) for documentation of all utility functions.

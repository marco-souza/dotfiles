# Functions Reference

This document provides a complete reference for all functions defined in `scripts/useful-functions.sh`. These functions are used by both post-install scripts and can be sourced directly for manual use.

## Loading the Functions

Before using any function, source the file:

```bash
source scripts/useful-functions.sh
```

Note: sourcing this file also runs a system update. On Linux, it runs `yay -Syu` or `pamac update`. On macOS, it runs `brew update && brew upgrade`.

---

## OS Detection

### `detect_os`

Detects the current operating system.

**Parameters:** None.

**Returns:** Prints one of the following strings to stdout:

- `linux` -- on Linux systems (`$OSTYPE` starts with `linux-gnu`).
- `macos` -- on macOS systems (`$OSTYPE` starts with `darwin`).
- `unknown` -- on all other systems.

**Example:**

```bash
os=$(detect_os)
if [[ "$os" == "linux" ]]; then
    echo "Running on Linux"
fi
```

---

## Package Installation

### `ensure_installed`

Installs a package using the system's package manager if it is not already installed.

**Parameters:**

| Parameter | Required | Description |
|-----------|----------|-------------|
| `cmd` | Yes | The command name to check for (and the default package name) |
| `install_cmd` | No | The package name to install, if different from `cmd` |

**Behavior by OS:**

- **Linux:** Checks if the package is listed in `yay -Q`. If not found, installs via `yay -Syu --noconfirm` or falls back to `sudo pamac install --no-confirm`.
- **macOS:** Checks if the package is listed in `brew list --versions`. If not found, installs via `brew install`.

**Example:**

```bash
# Install ripgrep (command and package name are the same)
ensure_installed ripgrep

# Install when the command name differs from the package name
ensure_installed gh github-cli
```

---

### `ensure_cask_installed`

Installs a macOS GUI application via Homebrew Cask if the command is not already available.

**Parameters:**

| Parameter | Required | Description |
|-----------|----------|-------------|
| `cmd` | Yes | The command name to check for |
| `install_cmd` | No | The Cask formula name, if different from `cmd` |

**Behavior:** Checks if the command exists via `command -v`. If not found, installs via `brew install --cask`.

**Platform:** macOS only. On Linux, this function is not used; GUI applications are installed via `ensure_installed` with AUR packages.

**Example:**

```bash
ensure_cask_installed ghostty ghostty
ensure_cask_installed 1password 1password
ensure_cask_installed op 1password-cli
```

---

### `mise_ensure_installed`

Installs a tool via `mise` (version manager) if the command is not already available.

**Parameters:**

| Parameter | Required | Description |
|-----------|----------|-------------|
| `cmd` | Yes | The command name to check for |
| `install_cmd` | No | The mise tool name, if different from `cmd` |

**Behavior:** Checks if the command exists via `command -v`. If not found, installs globally using `mise use -g`.

**Example:**

```bash
mise_ensure_installed node
mise_ensure_installed watchexec
```

---

### `npm_ensure_installed`

Installs a package globally via npm if the command is not already available.

**Parameters:**

| Parameter | Required | Description |
|-----------|----------|-------------|
| `cmd` | Yes | The command name to check for |
| `install_cmd` | No | The npm package name, if different from `cmd` |

**Behavior:** Checks if the command exists via `command -v`. If not found, installs via `npm install -g`.

**Example:**

```bash
npm_ensure_installed tsc typescript
npm_ensure_installed prettier prettier
npm_ensure_installed biome @biomejs/biome
```

---

## Configuration Management

### `stow_config`

Applies a dotfile package using GNU Stow, creating symlinks from the package directory into the home directory.

**Parameters:**

| Parameter | Required | Description |
|-----------|----------|-------------|
| `package` | Yes | The name of the stow package directory (under `stow/`) |
| `flags` | No | Additional flags to pass to the `stow` command |

**Behavior:**

1. Changes directory to `stow/`.
2. Runs `stow <flags> --target "$HOME" <package> --adopt`.
3. Changes back to the parent directory.

The `--adopt` flag causes Stow to move any existing files at the target location into the stow directory and replace them with symlinks. This means local customizations are preserved in the repository, and you can use `git diff` to review them.

**Example:**

```bash
stow_config zsh
stow_config tmux
stow_config hyprland
```

---

## Setup Functions

### `setup_zsh`

Sets Zsh as the default login shell.

**Parameters:** None.

**Behavior:** Checks if `$SHELL` is `/bin/zsh`. If not, runs `chsh -s /bin/zsh` to change the default shell.

**Example:**

```bash
setup_zsh
```

---

### `setup_omz`

Installs or resets Oh My Zsh.

**Parameters:** None.

**Behavior:**

- If `~/.oh-my-zsh` does not exist, downloads and installs Oh My Zsh from the official repository.
- If it already exists, prompts the user whether to reset it. If confirmed, removes the existing installation and reinstalls.

**Example:**

```bash
setup_omz
```

---

### `setup_nvim`

Clones and initializes the Neovim configuration.

**Parameters:** None.

**Behavior:**

1. Clones the [marco-souza/nvim](https://github.com/marco-souza/nvim) repository to `~/.config/nvim` via SSH.
2. Runs `nvim --headless +"Lazy! sync" +qa` to install all plugins using Lazy.nvim.

**Prerequisites:** An SSH key configured for GitHub access. Neovim must be installed.

**Example:**

```bash
setup_nvim
```

---

### `setup_npm_globals`

Installs essential global npm packages for development.

**Parameters:** None.

**Packages installed:**

| Command                       | Package                        | Category         |
| ----------------------------- | ------------------------------ | ---------------- |
| `tsc`                         | `typescript`                   | Language         |
| `eslint`                      | `eslint`                       | Linter           |
| `prettier`                    | `prettier`                     | Formatter        |
| `biome`                       | `@biomejs/biome`               | Linter/Formatter |
| `emmet-language-server`       | `emmet-language-server`        | LSP              |
| `typescript-language-server`  | `typescript-language-server`   | LSP              |
| `tailwindcss-language-server` | `@tailwindcss/language-server` | LSP              |
| `amp`                         | `@sourcegraph/amp@latest`      | AI               |
| `gemini`                      | `@google/gemini-cli`           | AI               |
| `copilot`                     | `@github/copilot`              | AI               |

**Example:**

```bash
setup_npm_globals
```

---

### `setup_wakatime_config`

Creates a Wakatime configuration file using an API key retrieved from 1Password.

**Parameters:** None.

**Behavior:**

1. Queries 1Password CLI (`op`) for an item containing "wakatime".
2. Extracts the field labeled "API Secret".
3. Writes `~/.wakatime.cfg` with the API key.

**Prerequisites:** 1Password CLI must be installed and authenticated (`op` command available and signed in).

**Output file (`~/.wakatime.cfg`):**

```ini
[settings]
debug = false
api_key = <retrieved_api_secret>
```

**Example:**

```bash
setup_wakatime_config
```

---

### `setup_evdi`

Sets up the EVDI (Extensible Virtual Display Interface) kernel module for DisplayLink multi-monitor support.

**Parameters:**

| Parameter | Required | Description |
|-----------|----------|-------------|
| `$1` | No | EVDI version (defaults to `1.14.11`) |

**Platform:** Linux only.

**Behavior:**

1. Installs `displaylink`, `linux612-headers`, and `evdi-dkms` via `pamac`.
2. Clones the EVDI source from GitHub.
3. Copies the module source to the DKMS source directory.
4. Builds and installs the DKMS module.
5. Enables and starts the `displaylink` systemd service.

**Example:**

```bash
setup_evdi
setup_evdi 1.14.12  # specify a different version
```

---

### `setup_fingerprint`

Configures fingerprint authentication on supported hardware.

**Parameters:** None.

**Platform:** Linux only.

**Behavior:**

1. Checks for a Goodix fingerprint reader via `lsusb` (vendor ID `27c6`).
2. If found, runs `fprintd-list` to test the reader.
3. Prints instructions for enrolling fingerprints via KDE System Settings or the `fprintd-enroll` command.

**Example:**

```bash
setup_fingerprint
```

---

## macOS-Specific Functions

### `configure_macos_defaults`

Applies a set of macOS system preferences using the `defaults` command.

**Parameters:** None.

**Platform:** macOS only.

**Settings applied:**

| Setting                   | Value              | Description                                   |
| ------------------------- | ------------------ | --------------------------------------------- |
| Computer name             | `m3o.osx`          | Sets the system hostname                      |
| Finder: show hidden files | `true`             | Shows dotfiles in Finder                      |
| Finder: show path bar     | `true`             | Displays the path bar in Finder windows       |
| Finder: show status bar   | `true`             | Displays the status bar in Finder windows     |
| Finder: preferred view    | `Nlsv` (list view) | Sets the default Finder view to list          |
| Press-and-hold for keys   | `false`            | Disables the character picker on key hold     |
| Key repeat rate           | `2`                | Fast key repeat speed                         |
| Initial key repeat delay  | `15`               | Short delay before key repeat starts          |
| Dock auto-hide            | `true`             | Automatically hides the Dock                  |
| Dock tile size            | `36`               | Sets the Dock icon size (pixels)              |
| Full keyboard access      | `3` (all controls) | Enables Tab navigation in all dialog controls |
| Clock format              | `HH:mm`            | 24-hour clock in the menu bar                 |

After applying settings, the function restarts Finder, Dock, and SystemUIServer to apply changes immediately.

**Example:**

```bash
configure_macos_defaults
```

---

## Inline System Update

When `scripts/useful-functions.sh` is sourced, it automatically runs a system update at the module level (outside any function):

- **Linux:** `sudo yay -Syu --noconfirm` (or `sudo pamac update --no-confirm` if `yay` is not available).
- **macOS:** `brew update && brew upgrade`.

This ensures the system is up to date before any packages are installed.

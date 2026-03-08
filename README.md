# Dotfiles

Dotfiles and post-installation scripts for Manjaro Linux and macOS. Uses [GNU Stow](https://www.gnu.org/software/stow/) to manage configuration files as symlinks and automates system setup, dependency installation, and dotfile linking.

## Supported Platforms

- **Manjaro Linux** -- with Hyprland window manager, yay/pamac package management, and AUR support.
- **macOS** -- with Homebrew and Homebrew Cask for package and application management.

## Quick Start

```bash
# Clone the repository
git clone https://github.com/marco-souza/dotfiles.git
cd dotfiles

# Run the post-install script for your OS
./macos-post-install.sh       # macOS
./manjaro-post-install.sh     # Manjaro Linux
```

The scripts are interactive and will guide you through each step, including package installation, dotfile linking, shell setup, credential configuration, and Neovim initialization.

To apply a single configuration package without running the full script:

```bash
source scripts/useful-functions.sh
stow_config zsh    # or any other package name
```

## Repository Structure

```
dotfiles/
  macos-post-install.sh          # macOS setup script
  manjaro-post-install.sh        # Manjaro Linux setup script
  scripts/
    useful-functions.sh          # Shared utility functions
  stow/                          # Configuration packages (symlinked to $HOME)
    amp/                         # Amp AI tool settings
    flameshot/                   # Screenshot tool config (Linux)
    gemini/                      # Gemini CLI settings
    ghostty/                     # Ghostty terminal emulator config
    grim/                        # Grim screenshot tool config (Linux)
    hyprland/                    # Hyprland WM, Waybar, HyprLock, etc. (Linux)
    mise/                        # mise version manager config
    nvim/                        # Neovim (placeholder; config cloned separately)
    opencode/                    # OpenCode AI tool config
    tmux/                        # tmux terminal multiplexer config
    waybar/                      # Waybar (placeholder; included in hyprland)
    zed/                         # Zed editor settings
    zsh/                         # Zsh shell config (.zshrc, aliases, utils)
```

## Stow Packages

Each directory under `stow/` is a package that can be applied independently. GNU Stow creates symlinks from the package into your home directory.

| Package     | Platform | Description                                                          |
| ----------- | -------- | -------------------------------------------------------------------- |
| `zsh`       | Both     | Shell configuration: `.zshrc`, aliases, utilities, Oh My Zsh setup   |
| `tmux`      | Both     | Terminal multiplexer: vi mode, window navigation, auto-rename        |
| `ghostty`   | Both     | Terminal emulator: Rose Pine theme, 70% opacity, Zsh integration     |
| `mise`      | Both     | Version manager: Go, Node, Python, Rust, Bun, Deno, Elixir, and more |
| `amp`       | Both     | Sourcegraph Amp AI tool: thinking mode, MCP server integration       |
| `zed`       | Both     | Zed editor: vim mode, Gruvbox theme, agent profiles, MCP tools       |
| `gemini`    | Both     | Google Gemini CLI: vim mode, OAuth auth, session retention           |
| `opencode`  | Both     | OpenCode AI: Claude/Gemini models, Antigravity integration           |
| `hyprland`  | Linux    | Hyprland window manager, Waybar, HyprLock, HyprIdle, bindings        |
| `grim`      | Linux    | Screenshot tool configuration                                        |
| `flameshot` | Linux    | Screenshot tool with Wayland/Grim adapter                            |

## Key Features

- **Cross-platform** -- a single repository with shared utilities that adapt to Linux or macOS.
- **GNU Stow** -- clean symlink management with an `--adopt` workflow for merging existing configs.
- **mise** -- polyglot version management for Go, Node.js, Python, Rust, Bun, Deno, Elixir, Gleam, Zig, and more.
- **Oh My Zsh** -- pre-configured with the "bureau" theme, autosuggestions, and syntax highlighting.
- **AI tooling** -- configurations for Amp, Gemini CLI, OpenCode, and GitHub Copilot.
- **Hyprland desktop** (Linux) -- full tiling WM setup with Waybar, HyprLock, HyprIdle, and media keys.
- **1Password integration** -- SSH key management and Wakatime credential retrieval via the `op` CLI.
- **Docker MCP servers** -- Playwright, Context7, Obsidian, Fetch, and Time servers enabled by default.

## Customization

- **Add aliases** -- edit `stow/zsh/.aliases` and re-run `stow_config zsh`.
- **Add a new stow package** -- create a directory under `stow/` mirroring the home directory structure, then run `stow_config <name>`.
- **Change language runtimes** -- edit `stow/mise/mise.toml` to add, remove, or pin tool versions.
- **Adjust macOS defaults** -- modify the `configure_macos_defaults` function in `scripts/useful-functions.sh`.
- **Change Hyprland bindings** -- edit `stow/hyprland/.config/hypr/bindings.conf`.
- **Add packages to the install scripts** -- add `ensure_installed <package>` or `ensure_cask_installed <cmd> <cask>` calls to the appropriate post-install script.

## Documentation

Detailed documentation is available in the `docs/` directory:

- **[Getting Started](docs/getting-started.md)** -- prerequisites, installation walkthrough, and basic usage.
- **[Configuration](docs/configuration.md)** -- detailed description of each stow package and customization guide.
- **[Functions Reference](docs/functions-reference.md)** -- reference for all utility functions in `scripts/useful-functions.sh`.

## License

This is a personal dotfiles repository. Use and adapt freely.

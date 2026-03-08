# Configuration

This document describes each stow package in the repository, the files it manages, and how to customize them. All configurations are stored under `stow/` and are symlinked into your home directory using GNU Stow.

## How GNU Stow Works in This Project

GNU Stow creates symlinks from package directories into a target directory (in this case, `$HOME`). Each subdirectory under `stow/` represents a package. The directory structure inside each package mirrors the structure relative to your home directory.

For example:

```
stow/zsh/.zshrc        -->  ~/.zshrc
stow/ghostty/.config/ghostty/config  -->  ~/.config/ghostty/config
```

To apply a package:

```bash
source scripts/useful-functions.sh
stow_config <package_name>
```

The `stow_config` function uses the `--adopt` flag, which means if a file already exists at the target, it is moved into the stow directory (adopted) and replaced with a symlink. After adoption, run `git diff` to see if local changes were pulled in, and `git checkout -- stow/<package>/` to restore the repository version if desired.

---

## Stow Packages

### zsh

**Platform:** macOS, Linux

**Files:**

| File | Target | Description |
|------|--------|-------------|
| `.zshrc` | `~/.zshrc` | Main Zsh configuration |
| `.aliases` | `~/.aliases` | Shell aliases |
| `.utils.sh` | `~/.utils.sh` | Utility functions and Oh My Zsh setup |
| `.completions` | `~/.completions` | Shell completions for Docker, mise, fly, and bun |

**Details:**

The `.zshrc` file sets up:

- Environment variables (`EDITOR=nvim`, `BROWSER=zen-twilight`).
- PATH extensions for `~/.local/bin`, `~/.mise/bin`, `~/.cargo/bin`, `~/.npm-global/bin`, `~/.bun/bin`.
- Activation of `mise` as the version manager.
- Sourcing of `.utils.sh`, `.aliases`, and `.completions`.

The `.aliases` file defines shortcuts for:

- Navigation (`..`, `...`, `rmf`).
- Package management (`i`, `s`, `r`, `u` -- adapts to `yay` on Linux or `brew` on macOS).
- Deno (`dn`, `dt`, `dnr`, `dni`, `dnu`).
- Bun (`b`, `bi`, `br`, `brun`, `bu`).
- npm (`ni`, `nr`, `nu`).
- mise (`m`, `mr`, `mi`, `mu`).
- Make (`mk`).
- Docker (`dk`, `dc`, `dm`, `ds`, `dkps`).
- Text editors (`vim`/`ev` for Neovim, `ec` for VS Code Insiders).
- Git (`g`, `ga`, `gb`, `gc`, `gd`, `gl`, `gp`, `gst`, `gco`).
- Tmux (`t`, `tt`, `ta`, `tl`, `tnw`, `tns`).
- Custom shortcuts (`notes`, `dotfiles`, `evim`, `wo`).

The `.utils.sh` file provides:

- `mcd` -- create a directory and cd into it.
- `tid` / `ak` -- find and kill processes by name.
- `workon` -- open a tmux window in a project directory, optionally sourcing `.env.sh`.
- `mug` / `rug` -- Git merge/rebase workflows.
- `source_omz` -- full Oh My Zsh initialization with the "bureau" theme and plugins: git, npm, mise, tmux, zsh-autosuggestions, zsh-syntax-highlighting.

**Customization:**

To add aliases, edit `stow/zsh/.aliases`. To add new PATH entries, edit the `path_list` array in `stow/zsh/.zshrc`. To change the Oh My Zsh theme, edit the `ZSH_THEME` variable in `stow/zsh/.utils.sh`. To add or remove Oh My Zsh plugins, edit the `plugins` array in the same file.

---

### tmux

**Platform:** macOS, Linux

**Files:**

| File | Target | Description |
|------|--------|-------------|
| `.tmux.conf` | `~/.tmux.conf` | Tmux configuration |

**Details:**

The configuration sets:

- No escape time delay (`escape-time 0`).
- Window indexing starting at 1.
- Large scroll-back history (1,000,000 lines).
- Status bar at the bottom.
- Vi mode for copy/paste.
- `Alt+h` / `Alt+l` for switching between previous/next windows.
- Automatic window renaming based on the current directory.

**Customization:**

Edit `stow/tmux/.tmux.conf` to change key bindings, add plugins (a commented-out plugin source line is included), or adjust display settings.

---

### ghostty

**Platform:** macOS, Linux

**Files:**

| File | Target | Description |
|------|--------|-------------|
| `.config/ghostty/config` | `~/.config/ghostty/config` | Ghostty terminal emulator configuration |

**Details:**

- Theme: Rose Pine (dark mode) / Rose Pine Dawn (light mode), switching automatically.
- Shell integration: Zsh.
- Background opacity: 70% with cell-level opacity enabled (for transparency effects).

**Customization:**

Edit `stow/ghostty/.config/ghostty/config` to change themes, opacity, font, or other Ghostty settings. See the [Ghostty documentation](https://ghostty.org/docs) for all available options.

---

### mise

**Platform:** macOS, Linux

**Files:**

| File | Target | Description |
|------|--------|-------------|
| `mise.toml` | `~/mise.toml` | Global mise configuration (tools and tasks) |
| `.config/mise/config.toml` | `~/.config/mise/config.toml` | mise settings and tool aliases |

**Details:**

The `mise.toml` defines:

- Environment: loads `.env` files, sets `WORKSPACE` and `SHELL`.
- Tools installed globally: Go, Bun, Deno, Node.js, Python, Erlang, Elixir, Gleam, Rust, Zig, Fly.io CLI, usage, watchexec, opencode (all set to `latest`).
- A sample task: `hello`.

The `config.toml` provides:

- A subset of tool versions for system-level defaults (Elixir, Erlang, Node LTS, usage, watchexec).
- Tool alias: `m` for `mise`.
- Experimental features enabled.

**Customization:**

Edit `stow/mise/mise.toml` to add or remove language runtimes and developer tools. Adjust versions from `latest` to specific versions for more predictable environments. Add custom tasks in the `[tasks]` section.

---

### amp

**Platform:** macOS, Linux

**Files:**

| File | Target | Description |
|------|--------|-------------|
| `.config/amp/settings.json` | `~/.config/amp/settings.json` | Amp (Sourcegraph) AI tool configuration |

**Details:**

- Anthropic thinking mode enabled.
- Dojo mode disabled.
- MCP server integration via Docker (`docker mcp gateway run`).
- `dangerouslyAllowAll` set to `true` (permits all tool actions without confirmation).

**Customization:**

Edit `stow/amp/.config/amp/settings.json` to change the model, toggle thinking mode, configure MCP servers, or adjust permission settings. See the [Amp documentation](https://ampcode.com/manual#configuration).

---

### zed

**Platform:** macOS, Linux

**Files:**

| File | Target | Description |
|------|--------|-------------|
| `.config/zed/settings.json` | `~/.config/zed/settings.json` | Zed editor configuration |

**Details:**

- Vim mode enabled with VSCode base keymap.
- Theme: Gruvbox (dark/light, follows system preference).
- UI font size: 16, buffer font size: 15.
- Agent configuration with a "full-power" profile using Gemini 3 Pro Preview via GitHub Copilot Chat, with all tools enabled (terminal, diagnostics, file editing, fetching, grep, etc.).
- Docker MCP Toolkit context server with Playwright, Obsidian, and other tool integrations.

**Customization:**

Edit `stow/zed/.config/zed/settings.json` to change the theme, font sizes, default AI model, or agent profile. See the [Zed documentation](https://zed.dev/docs/configuring-zed).

---

### gemini

**Platform:** macOS, Linux

**Files:**

| File | Target | Description |
|------|--------|-------------|
| `.gemini/settings.json` | `~/.gemini/settings.json` | Gemini CLI configuration |

**Details:**

- Authentication: OAuth personal.
- Vim mode enabled.
- Preview features enabled.
- Session retention enabled.
- Prompt completion enabled.

**Customization:**

Edit `stow/gemini/.gemini/settings.json` to change authentication, toggle vim mode, or adjust UI preferences.

---

### opencode

**Platform:** macOS, Linux

**Files:**

| File | Target | Description |
|------|--------|-------------|
| `.config/opencode/opencode.json` | `~/.config/opencode/opencode.json` | OpenCode AI tool configuration |
| `.config/opencode/antigravity-accounts.json` | `~/.config/opencode/antigravity-accounts.json` | Antigravity authentication accounts |
| `.config/opencode/agents/docs-writer.md` | `~/.config/opencode/agents/docs-writer.md` | Custom agent prompt |
| `.config/opencode/package.json` | `~/.config/opencode/package.json` | Node package dependencies |

**Details:**

- Default model: `github-copilot/claude-opus-4.6`.
- Auto-update enabled.
- Plugin: `opencode-antigravity-auth@latest`.
- Extensive provider configuration for Google models (Gemini 2.5/3/3.1 variants) and Anthropic models (Claude Sonnet 4.6, Claude Opus 4.6) via Antigravity and direct access.

**Customization:**

Edit `stow/opencode/.config/opencode/opencode.json` to change the default model, add providers, or configure plugins.

---

### hyprland

**Platform:** Linux only

**Files:**

| File | Target | Description |
|------|--------|-------------|
| `.config/hypr/hyprland.conf` | `~/.config/hypr/hyprland.conf` | Main Hyprland configuration (sources all sub-configs) |
| `.config/hypr/autostart.conf` | `~/.config/hypr/autostart.conf` | Applications started on login |
| `.config/hypr/bindings.conf` | `~/.config/hypr/bindings.conf` | Keyboard and mouse bindings |
| `.config/hypr/input.conf` | `~/.config/hypr/input.conf` | Input device settings |
| `.config/hypr/looks.conf` | `~/.config/hypr/looks.conf` | Visual appearance (gaps, borders, animations, blur) |
| `.config/hypr/monitors.conf` | `~/.config/hypr/monitors.conf` | Monitor layout |
| `.config/hypr/permissions.conf` | `~/.config/hypr/permissions.conf` | Application permissions (screencopy, etc.) |
| `.config/hypr/win-rules.conf` | `~/.config/hypr/win-rules.conf` | Window rules (workspace assignments, floating, PiP) |
| `.config/hypr/hypridle.conf` | `~/.config/hypr/hypridle.conf` | Idle behavior (dim, lock, DPMS off, suspend) |
| `.config/hypr/hyprlock.conf` | `~/.config/hypr/hyprlock.conf` | Lock screen appearance and authentication |
| `.config/hypr/hyprsunset.conf` | `~/.config/hypr/hyprsunset.conf` | Night light / color temperature schedule |
| `.config/hypr/hyprlauncher.conf` | `~/.config/hypr/hyprlauncher.conf` | Application launcher settings |
| `.config/hypr/change_wallpaper.sh` | `~/.config/hypr/change_wallpaper.sh` | Wallpaper rotation script |
| `.config/waybar/config.jsonc` | `~/.config/waybar/config.jsonc` | Waybar status bar configuration |
| `.config/waybar/style.css` | `~/.config/waybar/style.css` | Waybar styling |
| `.config/waybar/media.sh` | `~/.config/waybar/media.sh` | Waybar media module script |
| `.config/waybar/power_menu.xml` | `~/.config/waybar/power_menu.xml` | Waybar power menu definition |
| `.config/hypremoji/hypremoji.conf` | `~/.config/hypremoji/hypremoji.conf` | HyprEmoji configuration |
| `.config/hypremoji/style.css` | `~/.config/hypremoji/style.css` | HyprEmoji styling |

**Details:**

Key bindings (using SUPER as the main modifier):

- `SUPER + Return` -- open Ghostty terminal.
- `SUPER + Space` -- open Ulauncher.
- `SUPER + B` -- open Zen Twilight browser; `SUPER + Shift + B` -- Brave.
- `SUPER + Q` -- close window; `SUPER + F` -- fullscreen; `SUPER + V` -- toggle floating.
- `SUPER + A` -- Antigravity; `SUPER + Z` -- Zed editor.
- `SUPER + T` -- btop; `SUPER + D` -- lazydocker.
- `SUPER + h/j/k/l` -- vim-style focus movement.
- `SUPER + 1-0` -- switch workspaces; `SUPER + Shift + 1-0` -- move window to workspace.
- `SUPER + Shift + L` -- lock screen; `SUPER + Shift + E` -- logout.
- Media keys for volume, brightness, and playback control.

Window rules assign applications to workspaces:

- Workspace 1: Ghostty (terminal).
- Workspace 2: Zen Twilight, Brave (browsers).
- Workspace 3: Steam (games).
- Workspace 4: Zed, Antigravity (code editors).
- Picture-in-Picture windows are floated, pinned, and positioned at 75%/75%.

Idle behavior:

- 2.5 minutes: dim screen and keyboard backlight.
- 5 minutes: lock screen.
- 5.5 minutes: turn off display.
- 30 minutes: suspend.

Night light: color temperature shifts to 5500K at 18:30 and resets to neutral at 7:30.

**Customization:**

Each aspect of the Hyprland configuration is in its own file for easy editing. To change key bindings, edit `bindings.conf`. To adjust monitor layout, edit `monitors.conf`. To change the look and feel, edit `looks.conf`. See the [Hyprland Wiki](https://wiki.hypr.land/Configuring/) for full documentation.

---

### grim

**Platform:** Linux only

**Files:**

| File | Target | Description |
|------|--------|-------------|
| `.config/grim/grim.conf` | `~/.config/grim/grim.conf` | Grim screenshot tool configuration |

**Details:**

- Output format: PNG.
- Quality: 95 (for lossy formats).
- Cursor capture enabled.
- Cursor freeze enabled during selection.

**Customization:**

Edit `stow/grim/.config/grim/grim.conf` to change the output format, quality, or cursor behavior.

---

### flameshot

**Platform:** Linux only

**Files:**

| File | Target | Description |
|------|--------|-------------|
| `.config/flameshot/flameshot.ini` | `~/.config/flameshot/flameshot.ini` | Flameshot screenshot tool configuration |

**Details:**

- Contrast opacity: 188.
- Draw thickness: 6.
- Saves last region.
- Uses Grim adapter (for Wayland compatibility).
- Startup launch disabled (launched by Hyprland autostart instead).

**Customization:**

Edit `stow/flameshot/.config/flameshot/flameshot.ini` or use the Flameshot GUI configuration.

---

### nvim

**Platform:** macOS, Linux

**Files:** This stow package directory exists but is empty. Neovim configuration is not managed via Stow; instead, the `setup_nvim` function clones a separate repository ([marco-souza/nvim](https://github.com/marco-souza/nvim)) into `~/.config/nvim` and installs plugins using Lazy.nvim.

---

### waybar

**Platform:** Linux only

**Files:** This is an empty stow package placeholder. Waybar configuration files are actually included inside the `hyprland` stow package under `.config/waybar/`.

---

## Adding a New Stow Package

1. Create a new directory under `stow/`:

   ```bash
   mkdir -p stow/mypackage
   ```

2. Place your configuration files inside, mirroring the home directory structure:

   ```bash
   mkdir -p stow/mypackage/.config/myapp
   cp ~/.config/myapp/config.toml stow/mypackage/.config/myapp/config.toml
   ```

3. Apply the package:

   ```bash
   source scripts/useful-functions.sh
   stow_config mypackage
   ```

4. Optionally add `stow_config mypackage` to the appropriate post-install script so it is applied during future setups.

## Removing a Stow Package

To unlink a package without deleting the files:

```bash
cd stow
stow -D --target "$HOME" <package_name>
cd ..
```

This removes the symlinks but leaves the files in the stow directory intact.

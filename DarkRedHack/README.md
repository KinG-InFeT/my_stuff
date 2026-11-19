# DarkRedHack

*Versione italiana: [README.it.md](README.it.md)*

A dark, flat, fully squared GNOME theme with red lines and a "hacker" terminal look. The palette comes from [cve.now](https://cve.now).
It covers the whole desktop: the top bar and menus (GNOME Shell), GTK3 apps and GTK4/libadwaita apps.

- **Always dark**: black surfaces (`#0a0a0b`), cool grey lines and text.
- **Flat and square**: no rounded corner anywhere (buttons, menus, switches, radio buttons, avatars and slider knobs included),
  no soft shadows, only crisp 1px lines.
- **Terminal-style windows**: no shadow and a 1px red frame (grey when unfocused), the title drawn as `─┤ title ├─`,
  window buttons drawn as `[_] [□] [×]` (red on hover), outlined text fields and text buttons like `[ Go ]`,
  main and destructive actions as red outlines instead of red fills.
- **Red touches**: a red line under the top bar and under every title bar, red workspace bars, red toggles and switches,
  red markers on selected menu items and sidebar rows, a red text cursor.
- **Chakra Petch** ([Google Fonts](https://fonts.google.com/specimen/Chakra+Petch), OFL): the GNOME interface font (Shell, apps,
  documents, window titles). Terminals use **JetBrains Mono**: they need a monospace font, and Chakra Petch is proportional, so a
  terminal grid spreads its letters far apart. The system monospace font is left as it is, for code editors.
- **Terminals**: a DarkRedHack color profile for GNOME Terminal, Ptyxis, Alacritty and kitty (black background, red cursor and
  selection, an ANSI palette built on the same colors). See [Terminals](#terminals).
- **VS Code**: a DarkRedHack color theme (editor, sidebars, panels, integrated terminal, syntax) and a *DarkRedHack* profile
  that uses it, so your Default profile keeps its own look. See [VS Code](#vs-code).

## Requirements

- Ubuntu 24.04 with GNOME 46 (the theme is built from Ubuntu's Yaru-dark theme). Newer libadwaita versions (1.6+) are handled too,
  see [libadwaita versions](#libadwaita-versions).
- `sudo` rights. With passwordless sudo the install runs without any prompt; otherwise sudo asks for the password once.
- Internet access on the first install, to download the Chakra Petch font from the Google Fonts repository on GitHub.
- An X11 session for a fully automatic activation. On Wayland everything is installed too, but the top bar theme needs a log out and log in.

## Install

```bash
cd DarkRedHack
./install.sh
```

From a zip: `unzip DarkRedHack.zip && cd DarkRedHack && bash install.sh`.

The script is unattended and can be run again at any time: it rebuilds the theme and reloads it. It does the following:

1. **Packages**: installs Yaru, the *User Themes* GNOME Shell extension, the JetBrains Mono font, Pillow (to recolor PNG images),
   `curl`, `zip` (to package the VS Code theme) and `xdotool` (used for the automatic Shell restart).
2. **Font** (first install only): downloads Chakra Petch (regular, medium, semibold, bold and the OFL license) into
   `~/.local/share/fonts/ChakraPetch/`.
3. **Backup** (first install only): saves the current look (GTK theme, color scheme, Shell theme, extension state and any existing
   `~/.config/gtk-3.0/gtk.css` / `~/.config/gtk-4.0/gtk.css`) in `~/.config/darkredhack-theme/`.
4. **Build**: turns Yaru-dark into DarkRedHack with `recolor.py` (CSS, SVG and PNG recolor + square corners) and adds the
   extra stylesheets, with the colors taken from `palette.css`.
5. **Activate**: forces the dark color scheme, keeps `Yaru-dark` as GTK theme, sets Chakra Petch as interface, document and
   window title font, selects DarkRedHack as Shell theme and enables the User Themes extension.
6. **Terminals**: for each terminal found (GNOME Terminal, Ptyxis, Alacritty, kitty) it writes the DarkRedHack colors and makes
   them the default profile. See [Terminals](#terminals).
7. **VS Code** (when installed): installs the DarkRedHack theme and creates the *DarkRedHack* profile. See [VS Code](#vs-code).
8. **Shell restart**: GNOME Shell only sees a newly installed extension or font after a restart. When one was just installed,
   on X11 the script triggers the restart by itself (same as `Alt+F2` → `r`: open windows are kept); on Wayland it asks you to log
   out and back in.

Already open apps pick up the new look when you reopen them.

### Where the files go

| Part | File written |
|---|---|
| GNOME Shell (top bar, menus, quick settings, notifications, overview) | `~/.local/share/themes/DarkRedHack/gnome-shell/` |
| GTK3 apps (e.g. Terminal) | `~/.config/gtk-3.0/gtk.css` + `~/.config/gtk-3.0/darkredhack-assets/` |
| GTK4 / libadwaita apps (Files, Settings, Text Editor, …) | `~/.config/gtk-4.0/gtk.css` |
| Chakra Petch font | `~/.local/share/fonts/ChakraPetch/` |
| GNOME Terminal profile | dconf `/org/gnome/terminal/legacy/profiles:/` (profile *DarkRedHack*) |
| Ptyxis profile and palette | native: dconf `/org/gnome/Ptyxis/` + `~/.local/share/org.gnome.Ptyxis/palettes/DarkRedHack.palette`; Flatpak: the same inside `~/.var/app/app.devsuite.Ptyxis/`, plus its `config/gtk-4.0/gtk.css` |
| Alacritty | `~/.config/alacritty/darkredhack.toml` + one `import` line in `alacritty.toml` |
| kitty | `~/.config/kitty/darkredhack.conf` + one `include darkredhack.conf` line in `kitty.conf` |
| VS Code theme and profile | extension `darkredhack.darkredhack-theme` in `~/.vscode/extensions/`; profile in `~/.config/Code/User/profiles/darkredhack/` and in the profile list of `~/.config/Code/User/globalStorage/storage.json` |
| Backup of the original look | `~/.config/darkredhack-theme/` |

## Why it is always dark

- The Shell and GTK3 stylesheets are built from Yaru-**dark** only, and the GTK4 stylesheet redefines every libadwaita color as dark.
- The install forces the system color scheme to dark (`prefer-dark`).
- The GTK theme name stays `Yaru-dark` on purpose. Snap/Flatpak and Electron apps (Slack, Firefox, Spotify, …) cannot read
  custom themes from your home folder: with a custom GTK theme name they would fall back to the light default theme.
  Keeping `Yaru-dark` means they stay dark, while normal apps get the DarkRedHack look through the user stylesheets.

Do not switch *Settings → Appearance* to *Light*: Ubuntu would change the GTK theme and sandboxed apps would turn light.
If it happens, run `./install.sh` again.

## Terminals

`install.sh` themes every terminal it finds and skips the others: install a terminal later and run `./install.sh` again.
It never changes which terminal app is the default one; inside each terminal it makes DarkRedHack the default profile and
`uninstall.sh` puts the previous default profile back. Every terminal gets the DarkRedHack colors, JetBrains Mono 11 and new windows
of 140 columns × 24 rows; fonts and size are set at the top of `install.sh` (`TERMINAL_FONT_FAMILY`, `TERMINAL_FONT_SIZE`).

| Terminal | What you get |
|---|---|
| GNOME Terminal | A new *DarkRedHack* profile, set as default. Your other profiles are kept. A window opened from an existing terminal keeps that terminal's profile; new windows from the launcher use DarkRedHack. |
| Ptyxis (default terminal from Ubuntu 26.04) | A *DarkRedHack* palette and profile, set as default. Works with the native package (26.04+) and with the Flathub app on 24.04 (`flatpak install flathub app.devsuite.Ptyxis`), which also gets the DarkRedHack window style, since Flatpak apps do not read `~/.config/gtk-4.0/gtk.css`. |
| Alacritty | `darkredhack.toml`, imported from `alacritty.toml` (top-level `import` before 0.14, `[general] import` from 0.14). Colors set in `alacritty.toml` itself win over imported files. If `alacritty.toml` already has an `import` list, the script asks you to add the file to it. |
| kitty | `darkredhack.conf`, included at the end of `kitty.conf`, so it wins over earlier color settings. |
| GNOME Console | Window style and font only. Console has no setting for terminal colors or window size, so its text area keeps its own palette and size. |

Open terminals pick up the new colors in new windows. In Ptyxis the size applies to the windows you open; `ptyxis -x <command>`
in version 50 still opens at 80 × 24.

## VS Code

`install.sh` packages `vscode/` into a local extension and installs it with `code --install-extension`: the *DarkRedHack* theme
covers the window, editor, sidebars, panels, status bar, integrated terminal and syntax colors. It changes only colors: no font,
icons or other settings.

It then creates a *DarkRedHack* profile, so the Default profile keeps its current theme:

- **Settings**: the profile gets its own copy of your Default settings, with `workbench.colorTheme` set to DarkRedHack. From then
  on the two copies are separate: a setting changed in one profile does not reach the other. Running `./install.sh` again keeps the
  profile's settings and only sets the theme again.
- **Shared with Default**: extensions, keybindings, snippets, tasks, MCP servers and prompts. They stay the same in both profiles.
- **Workspaces**: every saved workspace and folder that opened in the Default profile opens in DarkRedHack from now on (workspaces
  tied to another profile of yours keep it), and so do new windows and workspaces opened for the first time
  (`window.newWindowProfile`). Running `./install.sh` again moves back to DarkRedHack any workspace you set to Default.
- **Switch**: from the *Profiles* menu (gear icon → Profiles) or with `code --profile <name>`.

VS Code rewrites its profile list when it closes, so the profile is created only while VS Code is closed: if it is open, the script
installs the theme and asks you to close VS Code and run `./install.sh` again. With Settings Sync on, the profile is synced to your
other computers too; there, without the theme installed, it shows the default theme.

## libadwaita versions

libadwaita 1.5 (Ubuntu 24.04) reads named colors such as `@define-color window_bg_color …`. From 1.6 on it reads CSS variables
such as `:root { --window-bg-color: …; }` instead. `install.sh` checks the installed `libadwaita-1-0` package: on 1.6 or later it
also turns every `@define-color` line of `gtk-4.0.css` into the matching variable (`window_bg_color` → `--window-bg-color`).
After an Ubuntu upgrade, run `./install.sh` again to switch format. The stylesheet written for the Ptyxis Flatpak always uses
variables, because Flathub runtimes ship libadwaita 1.6 or later.

## Uninstall: back to the original theme

```bash
./uninstall.sh
```

It restores exactly what was saved at the first install (GTK theme, color scheme, Shell theme, User Themes extension on/off,
your previous `gtk.css` files, the previous fonts and default terminal profiles) and deletes every DarkRedHack file, the Chakra Petch
font, the terminal profiles and the VS Code theme and profile included (workspaces go back to the Default profile) (VS Code must be closed for the profile; if it is open,
delete *DarkRedHack* from its Profiles menu). No restart is needed: the top bar switches back immediately, apps when you reopen them. The installed packages are kept: they change nothing once the theme is removed.
To remove them too:

```bash
sudo apt remove gnome-shell-extensions fonts-jetbrains-mono xdotool
```

### Manual revert (if the backup folder is gone)

```bash
gsettings set org.gnome.desktop.interface gtk-theme Yaru-dark
gsettings set org.gnome.desktop.interface color-scheme prefer-dark
dconf reset /org/gnome/shell/extensions/user-theme/name
gnome-extensions disable user-theme@gnome-shell-extensions.gcampax.github.com
rm -rf ~/.local/share/themes/DarkRedHack ~/.config/gtk-3.0/darkredhack-assets ~/.config/darkredhack-theme ~/.local/share/fonts/ChakraPetch
rm -f ~/.config/gtk-3.0/gtk.css ~/.config/gtk-4.0/gtk.css
```

Or simply pick another style in *Settings → Appearance* after removing the files above.

## Customize

Edit the files in this folder, then run `./install.sh` again to rebuild and reload.

| File | What it controls |
|---|---|
| `palette.css` | Every theme color, in one place (`@define-color drh_…`), terminal colors included. GTK3 and GTK4 read it directly, `install.sh` pastes the values into the Shell stylesheet and the terminal files, `recolor.py` takes the red, amber and green hues from it. To change the accent, edit `drh_red`, `drh_red_fill` and the three `rgba(…)` red lines. |
| `terminals/` | One template per terminal (`gnome-terminal.dconf`, `ptyxis.palette`, `alacritty.toml`, `kitty.conf`) with `@drh_…` names: which palette color goes in which ANSI slot. |
| `recolor.py` | How Yaru-dark colors are converted (greys, orange → red, yellow → amber, green → teal) and the corner radius. `MAX_RADIUS = 0` squares everything (px, %, SVG `rx`/`ry`); `LIGHTNESS_CURVE` makes surfaces darker or lighter. |
| `shell-extra.css` | Extra GNOME Shell rules: Chakra Petch, top bar line, red bars on menus and notifications, menu highlights, dock corners. Colors are written as `@drh_…` names. |
| `gtk-4.0.css` | GTK4/libadwaita colors (`@define-color …`, from the palette), square corners, red window frame, text fields. |
| `gtk-extra.css` | Rules shared by GTK3 and GTK4: black windows, GTK3 window frame, `─┤ title ├─`, `[×]` window buttons, outlined buttons and text fields, sidebar selection, scrollbars. |
| `vscode/` | The VS Code theme (`darkredhack-color-theme.json`, with `@drh_…` names; `@drh_name/AA` adds a hex alpha), its extension manifest and `profile.py`, which creates and removes the profile. |
| `install.sh` / `uninstall.sh` | Build, activate and remove. |

### Palette (`palette.css`)

| Role | Name | Color |
|---|---|---|
| Background | `drh_bg` | `#0a0a0b` |
| Surface / alternate / raised | `drh_surface` / `drh_surface_alt` / `drh_raised` | `#111113` / `#0e0e10` / `#17171a` |
| Lines (normal / strong) | `drh_line` / `drh_line_strong` | `#222226` / `#2c2c31` |
| Text / muted text | `drh_fg` / `drh_muted` | `#e6e8ec` / `#8a8d96` |
| Red (accent) / red fill | `drh_red` / `drh_red_fill` | `#ff0027` / `#d70022` |
| Red line / tint / strong tint | `drh_red_line` / `drh_red_tint` / `drh_red_tint_strong` | red at 45% / 12% / 22% |
| Amber (warnings) | `drh_amber` | `#ffbb00` |
| Green (success) | `drh_green` | `#0fd29b` |

Terminal ANSI slots (`terminals/`):

| Slot | 0–7 (normal) | 8–15 (bright) |
|---|---|---|
| Black | `drh_raised` `#17171a` | `drh_bright_black` `#5c5f68` |
| Red | `drh_red` `#ff0027` | `drh_bright_red` `#ff4965` |
| Green | `drh_green` `#0fd29b` | `drh_bright_green` `#5af0c2` |
| Yellow | `drh_amber` `#ffbb00` | `drh_bright_yellow` `#ffd24d` |
| Blue | `drh_blue` `#4c8dff` | `drh_bright_blue` `#8ab4ff` |
| Magenta | `drh_magenta` `#e0349e` | `drh_bright_magenta` `#ff79c6` |
| Cyan | `drh_cyan` `#00c2d1` | `drh_bright_cyan` `#5ee7f0` |
| White | `drh_white` `#b4b7bf` | `drh_fg` `#e6e8ec` |

Background `drh_bg`, text `drh_fg`, cursor `drh_red`, selection `drh_red_fill` with white text.

### Notes for editing the stylesheets

GNOME Shell's CSS engine is not a browser. Quirks met while building this theme:

- Borders on a single side need the long form: `border-bottom-width: 1px; border-color: …;` (the `border-bottom: 1px solid …`
  shorthand is ignored).
- In `font-family` only the first name may be quoted: `font-family: Chakra Petch, Ubuntu Sans, sans-serif;`.

In GTK3 the extra rules live in the same file as the whole recolored Yaru stylesheet, so they win only with a selector at least as
specific as Yaru's (e.g. Yaru styles window buttons with `.titlebar button.titlebutton:not(.appmenu).close`). GTK4 loads the user
stylesheet with a higher priority than the theme, so any matching selector wins there.

GTK CSS cannot move the window title: the title bar always centers it, whatever the stylesheet says.

Errors show up in the session log: `journalctl --user -f -o cat | grep -i -E 'theme|parse'`.

## Troubleshooting

- **The top bar did not change**: check `gnome-extensions info user-theme@gnome-shell-extensions.gcampax.github.com` (state must
  be *ACTIVE*). If it is unknown, the Shell has not restarted yet: press `Alt+F2`, type `r`, press Enter (X11) or log out and in (Wayland).
- **The top bar is not in Chakra Petch**: the Shell loads fonts only when it starts. Restart it as above.
- **An app is still light, or still has round buttons**: reopen it. Snap/Flatpak/Electron apps use Yaru-dark, not DarkRedHack:
  they stay dark but without the red touches.
- **After an Ubuntu update the theme looks off**: run `./install.sh` again to rebuild it from the updated Yaru-dark.
- **A terminal is not in the DarkRedHack colors**: open a new window from the launcher, or pick the *DarkRedHack* profile in the
  terminal preferences. Terminals installed after the theme need `./install.sh` again.

## Folder contents

```
DarkRedHack/
├── README.md         this file
├── README.it.md      Italian version of this file
├── install.sh        unattended install + activation
├── uninstall.sh      restore the original look
├── palette.css       all theme colors
├── terminals/        color templates for GNOME Terminal, Ptyxis, Alacritty and kitty
├── vscode/           VS Code color theme, extension manifest and profile script
├── recolor.py        Yaru-dark → DarkRedHack converter (colors + corners, CSS/SVG/PNG)
├── shell-extra.css   GNOME Shell extra rules
├── gtk-4.0.css       GTK4 / libadwaita colors and shapes
└── gtk-extra.css     terminal-style windows for GTK3 and GTK4
```

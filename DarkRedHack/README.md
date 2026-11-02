# DarkRedHack

*Versione italiana: [README.it.md](README.it.md)*

A dark, squared, red-accented GNOME theme with a "hacker" look. The palette comes from [cve.now](https://cve.now).
It covers the whole desktop: the top bar and menus (GNOME Shell), GTK3 apps and GTK4/libadwaita apps.

- **Always dark**: near-black surfaces (`#0a0a0b`), cool grey lines and text.
- **Squared**: every corner capped at 2px, windows with sharp corners, crisp 1px lines instead of soft shadows.
- **Red touches**: a red line under the top bar and under every title bar, red workspace bars, red toggles and switches,
  red markers on selected menu items and sidebar rows, red monospace window titles, a red text cursor.
- **Monospace labels**: JetBrains Mono for the clock, the top bar and window titles.

## Requirements

- Ubuntu 24.04 with GNOME 46 (the theme is built from Ubuntu's Yaru-dark theme).
- `sudo` rights. With passwordless sudo the install runs without any prompt; otherwise sudo asks for the password once.
- An X11 session for a fully automatic activation. On Wayland everything is installed too, but the top bar theme needs a log out and log in.

## Install

```bash
cd DarkRedHack
./install.sh
```

From a zip: `unzip DarkRedHack.zip && cd DarkRedHack && bash install.sh`.

The script is unattended and can be run again at any time: it rebuilds the theme and reloads it. It does the following:

1. **Packages**: installs Yaru, the *User Themes* GNOME Shell extension, the JetBrains Mono font and `xdotool` (used for the automatic Shell restart).
2. **Backup** (first install only): saves the current look (GTK theme, color scheme, Shell theme, extension state and any existing
   `~/.config/gtk-3.0/gtk.css` / `~/.config/gtk-4.0/gtk.css`) in `~/.config/darkredhack-theme/`.
3. **Build**: turns Yaru-dark into DarkRedHack with `recolor.py` (recolor + square corners) and adds the extra stylesheets.
4. **Activate**: forces the dark color scheme, keeps `Yaru-dark` as GTK theme, selects DarkRedHack as Shell theme and enables the
   User Themes extension.
5. **Shell restart**: GNOME Shell only sees a newly installed extension after a restart. On X11 the script triggers it by itself
   (same as `Alt+F2` → `r`: open windows are kept). On Wayland it asks you to log out and back in.

Already open apps pick up the new look when you reopen them.

### Where the files go

| Part | File written |
|---|---|
| GNOME Shell (top bar, menus, quick settings, notifications, overview) | `~/.local/share/themes/DarkRedHack/gnome-shell/` |
| GTK3 apps (e.g. Terminal) | `~/.config/gtk-3.0/gtk.css` + `~/.config/gtk-3.0/darkredhack-assets/` |
| GTK4 / libadwaita apps (Files, Settings, Text Editor, …) | `~/.config/gtk-4.0/gtk.css` |
| Backup of the original look | `~/.config/darkredhack-theme/` |

## Why it is always dark

- The Shell and GTK3 stylesheets are built from Yaru-**dark** only, and the GTK4 stylesheet redefines every libadwaita color as dark.
- The install forces the system color scheme to dark (`prefer-dark`).
- The GTK theme name stays `Yaru-dark` on purpose. Snap/Flatpak and Electron apps (Slack, Firefox, Spotify, …) cannot read
  custom themes from your home folder: with a custom GTK theme name they would fall back to the light default theme.
  Keeping `Yaru-dark` means they stay dark, while normal apps get the DarkRedHack look through the user stylesheets.

Do not switch *Settings → Appearance* to *Light*: Ubuntu would change the GTK theme and sandboxed apps would turn light.
If it happens, run `./install.sh` again.

## Uninstall: back to the original theme

```bash
./uninstall.sh
```

It restores exactly what was saved at the first install (GTK theme, color scheme, Shell theme, User Themes extension on/off,
your previous `gtk.css` files) and deletes every DarkRedHack file. No restart is needed: the top bar switches back immediately,
apps when you reopen them. The installed packages are kept: they change nothing once the theme is removed. To remove them too:

```bash
sudo apt remove gnome-shell-extensions fonts-jetbrains-mono xdotool
```

### Manual revert (if the backup folder is gone)

```bash
gsettings set org.gnome.desktop.interface gtk-theme Yaru-dark
gsettings set org.gnome.desktop.interface color-scheme prefer-dark
dconf reset /org/gnome/shell/extensions/user-theme/name
gnome-extensions disable user-theme@gnome-shell-extensions.gcampax.github.com
rm -rf ~/.local/share/themes/DarkRedHack ~/.config/gtk-3.0/darkredhack-assets ~/.config/darkredhack-theme
rm -f ~/.config/gtk-3.0/gtk.css ~/.config/gtk-4.0/gtk.css
```

Or simply pick another style in *Settings → Appearance* after removing the files above.

## Customize

Edit the files in this folder, then run `./install.sh` again to rebuild and reload.

| File | What it controls |
|---|---|
| `recolor.py` | How Yaru-dark colors are converted (greys, orange → red, yellow → amber, green → teal) and the corner radius. Set `MAX_RADIUS = 0` for perfectly square corners, change `RED_HUE` for another accent hue, tweak `LIGHTNESS_CURVE` for darker or lighter surfaces. |
| `shell-extra.css` | Extra GNOME Shell rules: top bar line and font, red bars on menus and notifications, menu highlights, dock corners. |
| `gtk-4.0.css` | GTK4/libadwaita colors (`@define-color …`), corner radius and lines. |
| `gtk-extra.css` | Red touches shared by GTK3 and GTK4: text cursor, title bar line, window titles, sidebar selection, scrollbars. |
| `install.sh` / `uninstall.sh` | Build, activate and remove. |

### Palette

| Role | Color |
|---|---|
| Background | `#0a0a0b` |
| Surface / surface 2 | `#111113` / `#17171a` |
| Lines (normal / strong) | `#222226` / `#2c2c31` |
| Text / muted text | `#e6e8ec` / `#8a8d96` |
| Red (accent) / red for filled buttons | `#ff0027` / `#d70022` |
| Red line (45% red) | `rgba(255, 0, 39, 0.45)` |
| Amber (warnings) | `#ffbb00` |
| Green (success) | `#0fd29b` |
| Fonts | JetBrains Mono (labels, titles, top bar) |

### Notes for editing the GNOME Shell stylesheet

GNOME Shell's CSS engine is not a browser. Two quirks met while building this theme:

- Borders on a single side need the long form: `border-bottom-width: 1px; border-color: …;` (the `border-bottom: 1px solid …`
  shorthand is ignored).
- In `font-family` only the first name may be quoted: `font-family: JetBrains Mono, Ubuntu Sans Mono, monospace;`.

Errors show up in the session log: `journalctl --user -f -o cat | grep -i -E 'theme|parse'`.

## Troubleshooting

- **The top bar did not change**: check `gnome-extensions info user-theme@gnome-shell-extensions.gcampax.github.com` (state must
  be *ACTIVE*). If it is unknown, the Shell has not restarted yet: press `Alt+F2`, type `r`, press Enter (X11) or log out and in (Wayland).
- **An app is still light**: reopen it. Snap/Flatpak/Electron apps use Yaru-dark, not DarkRedHack: they stay dark but without the red touches.
- **After an Ubuntu update the theme looks off**: run `./install.sh` again to rebuild it from the updated Yaru-dark.
- **Terminal colors**: the terminal text area uses the profile palette (Terminal → Preferences → Profile → Colors), not the theme.

## Folder contents

```
DarkRedHack/
├── README.md         this file
├── README.it.md      Italian version of this file
├── install.sh        unattended install + activation
├── uninstall.sh      restore the original look
├── recolor.py        Yaru-dark → DarkRedHack converter (colors + corners)
├── shell-extra.css   GNOME Shell extra rules
├── gtk-4.0.css       GTK4 / libadwaita colors and shapes
└── gtk-extra.css     red touches for GTK3 and GTK4
```

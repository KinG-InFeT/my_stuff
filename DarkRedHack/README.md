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
- **Chakra Petch** ([Google Fonts](https://fonts.google.com/specimen/Chakra+Petch), OFL): the whole GNOME Shell, window titles and
  big page titles. Normal app text keeps the system font for readability.

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

1. **Packages**: installs Yaru, the *User Themes* GNOME Shell extension, Pillow (to recolor PNG images), `curl` and `xdotool`
   (used for the automatic Shell restart).
2. **Font** (first install only): downloads Chakra Petch (regular, medium, semibold, bold and the OFL license) into
   `~/.local/share/fonts/ChakraPetch/`.
3. **Backup** (first install only): saves the current look (GTK theme, color scheme, Shell theme, extension state and any existing
   `~/.config/gtk-3.0/gtk.css` / `~/.config/gtk-4.0/gtk.css`) in `~/.config/darkredhack-theme/`.
4. **Build**: turns Yaru-dark into DarkRedHack with `recolor.py` (CSS, SVG and PNG recolor + square corners) and adds the
   extra stylesheets, with the colors taken from `palette.css`.
5. **Activate**: forces the dark color scheme, keeps `Yaru-dark` as GTK theme, selects DarkRedHack as Shell theme and enables the
   User Themes extension.
6. **Shell restart**: GNOME Shell only sees a newly installed extension or font after a restart. When one was just installed,
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
| Backup of the original look | `~/.config/darkredhack-theme/` |

## Why it is always dark

- The Shell and GTK3 stylesheets are built from Yaru-**dark** only, and the GTK4 stylesheet redefines every libadwaita color as dark.
- The install forces the system color scheme to dark (`prefer-dark`).
- The GTK theme name stays `Yaru-dark` on purpose. Snap/Flatpak and Electron apps (Slack, Firefox, Spotify, …) cannot read
  custom themes from your home folder: with a custom GTK theme name they would fall back to the light default theme.
  Keeping `Yaru-dark` means they stay dark, while normal apps get the DarkRedHack look through the user stylesheets.

Do not switch *Settings → Appearance* to *Light*: Ubuntu would change the GTK theme and sandboxed apps would turn light.
If it happens, run `./install.sh` again.

## libadwaita versions

libadwaita 1.5 (Ubuntu 24.04) reads named colors such as `@define-color window_bg_color …`. From 1.6 on it reads CSS variables
such as `:root { --window-bg-color: …; }` instead. `install.sh` checks the installed `libadwaita-1-0` package: on 1.6 or later it
also turns every `@define-color` line of `gtk-4.0.css` into the matching variable (`window_bg_color` → `--window-bg-color`).
After an Ubuntu upgrade, run `./install.sh` again to switch format.

## Uninstall: back to the original theme

```bash
./uninstall.sh
```

It restores exactly what was saved at the first install (GTK theme, color scheme, Shell theme, User Themes extension on/off,
your previous `gtk.css` files) and deletes every DarkRedHack file, the Chakra Petch font included. No restart is needed: the top bar
switches back immediately, apps when you reopen them. The installed packages are kept: they change nothing once the theme is removed.
To remove them too:

```bash
sudo apt remove gnome-shell-extensions xdotool
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
| `palette.css` | Every theme color, in one place (`@define-color drh_…`). GTK3 and GTK4 read it directly, `install.sh` pastes the values into the Shell stylesheet, `recolor.py` takes the red, amber and green hues from it. To change the accent, edit `drh_red`, `drh_red_fill` and the three `rgba(…)` red lines. |
| `recolor.py` | How Yaru-dark colors are converted (greys, orange → red, yellow → amber, green → teal) and the corner radius. `MAX_RADIUS = 0` squares everything (px, %, SVG `rx`/`ry`); `LIGHTNESS_CURVE` makes surfaces darker or lighter. |
| `shell-extra.css` | Extra GNOME Shell rules: Chakra Petch, top bar line, red bars on menus and notifications, menu highlights, dock corners. Colors are written as `@drh_…` names. |
| `gtk-4.0.css` | GTK4/libadwaita colors (`@define-color …`, from the palette), square corners, red window frame, text fields. |
| `gtk-extra.css` | Rules shared by GTK3 and GTK4: black windows, GTK3 window frame, `─┤ title ├─`, `[×]` window buttons, outlined buttons and text fields, sidebar selection, scrollbars. |
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
- **Terminal colors**: the terminal text area uses the profile palette (Terminal → Preferences → Profile → Colors), not the theme.

## Folder contents

```
DarkRedHack/
├── README.md         this file
├── README.it.md      Italian version of this file
├── install.sh        unattended install + activation
├── uninstall.sh      restore the original look
├── palette.css       all theme colors
├── recolor.py        Yaru-dark → DarkRedHack converter (colors + corners, CSS/SVG/PNG)
├── shell-extra.css   GNOME Shell extra rules
├── gtk-4.0.css       GTK4 / libadwaita colors and shapes
└── gtk-extra.css     terminal-style windows for GTK3 and GTK4
```

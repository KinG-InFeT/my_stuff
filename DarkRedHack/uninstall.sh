#!/usr/bin/env bash
# Remove the DarkRedHack theme and restore the look saved by install.sh. Unattended, no restart needed.
# Installed packages (User Themes extension, JetBrains Mono, Pillow, curl, zip) are kept: they are harmless.
set -euo pipefail

SRC="$(cd "$(dirname "$0")" && pwd)"
GTK3="$HOME/.config/gtk-3.0"
GTK4="$HOME/.config/gtk-4.0"
STATE="$HOME/.config/darkredhack-theme"
USER_THEME=user-theme@gnome-shell-extensions.gcampax.github.com
GT=/org/gnome/terminal/legacy/profiles:
GT_UUID=a302d580-50d7-4ed4-bd6f-91974153d618
PTYXIS_UUID=b49cc603d8794dba877309d3de778fbf

# Put a GSettings key back: the saved value, or the system default when none was saved (the key was not set).
restore() { if [[ -n $3 ]]; then gsettings set "$1" "$2" "$3"; else gsettings reset "$1" "$2"; fi; }
# Remove an item from a GSettings string list ("['a', 'b']").
list_remove() { local list=${1//", '$2'"/}; list=${list//"'$2', "/}; echo "${list//"'$2'"/}"; }
# Drop the line install.sh added to a terminal config file, and the file itself if nothing else is left in it.
drop_line() {
  [[ -f $1 ]] || return 0
  grep -vxF "$2" "$1" > "$1.new" || true
  mv "$1.new" "$1"
  grep -qvE '^\s*(\[general\])?\s*$' "$1" || rm -f "$1"
}

if [[ ! -f $STATE/original.env ]]; then
  echo "DarkRedHack is not installed ($STATE/original.env not found)."
  exit 1
fi
source "$STATE/original.env"

# GNOME Shell: original theme back (applied live), User Themes off again if it was off.
if [[ -n $SHELL_THEME ]]; then
  dconf write /org/gnome/shell/extensions/user-theme/name "$SHELL_THEME"
else
  dconf reset /org/gnome/shell/extensions/user-theme/name
fi
if [[ $USER_THEME_WAS_ENABLED == no ]]; then
  gsettings set org.gnome.shell enabled-extensions "$(list_remove "$(gsettings get org.gnome.shell enabled-extensions)" "$USER_THEME")"
fi

# Terminals: DarkRedHack profiles and color files out, the previous default profiles back.
if [[ -f $STATE/gnome-terminal-default ]]; then
  dconf write "$GT/default" "$(< "$STATE/gnome-terminal-default")"
  dconf write "$GT/list" "$(list_remove "$(dconf read "$GT/list")" "$GT_UUID")"
  dconf reset -f "$GT/:$GT_UUID/"
fi
ptyxis=()
if command -v ptyxis > /dev/null; then
  ptyxis=(gsettings)
  ptyxis_palettes="$HOME/.local/share/org.gnome.Ptyxis/palettes"
elif flatpak info app.devsuite.Ptyxis > /dev/null 2>&1; then
  ptyxis=(flatpak run --command=gsettings app.devsuite.Ptyxis)
  ptyxis_palettes="$HOME/.var/app/app.devsuite.Ptyxis/data/app.devsuite.Ptyxis/palettes"
fi
if (( ${#ptyxis[@]} )) && [[ -f $STATE/ptyxis@default-profile-uuid ]]; then
  # Default profile, font and window size as they were.
  for f in "$STATE"/ptyxis@*; do
    "${ptyxis[@]}" set org.gnome.Ptyxis "${f##*/ptyxis@}" "$(< "$f")"
  done
  "${ptyxis[@]}" set org.gnome.Ptyxis profile-uuids \
    "$(list_remove "$("${ptyxis[@]}" get org.gnome.Ptyxis profile-uuids)" "$PTYXIS_UUID")"
  "${ptyxis[@]}" reset-recursively "org.gnome.Ptyxis.Profile:/org/gnome/Ptyxis/Profiles/$PTYXIS_UUID/"
  rm -f "$ptyxis_palettes/DarkRedHack.palette"
fi
ptyxis_css="$HOME/.var/app/app.devsuite.Ptyxis/config/gtk-4.0/gtk.css"
if grep -qs 'DarkRedHack' "$ptyxis_css"; then rm -f "$ptyxis_css"; fi
rm -f "$HOME/.config/alacritty/darkredhack.toml" "$HOME/.config/kitty/darkredhack.conf"
drop_line "$HOME/.config/alacritty/alacritty.toml" 'import = ["~/.config/alacritty/darkredhack.toml"]'
drop_line "$HOME/.config/kitty/kitty.conf" 'include darkredhack.conf'
rmdir --ignore-fail-on-non-empty "$HOME/.config/alacritty" "$HOME/.config/kitty" 2> /dev/null || true

# VS Code: theme out; the profile goes only while VS Code is closed, since it rewrites its profile list on exit.
if command -v code > /dev/null; then
  NODE_NO_WARNINGS=1 code --uninstall-extension darkredhack.darkredhack-theme > /dev/null 2>&1 || true
  if pgrep -x code > /dev/null; then
    echo "VS Code is open: delete the DarkRedHack profile from its Profiles menu."
  else
    python3 -I "$SRC/vscode/profile.py" remove
  fi
fi

# Desktop settings changed one by one (fonts, GNOME Console), back to the values saved by install.sh.
for f in "$STATE"/gsettings@*; do
  [[ -f $f ]] || continue
  id=${f##*/gsettings@}
  restore "${id%@*}" "${id#*@}" "$(< "$f")"
done

# GTK: original theme and color scheme, our stylesheets out, the previous ones back.
restore org.gnome.desktop.interface gtk-theme "$GTK_THEME"
restore org.gnome.desktop.interface color-scheme "$COLOR_SCHEME"
rm -rf "$HOME/.local/share/themes/DarkRedHack" "$GTK3/darkredhack-assets" "$HOME/.local/share/fonts/ChakraPetch"
fc-cache -f "$HOME/.local/share/fonts"
rm -f "$GTK3/gtk.css" "$GTK4/gtk.css"
if [[ -e $STATE/gtk3.css.orig ]]; then mv "$STATE/gtk3.css.orig" "$GTK3/gtk.css"; fi
if [[ -e $STATE/gtk4.css.orig ]]; then mv "$STATE/gtk4.css.orig" "$GTK4/gtk.css"; fi
rm -rf "$STATE"

echo "Original theme restored. Reopen apps to see the change."

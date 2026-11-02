#!/usr/bin/env bash
# Remove the DarkRedHack theme and restore the look saved by install.sh. Unattended, no restart needed.
# Installed packages (User Themes extension, JetBrains Mono, xdotool) are kept: they are harmless.
set -euo pipefail

GTK3="$HOME/.config/gtk-3.0"
GTK4="$HOME/.config/gtk-4.0"
STATE="$HOME/.config/darkredhack-theme"
USER_THEME=user-theme@gnome-shell-extensions.gcampax.github.com

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
  list=$(gsettings get org.gnome.shell enabled-extensions)
  list=${list//", '$USER_THEME'"/}
  list=${list//"'$USER_THEME', "/}
  list=${list//"'$USER_THEME'"/}
  gsettings set org.gnome.shell enabled-extensions "$list"
fi

# GTK: original theme and color scheme, our stylesheets out, the previous ones back.
gsettings set org.gnome.desktop.interface gtk-theme "$GTK_THEME"
gsettings set org.gnome.desktop.interface color-scheme "$COLOR_SCHEME"
rm -rf "$HOME/.local/share/themes/DarkRedHack" "$GTK3/darkredhack-assets"
rm -f "$GTK3/gtk.css" "$GTK4/gtk.css"
if [[ -e $STATE/gtk3.css.orig ]]; then mv "$STATE/gtk3.css.orig" "$GTK3/gtk.css"; fi
if [[ -e $STATE/gtk4.css.orig ]]; then mv "$STATE/gtk4.css.orig" "$GTK4/gtk.css"; fi
rm -rf "$STATE"

echo "Original theme restored. Reopen apps to see the change."

#!/usr/bin/env bash
# Install and activate the "DarkRedHack" theme (dark + red, palette from cve.now) on Ubuntu 24.04 / GNOME 46.
# Fully unattended (needs passwordless sudo). Safe to run again: it rebuilds and re-applies.
#
#   GNOME Shell     -> ~/.local/share/themes/DarkRedHack/gnome-shell  (via the User Themes extension)
#   GTK3 apps       -> ~/.config/gtk-3.0/gtk.css + darkredhack-assets/
#   GTK4/libadwaita -> ~/.config/gtk-4.0/gtk.css
#
# The GTK theme stays "Yaru-dark" and the color scheme is forced to dark, so Snap/Flatpak and
# Electron apps (Slack, Firefox, ...), which cannot read custom themes, stay dark too.
# The look found before the first install is saved in ~/.config/darkredhack-theme: uninstall.sh restores it.
set -euo pipefail

SRC="$(cd "$(dirname "$0")" && pwd)"
YARU=/usr/share/themes/Yaru-dark
GRES="$YARU/gtk-3.0/gtk.gresource"
RES=/com/ubuntu/themes/Yaru-dark/3.0
SHELL_DEST="$HOME/.local/share/themes/DarkRedHack/gnome-shell"
GTK3="$HOME/.config/gtk-3.0"
GTK4="$HOME/.config/gtk-4.0"
STATE="$HOME/.config/darkredhack-theme"
USER_THEME=user-theme@gnome-shell-extensions.gcampax.github.com
PACKAGES=(yaru-theme-gtk yaru-theme-gnome-shell gnome-shell-extensions fonts-jetbrains-mono libglib2.0-bin dconf-cli xdotool)

recolor() { python3 -I "$SRC/recolor.py"; }

echo "==> Installing packages"
apt_install() { sudo DEBIAN_FRONTEND=noninteractive apt-get install -y -qq "${PACKAGES[@]}" > /dev/null; }
apt_install || { sudo apt-get update -qq && apt_install; }

mkdir -p "$GTK3" "$GTK4"
if [[ ! -f $STATE/original.env ]]; then
  echo "==> Saving the current look for uninstall.sh"
  mkdir -p "$STATE"
  if [[ -e $GTK3/gtk.css ]]; then mv "$GTK3/gtk.css" "$STATE/gtk3.css.orig"; fi
  if [[ -e $GTK4/gtk.css ]]; then mv "$GTK4/gtk.css" "$STATE/gtk4.css.orig"; fi
  enabled=$(gsettings get org.gnome.shell enabled-extensions)
  {
    printf 'GTK_THEME=%q\n' "$(gsettings get org.gnome.desktop.interface gtk-theme)"
    printf 'COLOR_SCHEME=%q\n' "$(gsettings get org.gnome.desktop.interface color-scheme)"
    printf 'SHELL_THEME=%q\n' "$(dconf read /org/gnome/shell/extensions/user-theme/name)"
    printf 'USER_THEME_WAS_ENABLED=%q\n' "$([[ $enabled == *"$USER_THEME"* ]] && echo yes || echo no)"
  } > "$STATE/original.env"
fi

echo "==> Building the GNOME Shell theme"
rm -rf "$SHELL_DEST" && mkdir -p "$SHELL_DEST"
for f in "$YARU"/gnome-shell/*; do
  case "$f" in
    *.css|*.svg) recolor < "$f" > "$SHELL_DEST/${f##*/}" ;;
    *) cp "$f" "$SHELL_DEST/" ;;
  esac
done
sed -i 's|resource:///org/gnome/shell/theme/||g' "$SHELL_DEST/gnome-shell.css"
cat "$SRC/shell-extra.css" >> "$SHELL_DEST/gnome-shell.css"

echo "==> Building the GTK3 and GTK4 stylesheets"
rm -rf "$GTK3/darkredhack-assets" && mkdir -p "$GTK3/darkredhack-assets"
gresource list "$GRES" | grep "^$RES/assets/" | while read -r res; do
  out="$GTK3/darkredhack-assets/${res##*/}"
  if [[ $res == *.svg ]]; then
    gresource extract "$GRES" "$res" | recolor > "$out"
  else
    gresource extract "$GRES" "$res" > "$out"
  fi
done
{
  gresource extract "$GRES" "$RES/gtk.css" | recolor | sed 's|url("assets/|url("darkredhack-assets/|g'
  cat "$SRC/gtk-extra.css"
} > "$GTK3/gtk.css"
cat "$SRC/gtk-4.0.css" "$SRC/gtk-extra.css" > "$GTK4/gtk.css"

echo "==> Activating"
gsettings set org.gnome.desktop.interface color-scheme prefer-dark
gsettings set org.gnome.desktop.interface gtk-theme Yaru-dark
# Reset first: the Shell reloads its stylesheet only when the theme name changes.
dconf reset /org/gnome/shell/extensions/user-theme/name
sleep 1
dconf write /org/gnome/shell/extensions/user-theme/name "'DarkRedHack'"
enabled=$(gsettings get org.gnome.shell enabled-extensions)
case $enabled in
  *"$USER_THEME"*) ;;
  "@as []") gsettings set org.gnome.shell enabled-extensions "['$USER_THEME']" ;;
  *) gsettings set org.gnome.shell enabled-extensions "${enabled%]}, '$USER_THEME']" ;;
esac

# A running GNOME Shell only discovers newly installed extensions when it restarts.
if gnome-extensions info "$USER_THEME" > /dev/null 2>&1; then
  echo "Done: DarkRedHack is active. Reopen apps to see the change."
elif [[ ${XDG_SESSION_TYPE:-} == x11 && -n ${DISPLAY:-} ]] \
  && gdbus call --session --dest org.gnome.ScreenSaver --object-path /org/gnome/ScreenSaver \
       --method org.gnome.ScreenSaver.GetActive 2>/dev/null | grep -q false; then
  echo "Done: restarting GNOME Shell (same as Alt+F2 -> r, open windows are kept)."
  xdotool key --clearmodifiers alt+F2
  sleep 1
  xdotool type r
  xdotool key Return
else
  echo "Done: log out and back in to activate the GNOME Shell theme."
fi

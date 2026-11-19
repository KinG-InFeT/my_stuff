#!/usr/bin/env bash
# Install and activate the "DarkRedHack" theme (dark + red, palette from cve.now) on Ubuntu 24.04 / GNOME 46.
# Fully unattended (needs passwordless sudo). Safe to run again: it rebuilds and re-applies.
#
#   GNOME Shell     -> ~/.local/share/themes/DarkRedHack/gnome-shell  (via the User Themes extension)
#   GTK3 apps       -> ~/.config/gtk-3.0/gtk.css + darkredhack-assets/
#   GTK4/libadwaita -> ~/.config/gtk-4.0/gtk.css
#   Chakra Petch    -> ~/.local/share/fonts/ChakraPetch  (Google Fonts, OFL)
#   Terminals       -> a DarkRedHack profile for GNOME Terminal and Ptyxis, a color file for Alacritty and kitty
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
FONT_DIR="$HOME/.local/share/fonts/ChakraPetch"
FONT_URL=https://github.com/google/fonts/raw/main/ofl/chakrapetch
# Chakra Petch for the interface, documents and window titles. Terminals need a monospace font (Chakra Petch is
# proportional, so a terminal grid spreads its letters apart): JetBrains Mono.
FONT_FAMILY="Chakra Petch"
UI_FONT_SIZE=11
TERMINAL_FONT_FAMILY="JetBrains Mono"
TERMINAL_FONT_SIZE=11
USER_THEME=user-theme@gnome-shell-extensions.gcampax.github.com
GT=/org/gnome/terminal/legacy/profiles:
GT_UUID=a302d580-50d7-4ed4-bd6f-91974153d618
GT_BUILTIN=b1dcc9dd-5262-4d8d-a863-c897e6d979b9
PTYXIS_UUID=b49cc603d8794dba877309d3de778fbf
PACKAGES=(yaru-theme-gtk yaru-theme-gnome-shell gnome-shell-extensions fonts-jetbrains-mono python3-pil curl fontconfig
  libglib2.0-bin dconf-cli xdotool)

recolor() { python3 -I "$SRC/recolor.py" "$@"; }
# The GNOME Shell stylesheet has no variables: paste the palette.css values in place of the @drh_* names.
palette() { sed -E "$(sed -nE 's/^@define-color (drh_[a-z_]+) (.+);$/s|@\1\\b|\2|g;/p' "$SRC/palette.css")"; }
# Add an item to a GSettings string list ("['a', 'b']"; empty or "@as []" means no items).
list_add() { case $1 in *"'$2'"*) echo "$1" ;; "" | "@as []") echo "['$2']" ;; *) echo "${1%]}, '$2']" ;; esac; }
# Remember a setting as found the first time, so uninstall.sh can put it back.
remember() { [[ -f $STATE/$1 ]] || echo "$2" > "$STATE/$1"; }
# Change a GSettings key of the desktop, remembering its original value.
gset() { remember "gsettings@$1@$2" "$(gsettings get "$1" "$2")"; gsettings set "$1" "$2" "$3"; }
# A terminal template with the palette colors and the terminal font filled in.
terminal() {
  palette < "$SRC/terminals/$1" | sed "s|@font_family|$TERMINAL_FONT_FAMILY|g; s|@font_size|$TERMINAL_FONT_SIZE|g"
}
# GTK4 stylesheet for a given libadwaita version: 1.6+ styles its widgets with CSS variables (--window-bg-color)
# instead of named colors, so every @define-color line of gtk-4.0.css is also written as its variable.
gtk4_css() {
  cat "$SRC/palette.css" "$SRC/gtk-4.0.css" "$SRC/gtk-extra.css"
  if dpkg --compare-versions "$1" ge 1.6; then
    palette < "$SRC/gtk-4.0.css" | awk '$1 == "@define-color" {
      name = $2; gsub("_", "-", name); $1 = $2 = ""; sub(/^ +/, ""); print ":root { --" name ": " $0 " }" }'
  fi
}

echo "==> Installing packages"
apt_install() { sudo DEBIAN_FRONTEND=noninteractive apt-get install -y -qq "${PACKAGES[@]}" > /dev/null; }
apt_install || { sudo apt-get update -qq && apt_install; }

# OFL.txt is downloaded last, so it marks a complete download.
NEW_FONT=no
if [[ ! -f $FONT_DIR/OFL.txt ]]; then
  echo "==> Installing the Chakra Petch font"
  mkdir -p "$FONT_DIR"
  for f in ChakraPetch-Regular.ttf ChakraPetch-Medium.ttf ChakraPetch-SemiBold.ttf ChakraPetch-Bold.ttf OFL.txt; do
    curl -fsSL -o "$FONT_DIR/$f" "$FONT_URL/$f"
  done
  fc-cache -f "$FONT_DIR"
  NEW_FONT=yes
fi

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
palette < "$SRC/shell-extra.css" >> "$SHELL_DEST/gnome-shell.css"

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
# Symbolic PNGs are left alone: GTK paints them in the text color by itself.
find "$GTK3/darkredhack-assets" -name '*.png' ! -name '*.symbolic.png' -exec python3 -I "$SRC/recolor.py" --png {} +
{
  gresource extract "$GRES" "$RES/gtk.css" | recolor | sed 's|url("assets/|url("darkredhack-assets/|g'
  cat "$SRC/palette.css" "$SRC/gtk-extra.css"
} > "$GTK3/gtk.css"
gtk4_css "$(dpkg-query -W -f='${Version}' libadwaita-1-0)" > "$GTK4/gtk.css"

echo "==> Building the terminal profiles"
if command -v gnome-terminal > /dev/null; then
  echo "    GNOME Terminal"
  terminal gnome-terminal.dconf | dconf load "$GT/:$GT_UUID/"
  list=$(dconf read "$GT/list")
  dconf write "$GT/list" "$(list_add "${list:-['$GT_BUILTIN']}" "$GT_UUID")"
  default=$(dconf read "$GT/default")
  remember gnome-terminal-default "${default:-'$GT_BUILTIN'}"
  dconf write "$GT/default" "'$GT_UUID'"
fi
# Ptyxis: native package (Ubuntu 26.04+) or the Flathub app, which keeps its own settings and palettes.
ptyxis=()
if command -v ptyxis > /dev/null; then
  ptyxis=(gsettings)
  ptyxis_palettes="$HOME/.local/share/org.gnome.Ptyxis/palettes"
elif flatpak info app.devsuite.Ptyxis > /dev/null 2>&1; then
  ptyxis=(flatpak run --command=gsettings app.devsuite.Ptyxis)
  ptyxis_palettes="$HOME/.var/app/app.devsuite.Ptyxis/data/app.devsuite.Ptyxis/palettes"
  # The Flatpak reads its own GTK4 stylesheet (Flathub runtimes ship libadwaita 1.6+). A stylesheet of yours is kept.
  css="$HOME/.var/app/app.devsuite.Ptyxis/config/gtk-4.0/gtk.css"
  if [[ ! -e $css ]] || grep -qs 'DarkRedHack' "$css"; then
    mkdir -p "${css%/*}"
    gtk4_css 1.6 > "$css"
  fi
fi
if (( ${#ptyxis[@]} )); then
  echo "    Ptyxis"
  mkdir -p "$ptyxis_palettes"
  terminal ptyxis.palette > "$ptyxis_palettes/DarkRedHack.palette"
  profile="org.gnome.Ptyxis.Profile:/org/gnome/Ptyxis/Profiles/$PTYXIS_UUID/"
  "${ptyxis[@]}" set "$profile" label "'DarkRedHack'"
  "${ptyxis[@]}" set "$profile" palette "'DarkRedHack'"
  "${ptyxis[@]}" set org.gnome.Ptyxis profile-uuids \
    "$(list_add "$("${ptyxis[@]}" get org.gnome.Ptyxis profile-uuids)" "$PTYXIS_UUID")"
  # Default profile, terminal font and a 140x24 size for every new window (restoring the last size would override it).
  for setting in "default-profile-uuid='$PTYXIS_UUID'" use-system-font=false \
    "font-name='$TERMINAL_FONT_FAMILY $TERMINAL_FONT_SIZE'" default-columns=140 default-rows=24 restore-window-size=false; do
    key=${setting%%=*}
    remember "ptyxis@$key" "$("${ptyxis[@]}" get org.gnome.Ptyxis "$key")"
    "${ptyxis[@]}" set org.gnome.Ptyxis "$key" "${setting#*=}"
  done
fi
if command -v kgx > /dev/null; then
  echo "    GNOME Console (font only: Console has no setting for terminal colors)"
  gset org.gnome.Console use-system-font false
  gset org.gnome.Console custom-font "'$TERMINAL_FONT_FAMILY $TERMINAL_FONT_SIZE'"
fi
if command -v alacritty > /dev/null; then
  echo "    Alacritty"
  conf="$HOME/.config/alacritty/alacritty.toml"
  import='import = ["~/.config/alacritty/darkredhack.toml"]'
  mkdir -p "${conf%/*}"
  terminal alacritty.toml > "${conf%/*}/darkredhack.toml"
  if grep -qs 'darkredhack\.toml' "$conf"; then
    :
  elif grep -qsE '^\s*import\s*=' "$conf"; then
    echo "    Alacritty already imports other files: add ~/.config/alacritty/darkredhack.toml to that list in $conf"
  # Alacritty 0.14 moved "import" from the top of the file into the [general] table.
  elif dpkg --compare-versions "$(alacritty --version | cut -d' ' -f2)" lt 0.14; then
    { echo "$import"; cat "$conf" 2> /dev/null || true; } > "$conf.new" && mv "$conf.new" "$conf"
  elif grep -qs '^\[general\]' "$conf"; then
    sed -i "/^\[general\]/a $import" "$conf"
  else
    printf '[general]\n%s\n' "$import" >> "$conf"
  fi
fi
if command -v kitty > /dev/null; then
  echo "    kitty"
  mkdir -p "$HOME/.config/kitty"
  terminal kitty.conf > "$HOME/.config/kitty/darkredhack.conf"
  grep -qsx 'include darkredhack.conf' "$HOME/.config/kitty/kitty.conf" \
    || echo 'include darkredhack.conf' >> "$HOME/.config/kitty/kitty.conf"
fi

echo "==> Activating"
gsettings set org.gnome.desktop.interface color-scheme prefer-dark
gsettings set org.gnome.desktop.interface gtk-theme Yaru-dark
# Chakra Petch for the interface, documents and window titles. The monospace font stays: code editors need one.
gset org.gnome.desktop.interface font-name "'$FONT_FAMILY $UI_FONT_SIZE'"
gset org.gnome.desktop.interface document-font-name "'$FONT_FAMILY $UI_FONT_SIZE'"
gset org.gnome.desktop.wm.preferences titlebar-font "'$FONT_FAMILY Bold $UI_FONT_SIZE'"
# Reset first: the Shell reloads its stylesheet only when the theme name changes.
dconf reset /org/gnome/shell/extensions/user-theme/name
sleep 1
dconf write /org/gnome/shell/extensions/user-theme/name "'DarkRedHack'"
gsettings set org.gnome.shell enabled-extensions "$(list_add "$(gsettings get org.gnome.shell enabled-extensions)" "$USER_THEME")"

# A running GNOME Shell only discovers newly installed extensions and fonts when it restarts.
if [[ $NEW_FONT == no ]] && gnome-extensions info "$USER_THEME" > /dev/null 2>&1; then
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

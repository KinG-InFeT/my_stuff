# DarkRedHack

*English version: [README.md](README.md)*

Un tema GNOME scuro, squadrato, con accenti rossi e un look "hacker". La palette viene da [cve.now](https://cve.now).
Copre tutto il desktop: barra in alto e menu (GNOME Shell), app GTK3 e app GTK4/libadwaita.

- **Sempre scuro**: superfici quasi nere (`#0a0a0b`), linee e testi grigio freddo.
- **Squadrato**: tutti gli angoli limitati a 2px, finestre con angoli vivi, linee nette da 1px al posto delle ombre sfumate.
- **Tocchi di rosso**: linea rossa sotto la barra in alto e sotto ogni barra del titolo, barrette rosse dei workspace,
  toggle e interruttori rossi, indicatori rossi sulle voci di menu e sulle righe selezionate della barra laterale,
  titoli delle finestre rossi in monospace, cursore di testo rosso.
- **Etichette monospace**: JetBrains Mono per orologio, barra in alto e titoli delle finestre.

## Requisiti

- Ubuntu 24.04 con GNOME 46 (il tema è costruito a partire da Yaru-dark, il tema di Ubuntu).
- Permessi `sudo`. Con sudo senza password l'installazione non chiede nulla; altrimenti sudo chiede la password una volta.
- Una sessione X11 per l'attivazione completamente automatica. Su Wayland viene installato tutto lo stesso, ma per il tema
  della barra in alto serve uscire e rientrare nella sessione.

## Installazione

```bash
cd DarkRedHack
./install.sh
```

Partendo dallo zip: `unzip DarkRedHack.zip && cd DarkRedHack && bash install.sh`.

Lo script non richiede interventi e si può rilanciare in qualsiasi momento: ricostruisce il tema e lo ricarica. Fa questo:

1. **Pacchetti**: installa Yaru, l'estensione di GNOME Shell *User Themes*, il font JetBrains Mono e `xdotool`
   (serve per il riavvio automatico della Shell).
2. **Backup** (solo alla prima installazione): salva l'aspetto attuale (tema GTK, schema colori, tema della Shell, stato
   dell'estensione ed eventuali `~/.config/gtk-3.0/gtk.css` / `~/.config/gtk-4.0/gtk.css` già presenti) in `~/.config/darkredhack-theme/`.
3. **Costruzione**: trasforma Yaru-dark in DarkRedHack con `recolor.py` (ricolorazione + angoli squadrati) e aggiunge i fogli di stile extra.
4. **Attivazione**: forza lo schema colori scuro, mantiene `Yaru-dark` come tema GTK, seleziona DarkRedHack come tema della
   Shell e abilita l'estensione User Themes.
5. **Riavvio della Shell**: GNOME Shell vede un'estensione appena installata solo dopo un riavvio. Su X11 lo script lo fa da
   solo (come `Alt+F2` → `r`: le finestre aperte restano). Su Wayland chiede di uscire e rientrare nella sessione.

Le app già aperte prendono il nuovo aspetto quando le riapri.

### Dove vengono scritti i file

| Parte | File scritti |
|---|---|
| GNOME Shell (barra in alto, menu, impostazioni rapide, notifiche, panoramica) | `~/.local/share/themes/DarkRedHack/gnome-shell/` |
| App GTK3 (es. Terminale) | `~/.config/gtk-3.0/gtk.css` + `~/.config/gtk-3.0/darkredhack-assets/` |
| App GTK4 / libadwaita (File, Impostazioni, Editor di testo, …) | `~/.config/gtk-4.0/gtk.css` |
| Backup dell'aspetto originale | `~/.config/darkredhack-theme/` |

## Perché è sempre scuro

- I fogli di stile della Shell e di GTK3 sono costruiti solo dalla variante **scura** di Yaru, e quello GTK4 ridefinisce
  come scuri tutti i colori di libadwaita.
- L'installazione forza lo schema colori di sistema su scuro (`prefer-dark`).
- Il nome del tema GTK resta `Yaru-dark` di proposito. Le app Snap/Flatpak ed Electron (Slack, Firefox, Spotify, …) non
  possono leggere i temi personalizzati dalla tua home: con un nome di tema GTK personalizzato ripiegherebbero sul tema
  chiaro di default. Con `Yaru-dark` restano scure, mentre le app normali prendono l'aspetto DarkRedHack dai fogli di stile utente.

Non passare a *Chiaro* in *Impostazioni → Aspetto*: Ubuntu cambierebbe il tema GTK e le app Snap/Flatpak diventerebbero chiare.
Se succede, rilancia `./install.sh`.

## Disinstallazione: tornare al tema originale

```bash
./uninstall.sh
```

Ripristina esattamente quanto salvato alla prima installazione (tema GTK, schema colori, tema della Shell, estensione
User Themes attiva o no, i tuoi `gtk.css` precedenti) e cancella tutti i file di DarkRedHack. Non serve riavviare: la barra
in alto torna subito com'era, le app quando le riapri. I pacchetti installati restano: senza il tema non cambiano nulla.
Per rimuovere anche quelli:

```bash
sudo apt remove gnome-shell-extensions fonts-jetbrains-mono xdotool
```

### Ripristino manuale (se la cartella di backup non c'è più)

```bash
gsettings set org.gnome.desktop.interface gtk-theme Yaru-dark
gsettings set org.gnome.desktop.interface color-scheme prefer-dark
dconf reset /org/gnome/shell/extensions/user-theme/name
gnome-extensions disable user-theme@gnome-shell-extensions.gcampax.github.com
rm -rf ~/.local/share/themes/DarkRedHack ~/.config/gtk-3.0/darkredhack-assets ~/.config/darkredhack-theme
rm -f ~/.config/gtk-3.0/gtk.css ~/.config/gtk-4.0/gtk.css
```

Oppure, dopo aver rimosso i file qui sopra, scegli semplicemente un altro stile in *Impostazioni → Aspetto*.

## Personalizzazione

Modifica i file in questa cartella, poi rilancia `./install.sh` per ricostruire e ricaricare il tema.

| File | Cosa controlla |
|---|---|
| `recolor.py` | Come vengono convertiti i colori di Yaru-dark (grigi, arancione → rosso, giallo → ambra, verde → verde acqua) e il raggio degli angoli. `MAX_RADIUS = 0` rende gli angoli perfettamente squadrati, `RED_HUE` cambia la tonalità dell'accento, `LIGHTNESS_CURVE` rende le superfici più scure o più chiare. |
| `shell-extra.css` | Regole extra per GNOME Shell: linea e font della barra in alto, barrette rosse su menu e notifiche, evidenziazione delle voci di menu, angoli della dock. |
| `gtk-4.0.css` | Colori GTK4/libadwaita (`@define-color …`), raggio degli angoli e linee. |
| `gtk-extra.css` | Tocchi di rosso comuni a GTK3 e GTK4: cursore di testo, linea sotto la barra del titolo, titoli delle finestre, selezione nella barra laterale, barre di scorrimento. |
| `install.sh` / `uninstall.sh` | Costruzione, attivazione e rimozione. |

### Palette

| Ruolo | Colore |
|---|---|
| Sfondo | `#0a0a0b` |
| Superficie / superficie 2 | `#111113` / `#17171a` |
| Linee (normali / marcate) | `#222226` / `#2c2c31` |
| Testo / testo secondario | `#e6e8ec` / `#8a8d96` |
| Rosso (accento) / rosso per pulsanti pieni | `#ff0027` / `#d70022` |
| Linea rossa (rosso al 45%) | `rgba(255, 0, 39, 0.45)` |
| Ambra (avvisi) | `#ffbb00` |
| Verde (successo) | `#0fd29b` |
| Font | JetBrains Mono (etichette, titoli, barra in alto) |

### Note per modificare il foglio di stile della Shell

Il motore CSS di GNOME Shell non è un browser. Due stranezze incontrate costruendo questo tema:

- I bordi su un solo lato vanno scritti in forma estesa: `border-bottom-width: 1px; border-color: …;`
  (la forma abbreviata `border-bottom: 1px solid …` viene ignorata).
- In `font-family` solo il primo nome può stare tra virgolette: `font-family: JetBrains Mono, Ubuntu Sans Mono, monospace;`.

Gli errori compaiono nel log della sessione: `journalctl --user -f -o cat | grep -i -E 'theme|parse'`.

## Risoluzione dei problemi

- **La barra in alto non è cambiata**: controlla `gnome-extensions info user-theme@gnome-shell-extensions.gcampax.github.com`
  (lo stato deve essere *ACTIVE*). Se l'estensione risulta sconosciuta, la Shell non si è ancora riavviata: premi `Alt+F2`,
  scrivi `r` e premi Invio (X11), oppure esci e rientra nella sessione (Wayland).
- **Un'app è ancora chiara**: riaprila. Le app Snap/Flatpak/Electron usano Yaru-dark, non DarkRedHack: restano scure ma senza i tocchi di rosso.
- **Dopo un aggiornamento di Ubuntu il tema ha qualcosa di strano**: rilancia `./install.sh` per ricostruirlo dallo Yaru-dark aggiornato.
- **Colori del terminale**: l'area di testo del terminale usa la palette del profilo (Terminale → Preferenze → Profilo → Colori), non il tema.

## Contenuto della cartella

```
DarkRedHack/
├── README.md         documentazione in inglese
├── README.it.md      questo file
├── install.sh        installazione e attivazione automatiche
├── uninstall.sh      ripristino dell'aspetto originale
├── recolor.py        convertitore Yaru-dark → DarkRedHack (colori + angoli)
├── shell-extra.css   regole extra per GNOME Shell
├── gtk-4.0.css       colori e forme per GTK4 / libadwaita
└── gtk-extra.css     tocchi di rosso per GTK3 e GTK4
```

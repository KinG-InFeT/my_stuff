# DarkRedHack

*English version: [README.md](README.md)*

Un tema GNOME scuro, piatto, completamente squadrato, con linee rosse e un look "hacker" da terminale. La palette viene da [cve.now](https://cve.now).
Copre tutto il desktop: barra in alto e menu (GNOME Shell), app GTK3 e app GTK4/libadwaita.

- **Sempre scuro**: superfici nere (`#0a0a0b`), linee e testi grigio freddo.
- **Piatto e squadrato**: nessun angolo arrotondato (pulsanti, menu, interruttori, radio button, avatar e cursori degli slider
  compresi), nessuna ombra sfumata, solo linee nette da 1px.
- **Finestre stile terminale**: niente ombra e una cornice rossa da 1px (grigia quando la finestra non è attiva), titolo disegnato
  come `─┤ titolo ├─`, pulsanti della finestra come `[_] [□] [×]` (rossi al passaggio del mouse), campi di testo e pulsanti di testo
  solo bordati come `[ Go ]`, azioni principali e distruttive con bordo e testo rossi invece del riempimento rosso.
- **Tocchi di rosso**: linea rossa sotto la barra in alto e sotto ogni barra del titolo, barrette rosse dei workspace,
  toggle e interruttori rossi, indicatori rossi sulle voci di menu e sulle righe selezionate della barra laterale, cursore di testo rosso.
- **Chakra Petch** ([Google Fonts](https://fonts.google.com/specimen/Chakra+Petch), licenza OFL): tutta la GNOME Shell, i titoli delle
  finestre e i titoli grandi delle pagine. Il testo normale delle app resta nel font di sistema, per leggibilità.

## Requisiti

- Ubuntu 24.04 con GNOME 46 (il tema è costruito a partire da Yaru-dark, il tema di Ubuntu). Sono gestite anche le versioni più
  recenti di libadwaita (1.6+), vedi [Versioni di libadwaita](#versioni-di-libadwaita).
- Permessi `sudo`. Con sudo senza password l'installazione non chiede nulla; altrimenti sudo chiede la password una volta.
- Connessione a Internet alla prima installazione, per scaricare il font Chakra Petch dal repository di Google Fonts su GitHub.
- Una sessione X11 per l'attivazione completamente automatica. Su Wayland viene installato tutto lo stesso, ma per il tema
  della barra in alto serve uscire e rientrare nella sessione.

## Installazione

```bash
cd DarkRedHack
./install.sh
```

Partendo dallo zip: `unzip DarkRedHack.zip && cd DarkRedHack && bash install.sh`.

Lo script non richiede interventi e si può rilanciare in qualsiasi momento: ricostruisce il tema e lo ricarica. Fa questo:

1. **Pacchetti**: installa Yaru, l'estensione di GNOME Shell *User Themes*, Pillow (per ricolorare le immagini PNG), `curl` e
   `xdotool` (serve per il riavvio automatico della Shell).
2. **Font** (solo alla prima installazione): scarica Chakra Petch (regular, medium, semibold, bold e la licenza OFL) in
   `~/.local/share/fonts/ChakraPetch/`.
3. **Backup** (solo alla prima installazione): salva l'aspetto attuale (tema GTK, schema colori, tema della Shell, stato
   dell'estensione ed eventuali `~/.config/gtk-3.0/gtk.css` / `~/.config/gtk-4.0/gtk.css` già presenti) in `~/.config/darkredhack-theme/`.
4. **Costruzione**: trasforma Yaru-dark in DarkRedHack con `recolor.py` (ricolorazione di CSS, SVG e PNG + angoli squadrati) e
   aggiunge i fogli di stile extra, con i colori presi da `palette.css`.
5. **Attivazione**: forza lo schema colori scuro, mantiene `Yaru-dark` come tema GTK, seleziona DarkRedHack come tema della
   Shell e abilita l'estensione User Themes.
6. **Riavvio della Shell**: GNOME Shell vede un'estensione o un font appena installati solo dopo un riavvio. Quando ne è appena
   stato installato uno, su X11 lo script lo fa da solo (come `Alt+F2` → `r`: le finestre aperte restano); su Wayland chiede di
   uscire e rientrare nella sessione.

Le app già aperte prendono il nuovo aspetto quando le riapri.

### Dove vengono scritti i file

| Parte | File scritti |
|---|---|
| GNOME Shell (barra in alto, menu, impostazioni rapide, notifiche, panoramica) | `~/.local/share/themes/DarkRedHack/gnome-shell/` |
| App GTK3 (es. Terminale) | `~/.config/gtk-3.0/gtk.css` + `~/.config/gtk-3.0/darkredhack-assets/` |
| App GTK4 / libadwaita (File, Impostazioni, Editor di testo, …) | `~/.config/gtk-4.0/gtk.css` |
| Font Chakra Petch | `~/.local/share/fonts/ChakraPetch/` |
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

## Versioni di libadwaita

libadwaita 1.5 (Ubuntu 24.04) legge i colori con nome, come `@define-color window_bg_color …`. Dalla 1.6 in poi legge invece
variabili CSS, come `:root { --window-bg-color: …; }`. `install.sh` controlla il pacchetto `libadwaita-1-0` installato: dalla 1.6
in poi trasforma anche ogni riga `@define-color` di `gtk-4.0.css` nella variabile corrispondente (`window_bg_color` →
`--window-bg-color`). Dopo un aggiornamento di Ubuntu rilancia `./install.sh` per passare al nuovo formato.

## Disinstallazione: tornare al tema originale

```bash
./uninstall.sh
```

Ripristina esattamente quanto salvato alla prima installazione (tema GTK, schema colori, tema della Shell, estensione
User Themes attiva o no, i tuoi `gtk.css` precedenti) e cancella tutti i file di DarkRedHack, compreso il font Chakra Petch.
Non serve riavviare: la barra in alto torna subito com'era, le app quando le riapri. I pacchetti installati restano: senza il
tema non cambiano nulla. Per rimuovere anche quelli:

```bash
sudo apt remove gnome-shell-extensions xdotool
```

### Ripristino manuale (se la cartella di backup non c'è più)

```bash
gsettings set org.gnome.desktop.interface gtk-theme Yaru-dark
gsettings set org.gnome.desktop.interface color-scheme prefer-dark
dconf reset /org/gnome/shell/extensions/user-theme/name
gnome-extensions disable user-theme@gnome-shell-extensions.gcampax.github.com
rm -rf ~/.local/share/themes/DarkRedHack ~/.config/gtk-3.0/darkredhack-assets ~/.config/darkredhack-theme ~/.local/share/fonts/ChakraPetch
rm -f ~/.config/gtk-3.0/gtk.css ~/.config/gtk-4.0/gtk.css
```

Oppure, dopo aver rimosso i file qui sopra, scegli semplicemente un altro stile in *Impostazioni → Aspetto*.

## Personalizzazione

Modifica i file in questa cartella, poi rilancia `./install.sh` per ricostruire e ricaricare il tema.

| File | Cosa controlla |
|---|---|
| `palette.css` | Tutti i colori del tema, in un unico posto (`@define-color drh_…`). GTK3 e GTK4 lo leggono direttamente, `install.sh` copia i valori nel foglio di stile della Shell, `recolor.py` ne prende le tonalità di rosso, ambra e verde. Per cambiare l'accento modifica `drh_red`, `drh_red_fill` e le tre righe rosse `rgba(…)`. |
| `recolor.py` | Come vengono convertiti i colori di Yaru-dark (grigi, arancione → rosso, giallo → ambra, verde → verde acqua) e il raggio degli angoli. `MAX_RADIUS = 0` squadra tutto (px, %, `rx`/`ry` degli SVG); `LIGHTNESS_CURVE` rende le superfici più scure o più chiare. |
| `shell-extra.css` | Regole extra per GNOME Shell: Chakra Petch, linea della barra in alto, barrette rosse su menu e notifiche, evidenziazione delle voci di menu, angoli della dock. I colori sono scritti come nomi `@drh_…`. |
| `gtk-4.0.css` | Colori GTK4/libadwaita (`@define-color …`, presi dalla palette), angoli squadrati, cornice rossa delle finestre, campi di testo. |
| `gtk-extra.css` | Regole comuni a GTK3 e GTK4: finestre nere, cornice delle finestre GTK3, `─┤ titolo ├─`, pulsanti finestra `[×]`, pulsanti e campi di testo bordati, selezione nella barra laterale, barre di scorrimento. |
| `install.sh` / `uninstall.sh` | Costruzione, attivazione e rimozione. |

### Palette (`palette.css`)

| Ruolo | Nome | Colore |
|---|---|---|
| Sfondo | `drh_bg` | `#0a0a0b` |
| Superficie / alternativa / rialzata | `drh_surface` / `drh_surface_alt` / `drh_raised` | `#111113` / `#0e0e10` / `#17171a` |
| Linee (normali / marcate) | `drh_line` / `drh_line_strong` | `#222226` / `#2c2c31` |
| Testo / testo secondario | `drh_fg` / `drh_muted` | `#e6e8ec` / `#8a8d96` |
| Rosso (accento) / rosso pieno | `drh_red` / `drh_red_fill` | `#ff0027` / `#d70022` |
| Linea rossa / velatura / velatura forte | `drh_red_line` / `drh_red_tint` / `drh_red_tint_strong` | rosso al 45% / 12% / 22% |
| Ambra (avvisi) | `drh_amber` | `#ffbb00` |
| Verde (successo) | `drh_green` | `#0fd29b` |

### Note per modificare i fogli di stile

Il motore CSS di GNOME Shell non è un browser. Stranezze incontrate costruendo questo tema:

- I bordi su un solo lato vanno scritti in forma estesa: `border-bottom-width: 1px; border-color: …;`
  (la forma abbreviata `border-bottom: 1px solid …` viene ignorata).
- In `font-family` solo il primo nome può stare tra virgolette: `font-family: Chakra Petch, Ubuntu Sans, sans-serif;`.

In GTK3 le regole extra stanno nello stesso file di tutto il foglio di stile Yaru ricolorato, quindi vincono solo con un
selettore specifico almeno quanto quello di Yaru (per esempio Yaru disegna i pulsanti della finestra con
`.titlebar button.titlebutton:not(.appmenu).close`). GTK4 carica il foglio di stile utente con priorità più alta del tema,
quindi lì vince qualsiasi selettore che corrisponde.

Il CSS di GTK non può spostare il titolo della finestra: la barra del titolo lo centra sempre, qualunque cosa dica il foglio di stile.

Gli errori compaiono nel log della sessione: `journalctl --user -f -o cat | grep -i -E 'theme|parse'`.

## Risoluzione dei problemi

- **La barra in alto non è cambiata**: controlla `gnome-extensions info user-theme@gnome-shell-extensions.gcampax.github.com`
  (lo stato deve essere *ACTIVE*). Se l'estensione risulta sconosciuta, la Shell non si è ancora riavviata: premi `Alt+F2`,
  scrivi `r` e premi Invio (X11), oppure esci e rientra nella sessione (Wayland).
- **La barra in alto non è in Chakra Petch**: la Shell carica i font solo all'avvio. Riavviala come sopra.
- **Un'app è ancora chiara, o ha ancora pulsanti tondi**: riaprila. Le app Snap/Flatpak/Electron usano Yaru-dark, non
  DarkRedHack: restano scure ma senza i tocchi di rosso.
- **Dopo un aggiornamento di Ubuntu il tema ha qualcosa di strano**: rilancia `./install.sh` per ricostruirlo dallo Yaru-dark aggiornato.
- **Colori del terminale**: l'area di testo del terminale usa la palette del profilo (Terminale → Preferenze → Profilo → Colori), non il tema.

## Contenuto della cartella

```
DarkRedHack/
├── README.md         documentazione in inglese
├── README.it.md      questo file
├── install.sh        installazione e attivazione automatiche
├── uninstall.sh      ripristino dell'aspetto originale
├── palette.css       tutti i colori del tema
├── recolor.py        convertitore Yaru-dark → DarkRedHack (colori + angoli, CSS/SVG/PNG)
├── shell-extra.css   regole extra per GNOME Shell
├── gtk-4.0.css       colori e forme per GTK4 / libadwaita
└── gtk-extra.css     finestre stile terminale per GTK3 e GTK4
```

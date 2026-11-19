#!/usr/bin/env python3
"""Create or remove the DarkRedHack VS Code profile. VS Code must be closed: it rewrites its state file on exit.

  profile.py create   register the profile and give it its own settings: a copy of the Default profile's settings
                      with the DarkRedHack color theme. Extensions, keybindings, snippets, tasks, MCP servers and
                      prompts stay shared with the Default profile.
  profile.py remove   unregister the profile and delete its folder.
"""
import json
import re
import shutil
import sys
from pathlib import Path

USER = Path.home() / ".config/Code/User"
STORAGE = USER / "globalStorage/storage.json"
LOCATION = "darkredhack"
SHARED = ("keybindings", "snippets", "tasks", "extensions", "mcp", "prompts", "languageModels")
THEME_RE = re.compile(r'"workbench\.colorTheme"\s*:\s*"[^"]*"')
THEME = '"workbench.colorTheme": "DarkRedHack"'


def save(path, text):
    temporary = path.with_name(path.name + ".new")
    temporary.write_text(text)
    temporary.replace(path)


def create():
    state = json.loads(STORAGE.read_text())
    profiles = state.setdefault("userDataProfiles", [])
    if not any(profile.get("location") == LOCATION for profile in profiles):
        profiles.append({"location": LOCATION, "name": "DarkRedHack", "useDefaultFlags": dict.fromkeys(SHARED, True)})
        save(STORAGE, json.dumps(state, indent=4))
    # settings.json may contain comments (JSONC): only the theme line is touched, as text.
    settings = USER / "profiles" / LOCATION / "settings.json"
    if not settings.exists():
        settings.parent.mkdir(parents=True, exist_ok=True)
        default = USER / "settings.json"
        settings.write_text(default.read_text() if default.exists() else "{}\n")
    text = settings.read_text()
    if THEME_RE.search(text):
        text = THEME_RE.sub(THEME, text)
    else:
        text = text.replace("{", "{\n    " + THEME + ",", 1)
    save(settings, text)


def remove():
    state = json.loads(STORAGE.read_text())
    state["userDataProfiles"] = [p for p in state.get("userDataProfiles", []) if p.get("location") != LOCATION]
    for group in state.get("profileAssociations", {}).values():
        for key in [key for key, profile in group.items() if profile == LOCATION]:
            del group[key]
    save(STORAGE, json.dumps(state, indent=4))
    shutil.rmtree(USER / "profiles" / LOCATION, ignore_errors=True)


if __name__ == "__main__":
    {"create": create, "remove": remove}[sys.argv[1]]()

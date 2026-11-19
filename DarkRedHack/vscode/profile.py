#!/usr/bin/env python3
"""Create or remove the DarkRedHack VS Code profile. VS Code must be closed: it rewrites its state file on exit.

  profile.py create   register the profile and give it its own settings: a copy of the Default profile's settings
                      with the DarkRedHack color theme. Extensions, keybindings, snippets, tasks, MCP servers and
                      prompts stay shared with the Default profile. Every saved workspace that opens in the Default
                      profile opens in DarkRedHack from now on, and so do new windows (window.newWindowProfile).
  profile.py remove   unregister the profile, delete its folder and give those workspaces back to Default.
"""
import json
import re
import shutil
import sys
from pathlib import Path

USER = Path.home() / ".config/Code/User"
STORAGE = USER / "globalStorage/storage.json"
SETTINGS = USER / "settings.json"
LOCATION = "darkredhack"
DEFAULT = "__default__profile__"
SHARED = ("keybindings", "snippets", "tasks", "extensions", "mcp", "prompts", "languageModels")


def save(path, text):
    temporary = path.with_name(path.name + ".new")
    temporary.write_text(text)
    temporary.replace(path)


def set_setting(path, key, value):
    """Set one string key in a settings file. It may contain comments (JSONC), so only that line is edited, as text."""
    text = path.read_text() if path.exists() else "{}\n"
    line = f'"{key}": "{value}"'
    pattern = re.compile(rf'"{re.escape(key)}"\s*:\s*"[^"]*"')
    save(path, pattern.sub(line, text) if pattern.search(text) else text.replace("{", "{\n    " + line + ",", 1))


def drop_setting(path, key, value):
    if path.exists():
        line = rf'^[ \t]*"{re.escape(key)}"\s*:\s*"{re.escape(value)}"\s*,?[ \t]*\n'
        save(path, re.sub(line, "", path.read_text(), flags=re.M))


def create():
    state = json.loads(STORAGE.read_text())
    profiles = state.setdefault("userDataProfiles", [])
    if not any(profile.get("location") == LOCATION for profile in profiles):
        profiles.append({"location": LOCATION, "name": "DarkRedHack", "useDefaultFlags": dict.fromkeys(SHARED, True)})
    for group in state.get("profileAssociations", {}).values():
        for key, profile in group.items():
            if profile == DEFAULT:
                group[key] = LOCATION
    save(STORAGE, json.dumps(state, indent=4))
    settings = USER / "profiles" / LOCATION / "settings.json"
    if not settings.exists():
        settings.parent.mkdir(parents=True, exist_ok=True)
        settings.write_text(SETTINGS.read_text() if SETTINGS.exists() else "{}\n")
    set_setting(settings, "workbench.colorTheme", "DarkRedHack")
    set_setting(SETTINGS, "window.newWindowProfile", "DarkRedHack")


def remove():
    state = json.loads(STORAGE.read_text())
    state["userDataProfiles"] = [p for p in state.get("userDataProfiles", []) if p.get("location") != LOCATION]
    for group in state.get("profileAssociations", {}).values():
        for key in [key for key, profile in group.items() if profile == LOCATION]:
            del group[key]
    save(STORAGE, json.dumps(state, indent=4))
    shutil.rmtree(USER / "profiles" / LOCATION, ignore_errors=True)
    drop_setting(SETTINGS, "window.newWindowProfile", "DarkRedHack")


if __name__ == "__main__":
    {"create": create, "remove": remove}[sys.argv[1]]()

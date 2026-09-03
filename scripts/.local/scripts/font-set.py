#!/usr/bin/env python3

from __future__ import annotations

import os
import re
import shutil
import subprocess
import sys
import time
from pathlib import Path


HOME = Path.home()
FOOT = HOME / ".config/foot/foot.ini"
ALACRITTY = HOME / ".config/alacritty/alacritty.toml"
WAYBAR = HOME / ".config/waybar/style.css"
WALKER = HOME / ".config/walker/themes/mocha/style.css"
KITTY = HOME / ".config/kitty/kitty.conf"
GTK3 = HOME / ".config/gtk-3.0/settings.ini"
GTK4 = HOME / ".config/gtk-4.0/settings.ini"
QT5CT = HOME / ".config/qt5ct/qt5ct.conf"
QT6CT = HOME / ".config/qt6ct/qt6ct.conf"
ZED = HOME / ".config/zed/settings.json"


def die(message: str, code: int = 1) -> None:
    print(message, file=sys.stderr)
    raise SystemExit(code)


for cmd in ("fzf", "fc-list"):
    if shutil.which(cmd) is None:
        die(f"Erro: {cmd} não está instalado.", 127)

TARGETS = [path for path in (FOOT, ALACRITTY, WAYBAR, WALKER, KITTY, GTK3, GTK4, QT5CT, QT6CT, ZED) if path.exists()]

if not TARGETS:
    die("Erro: nenhum arquivo de configuração de fonte foi encontrado.")


def replace_first(text: str, pattern: str, repl: str) -> str:
    return re.sub(pattern, repl, text, count=1, flags=re.M)


def replace_first_fn(text: str, pattern: str, repl) -> str:
    return re.sub(pattern, repl, text, count=1, flags=re.M)


def read_current_font() -> str:
    if FOOT.exists():
        text = FOOT.read_text()
        match = re.search(r"^font=(.*?)(?::size=([0-9.]+))?$", text, re.M)
        if match and match.group(1).strip():
            return match.group(1).strip()
    for gtk_path in (GTK3, GTK4):
        if gtk_path.exists():
            match = re.search(r"^\s*gtk-font-name\s*=\s*(.*?)(?:\s+\d+(?:\.\d+)?)?$", gtk_path.read_text(), re.M)
            if match and match.group(1).strip():
                return match.group(1).strip()
    return "JetBrains Mono Nerd Font"


def font_list() -> list[str]:
    output = subprocess.run(
        ["fc-list", "--format", "%{family}\n"],
        check=True,
        capture_output=True,
        text=True,
    ).stdout

    families: set[str] = set()
    for line in output.splitlines():
        for family in line.split(","):
            family = family.strip()
            if family:
                families.add(family)
    return sorted(families, key=str.casefold)


def choose_font(fonts: list[str], current_font: str) -> str:
    preview = r"""sh -c '
font="$1"
printf "\033[1;36m%s\033[0m\n\n" "$font"
printf "\033[1;33mAa Bb Çç Áá 0123456789\033[0m\n\n"
printf "Português: ação, coração, maçã, pingüim.\n"
printf "ABCDEFGHIJKLMNOPQRSTUVWXYZ\n"
printf "abcdefghijklmnopqrstuvwxyz\n\n"
fc-match -f "%{family} — %{style}\n" "$font" 2>/dev/null | head -n 1
' _ {}"""

    proc = subprocess.run(
        [
            "fzf",
            "--border=rounded",
            "--border-label=  FONT  ",
            "--height=85%",
            "--layout=reverse",
            "--margin=1",
            "--padding=1",
            "--prompt=  Fonte > ",
            "--pointer=▌",
            "--marker=┃",
            "--header=ENTER aplica  •  ESC cancela",
            "--header-first",
            "--info=inline",
            "--preview-window=right,60%,border-left,wrap",
            f"--preview={preview}",
            f"--query={current_font}",
        ],
        input="\n".join(fonts),
        text=True,
        capture_output=True,
    )

    if proc.returncode != 0:
        raise SystemExit(130)

    selected = proc.stdout.strip()
    if not selected:
        raise SystemExit(130)
    return selected


current_font = read_current_font()
if len(sys.argv) > 1 and sys.argv[1].strip():
    selected_font = sys.argv[1].strip()
else:
    selected_font = choose_font(font_list(), current_font)

if FOOT.exists():
    foot_text = FOOT.read_text()
    foot_text = replace_first_fn(foot_text, r"^(font=)[^:]+((?::size=.*)?)$", lambda m: f"{m.group(1)}{selected_font}{m.group(2)}")
    FOOT.write_text(foot_text)

if ALACRITTY.exists():
    alacritty_text = ALACRITTY.read_text()
    alacritty_text = replace_first_fn(
        alacritty_text,
        r'^(\s*normal\s*=\s*\{\s*family\s*=\s*")[^"]+(",\s*style\s*=\s*"Regular"\s*\})',
        lambda m: f'{m.group(1)}{selected_font}{m.group(2)}',
    )
    alacritty_text = replace_first_fn(
        alacritty_text,
        r'^(\s*bold\s*=\s*\{\s*family\s*=\s*")[^"]+(",\s*style\s*=\s*"Bold"\s*\})',
        lambda m: f'{m.group(1)}{selected_font}{m.group(2)}',
    )
    alacritty_text = replace_first_fn(
        alacritty_text,
        r'^(\s*italic\s*=\s*\{\s*family\s*=\s*")[^"]+(",\s*style\s*=\s*"Italic"\s*\})',
        lambda m: f'{m.group(1)}{selected_font}{m.group(2)}',
    )
    ALACRITTY.write_text(alacritty_text)

for path in (WAYBAR, WALKER):
    if not path.exists():
        continue
    text = path.read_text()
    text = replace_first_fn(text, r'^(\s*font-family:\s*")[^"]+(";\s*)$', lambda m: f'{m.group(1)}{selected_font}{m.group(2)}')
    path.write_text(text)

if KITTY.exists():
    kitty_text = KITTY.read_text()
    kitty_text = replace_first_fn(kitty_text, r"^(\s*font_family\s+).*$", lambda m: f'{m.group(1)}{selected_font}')
    KITTY.write_text(kitty_text)

for gtk_path in (GTK3, GTK4):
    if not gtk_path.exists():
        continue
    gtk_text = gtk_path.read_text()
    gtk_text = replace_first_fn(
        gtk_text,
        r"^(\s*gtk-font-name\s*=\s*)(.*?)(?:(?<=\s)(\d+(?:\.\d+)?))?\s*$",
        lambda m: f"{m.group(1)}{selected_font}{(' ' + m.group(3)) if m.group(3) else ''}",
    )
    gtk_path.write_text(gtk_text)

if shutil.which("gsettings"):
    try:
        out = subprocess.run(
            ["gsettings", "get", "org.gnome.desktop.interface", "font-name"],
            capture_output=True,
            text=True,
        ).stdout.strip().strip("'\"")
        m = re.search(r"(\d+(?:\.\d+)?)$", out)
        size = m.group(1) if m else "11"
        subprocess.run(
            ["gsettings", "set", "org.gnome.desktop.interface", "font-name", f"{selected_font} {size}"],
            check=False,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        )
    except Exception:
        pass

for qt_path in (QT5CT, QT6CT):
    if not qt_path.exists():
        continue
    qt_text = qt_path.read_text()
    qt_text = re.sub(
        r'^(\s*(?:general|fixed)\s*=\s*"?)([^",\n]+)(.*)$',
        lambda m: f"{m.group(1)}{selected_font}{m.group(3)}",
        qt_text,
        flags=re.M,
    )
    qt_path.write_text(qt_text)

if ZED.exists():
    zed_text = ZED.read_text()
    zed_text = re.sub(
        r'("(buffer|ui)_font_family"\s*:\s*")[^"]*(")',
        lambda m: f'{m.group(1)}{selected_font}{m.group(3)}',
        zed_text,
    )
    ZED.write_text(zed_text)

if subprocess.run(["pgrep", "-x", "waybar"], capture_output=True).returncode == 0:
    subprocess.run(["pkill", "-x", "waybar"], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    for _ in range(20):
        if subprocess.run(["pgrep", "-x", "waybar"], capture_output=True).returncode != 0:
            break
        time.sleep(0.1)
    subprocess.Popen(["waybar"], start_new_session=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)

print(f"Fonte aplicada: {selected_font}")

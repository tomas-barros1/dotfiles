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


def die(message: str, code: int = 1) -> None:
    print(message, file=sys.stderr)
    raise SystemExit(code)


for cmd in ("fzf", "fc-list"):
    if shutil.which(cmd) is None:
        die(f"Erro: {cmd} não está instalado.", 127)

TARGETS = [path for path in (FOOT, ALACRITTY, WAYBAR, WALKER, KITTY) if path.exists()]

if not TARGETS:
    die("Erro: nenhum arquivo de configuração de fonte foi encontrado.")


def replace_first(text: str, pattern: str, repl: str) -> str:
    return re.sub(pattern, repl, text, count=1, flags=re.M)


def replace_first_fn(text: str, pattern: str, repl) -> str:
    return re.sub(pattern, repl, text, count=1, flags=re.M)


def read_foot_defaults() -> tuple[str, str]:
    text = FOOT.read_text()
    match = re.search(r"^font=(.*?)(?::size=([0-9.]+))?$", text, re.M)
    if not match:
        return "JetBrains Mono Nerd Font", ""
    return match.group(1).strip(), match.group(2) or ""


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


current_font, _ = read_foot_defaults() if FOOT.exists() else ("JetBrains Mono Nerd Font", "")
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

if subprocess.run(["pgrep", "-x", "waybar"], capture_output=True).returncode == 0:
    subprocess.run(["pkill", "-x", "waybar"], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    for _ in range(20):
        if subprocess.run(["pgrep", "-x", "waybar"], capture_output=True).returncode != 0:
            break
        time.sleep(0.1)
    subprocess.Popen(["waybar"], start_new_session=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)

print(f"Fonte aplicada: {selected_font}")

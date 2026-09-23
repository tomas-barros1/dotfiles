#!/usr/bin/env python3

from __future__ import annotations

import json
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
SWAYNC = HOME / ".config/swaync/style.css"
KITTY = HOME / ".config/kitty/kitty.conf"
RIO = HOME / ".config/rio/config.toml"
GHOSTTY = HOME / ".config/ghostty/config.ghostty"
GTK3 = HOME / ".config/gtk-3.0/settings.ini"
GTK4 = HOME / ".config/gtk-4.0/settings.ini"
QT5CT = HOME / ".config/qt5ct/qt5ct.conf"
QT6CT = HOME / ".config/qt6ct/qt6ct.conf"
ZED = HOME / ".config/zed/settings.json"


def die(message: str, code: int = 1) -> None:
    print(message, file=sys.stderr)
    raise SystemExit(code)


def has_kitty_proto() -> bool:
    term = os.environ.get("TERM", "")
    return bool(
        os.environ.get("KITTY_WINDOW_ID")
        or os.environ.get("GHOSTTY_RESOURCES_DIR")
        or term in ("xterm-ghostty", "xterm-kitty")
        or os.environ.get("TERM_PROGRAM") == "WezTerm"
    )


def detect_wm() -> str:
    if os.environ.get("HYPRLAND_INSTANCE_SIGNATURE"):
        return "hyprland"
    if os.environ.get("SWAYSOCK"):
        return "sway"
    if os.environ.get("DISPLAY"):
        return "x11"
    return "none"


def get_terminal_ref(wm: str) -> str:
    """Pega identificador da janela do terminal ATIVA agora."""
    if wm == "hyprland":
        try:
            out = subprocess.run(
                ["hyprctl", "activewindow", "-j"],
                capture_output=True,
                text=True,
                check=True,
                timeout=2,
            ).stdout
            m = re.search(r'"address"\s*:\s*"([^"]+)"', out)
            return m.group(1) if m else ""
        except Exception:
            return ""
    if wm == "sway":
        try:
            out = subprocess.run(
                ["swaymsg", "-t", "get_tree"],
                capture_output=True,
                text=True,
                check=True,
                timeout=2,
            ).stdout
            tree = json.loads(out)

            def find_focused(node):
                if node.get("focused"):
                    return node.get("id")
                for c in node.get("nodes", []) + node.get("floating_nodes", []):
                    r = find_focused(c)
                    if r is not None:
                        return r
                return None

            wid = find_focused(tree)
            return str(wid) if wid is not None else ""
        except Exception:
            return ""
    if wm == "x11":
        try:
            out = subprocess.run(
                ["xdotool", "getactivewindow"],
                capture_output=True,
                text=True,
                check=True,
                timeout=2,
            ).stdout
            return out.strip()
        except Exception:
            return ""
    return ""


for cmd in ("fzf", "fc-list"):
    if shutil.which(cmd) is None:
        die(f"Erro: {cmd} não está instalado.", 127)

TARGETS = [
    path
    for path in (
        FOOT,
        ALACRITTY,
        WAYBAR,
        WALKER,
        SWAYNC,
        KITTY,
        RIO,
        GHOSTTY,
        GTK3,
        GTK4,
        QT5CT,
        QT6CT,
        ZED,
    )
    if path.exists()
]

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
            match = re.search(
                r"^\s*gtk-font-name\s*=\s*(.*?)(?:\s+\d+(?:\.\d+)?)?$",
                gtk_path.read_text(),
                re.M,
            )
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
    inline_ok = has_kitty_proto()
    wm = detect_wm()

    inline_tools_ok = inline_ok and shutil.which("magick") and shutil.which("chafa")
    nsxiv_tools_ok = (
        not inline_ok
        and wm != "none"
        and shutil.which("nsxiv")
        and shutil.which("magick")
    )

    fzf_args = [
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
        f"--query={current_font}",
    ]

    preview_script_path: str | None = None
    nsxiv_img: str | None = None
    nsxiv_pattern: str | None = None

    if inline_tools_ok:
        # ============ INLINE (Kitty / Ghostty / WezTerm) ============
        preview = r"""sh -c '
font="$1"
font_file=$(fc-match -f "%{file}" "$font" 2>/dev/null)
font_info=$(fc-match -f "%{family} — %{style}" "$font" 2>/dev/null)
sample=$(printf "Aa Bb \303\207\303\247 \303\201\303\241 0123456789\nPortugu\303\252s: a\303\247\303\243o, cora\303\247\303\243o, ma\303\247\303\243, ping\303\274im.\nABCDEFGHIJKLMNOPQRSTUVWXYZ\nabcdefghijklmnopqrstuvwxyz\nThe quick brown fox jumps over the lazy dog.")

rendered=0
if [ -n "$font_file" ]; then
    tmp="${TMPDIR:-/tmp}/font-set-inline-$$.png"
    trap "rm -f \"\$tmp\"" EXIT
    if magick -size 1000x560 \
        -background "${FONT_PREVIEW_BG:-#1e1e2e}" \
        -fill "${FONT_PREVIEW_FG:-#cdd6f4}" \
        -font "$font_file" -pointsize "${FONT_PREVIEW_SIZE:-28}" \
        -gravity NorthWest -interline-spacing 10 \
        caption:"$sample" "$tmp" 2>/dev/null; then
        size="${FZF_PREVIEW_COLUMNS:-76}x${FZF_PREVIEW_LINES:-24}"
        chafa --format kitty --colors 256 \
            --size "$size" --view-size "$size" \
            "$tmp" && rendered=1
    fi
fi

if [ "$rendered" -eq 0 ]; then
    printf "\033[1;36m%s\033[0m\n\n" "$font"
    printf "\033[1;33mAa Bb \303\207\303\247 \303\201\303\241 0123456789\033[0m\n\n"
    printf "Portugu\303\252s: a\303\247\303\243o, cora\303\247\303\243o, ma\303\247\303\243, ping\303\274im.\n"
    printf "ABCDEFGHIJKLMNOPQRSTUVWXYZ\n"
    printf "abcdefghijklmnopqrstuvwxyz\n\n"
fi
printf "\033[2m%s\033[0m\n" "$font_info"
' _ {}"""

        fzf_args += [
            "--preview-window=up,52%,border-bottom,wrap",
            f"--preview={preview}",
        ]

    elif nsxiv_tools_ok:
        # ============ NSXIV (foot, Alacritty, etc.) ============
        win_id = get_terminal_ref(wm)
        pid = os.getpid()
        nsxiv_img = f"/tmp/font-set-nsxiv-{pid}.png"
        nsxiv_pattern = f"font-set-nsxiv-{pid}"
        preview_script_path = f"/tmp/font-set-preview-{pid}.sh"

        # Exporta variáveis que o script de preview vai usar
        env = os.environ.copy()
        env["FONT_SET_NSXIV_IMG"] = nsxiv_img
        env["FONT_SET_NSXIV_PATTERN"] = nsxiv_pattern
        env["FONT_SET_WM"] = wm
        env["FONT_SET_WINID"] = win_id

        preview_body = """#!/bin/sh
font="$1"
font_file=$(fc-match -f "%{file}" "$font" 2>/dev/null)
[ -z "$font_file" ] && exit 0

# Mata nsxiv anterior desta sessão
pkill -f "nsxiv.*$FONT_SET_NSXIV_PATTERN" 2>/dev/null

sample=$(printf "Aa Bb \\303\\207\\303\\247 \\303\\201\\303\\241 0123456789\\nPortugu\\303\\252s: a\\303\\247\\303\\243o, cora\\303\\247\\303\\243o, ma\\303\\247\\303\\243, ping\\303\\274im.\\nABCDEFGHIJKLMNOPQRSTUVWXYZ\\nabcdefghijklmnopqrstuvwxyz\\nThe quick brown fox jumps over the lazy dog.")

magick -size 1000x560 \\
    -background "${FONT_PREVIEW_BG:-#1e1e2e}" \\
    -fill "${FONT_PREVIEW_FG:-#cdd6f4}" \\
    -font "$font_file" -pointsize "${FONT_PREVIEW_SIZE:-28}" \\
    -gravity NorthWest -interline-spacing 10 \\
    caption:"$sample" "$FONT_SET_NSXIV_IMG" 2>/dev/null || exit 0

case "$FONT_SET_WM" in
    hyprland)
        # float + noinitialfocus: abre flutuante SEM roubar foco
        hyprctl dispatch exec "[float;noinitialfocus;size 1000 560;move 0 0] nsxiv -b -N fontpreview $FONT_SET_NSXIV_IMG" >/dev/null 2>&1
        ;;
    sway)
        nsxiv -b -N "fontpreview" -g "1000x560+0+0" "$FONT_SET_NSXIV_IMG" >/dev/null 2>&1 &
        # Devolve foco ao terminal
        sleep 0.05
        swaymsg "[con_id=$FONT_SET_WINID] focus" >/dev/null 2>&1
        ;;
    x11)
        nsxiv -b -N "fontpreview" -g "1000x560+0+0" "$FONT_SET_NSXIV_IMG" >/dev/null 2>&1 &
        sleep 0.05
        xdotool windowfocus "$FONT_SET_WINID" 2>/dev/null
        ;;
esac

exit 0
"""

        Path(preview_script_path).write_text(preview_body)
        os.chmod(preview_script_path, 0o755)

        # Dispara o script toda vez que o item focado muda, silenciosamente
        fzf_args.append(f"--bind=focus:execute-silent({preview_script_path} {{}})")

        try:
            proc = subprocess.run(
                fzf_args,
                input="\n".join(fonts),
                text=True,
                capture_output=True,
                env=env,
            )
        finally:
            # Cleanup: mata nsxiv e remove temporários
            subprocess.run(
                ["pkill", "-f", f"nsxiv.*{nsxiv_pattern}"],
                stdout=subprocess.DEVNULL,
                stderr=subprocess.DEVNULL,
            )
            for p in (preview_script_path, nsxiv_img):
                if p:
                    try:
                        os.remove(p)
                    except OSError:
                        pass

        if proc.returncode != 0:
            raise SystemExit(130)
        selected = proc.stdout.strip()
        if not selected:
            raise SystemExit(130)
        return selected

    # ============ SEM PREVIEW (fallback) ============
    proc = subprocess.run(
        fzf_args,
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
    foot_text = replace_first_fn(
        foot_text,
        r"^(font=)[^:]+((?::size=.*)?)$",
        lambda m: f"{m.group(1)}{selected_font}{m.group(2)}",
    )
    FOOT.write_text(foot_text)

if ALACRITTY.exists():
    alacritty_text = ALACRITTY.read_text()
    alacritty_text = replace_first_fn(
        alacritty_text,
        r'^(\s*normal\s*=\s*\{\s*family\s*=\s*")[^"]+(",\s*style\s*=\s*"Regular"\s*\})',
        lambda m: f"{m.group(1)}{selected_font}{m.group(2)}",
    )
    alacritty_text = replace_first_fn(
        alacritty_text,
        r'^(\s*bold\s*=\s*\{\s*family\s*=\s*")[^"]+(",\s*style\s*=\s*"Bold"\s*\})',
        lambda m: f"{m.group(1)}{selected_font}{m.group(2)}",
    )
    alacritty_text = replace_first_fn(
        alacritty_text,
        r'^(\s*italic\s*=\s*\{\s*family\s*=\s*")[^"]+(",\s*style\s*=\s*"Italic"\s*\})',
        lambda m: f"{m.group(1)}{selected_font}{m.group(2)}",
    )
    ALACRITTY.write_text(alacritty_text)

for path in (WAYBAR, WALKER, SWAYNC):
    if not path.exists():
        continue
    text = path.read_text()
    text = replace_first_fn(
        text,
        r'^(\s*font-family:\s*")[^"]+(";\s*)$',
        lambda m: f"{m.group(1)}{selected_font}{m.group(2)}",
    )
    path.write_text(text)

if KITTY.exists():
    kitty_text = KITTY.read_text()
    kitty_text = replace_first_fn(
        kitty_text, r"^(\s*font_family\s+).*$", lambda m: f"{m.group(1)}{selected_font}"
    )
    KITTY.write_text(kitty_text)

if RIO.exists():
    rio_text = RIO.read_text()
    rio_text = re.sub(
        r'^(\s*family\s*=\s*")[^"]+(")$',
        lambda m: f"{m.group(1)}{selected_font}{m.group(2)}",
        rio_text,
        flags=re.M,
    )
    RIO.write_text(rio_text)

if GHOSTTY.exists():
    ghostty_text = GHOSTTY.read_text()
    ghostty_text = replace_first_fn(
        ghostty_text,
        r'^(\s*font-family\s*=\s*"?)[^"\n]+("?\s*)$',
        lambda m: f"{m.group(1)}{selected_font}{m.group(2)}",
    )
    GHOSTTY.write_text(ghostty_text)

for gtk_path in (GTK3, GTK4):
    if not gtk_path.exists():
        continue
    gtk_text = gtk_path.read_text()
    gtk_text = replace_first_fn(
        gtk_text,
        r"^(\s*gtk-font-name\s*=\s*)(.*?)(?:(?<=\s)(\d+(?:\.\d+)?))?\s*$",
        lambda m: (
            f"{m.group(1)}{selected_font}{(' ' + m.group(3)) if m.group(3) else ''}"
        ),
    )
    gtk_path.write_text(gtk_text)

if shutil.which("gsettings"):
    try:
        out = (
            subprocess.run(
                ["gsettings", "get", "org.gnome.desktop.interface", "font-name"],
                capture_output=True,
                text=True,
            )
            .stdout.strip()
            .strip("'\"")
        )
        m = re.search(r"(\d+(?:\.\d+)?)$", out)
        size = m.group(1) if m else "11"
        subprocess.run(
            [
                "gsettings",
                "set",
                "org.gnome.desktop.interface",
                "font-name",
                f"{selected_font} {size}",
            ],
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
        lambda m: f"{m.group(1)}{selected_font}{m.group(3)}",
        zed_text,
    )
    ZED.write_text(zed_text)

if subprocess.run(["pgrep", "-x", "waybar"], capture_output=True).returncode == 0:
    subprocess.run(
        ["pkill", "-x", "waybar"], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL
    )
    for _ in range(20):
        if (
            subprocess.run(["pgrep", "-x", "waybar"], capture_output=True).returncode
            != 0
        ):
            break
        time.sleep(0.1)
    subprocess.Popen(
        ["waybar"],
        start_new_session=True,
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
    )

print(f"Fonte aplicada: {selected_font}")

#!/usr/bin/env python3
"""Vygeneruje index.md — rozcestník všech okruhů pro GitHub Pages.

Prochází složky zkoušek, v každé hledá podsložky tvaru `NN-nazev` s README.md
a název okruhu bere z jeho prvního nadpisu `## N — Název`.
Spouští se automaticky v CI, ručně: python generate_index.py
"""

import os
import re
from urllib.parse import quote

OUTPUT = "index.md"
README = "README.md"

SECTIONS = [
    ("SZZTP", "Teoretické základy", "15 min příprava, 15 min ústní"),
    ("SZZPP", "Povinný základ", "60 min praktická úloha + 20 min obhajoba"),
    ("SZZVP", "Volitelné bloky", "5 h úloha doma + prezentace a diskuse"),
]

QUESTION_DIR = re.compile(r"^(\d+)-(.+)$")
HEADING = re.compile(r"^##\s+(?:(\d+)\s*[—–-]\s*)?(.+?)\s*$")


def read_title(path: str) -> str | None:
    """Vrátí název okruhu z prvního nadpisu `## …` v README."""
    try:
        with open(path, encoding="utf-8") as handle:
            for line in handle:
                match = HEADING.match(line.rstrip())
                if match:
                    return match.group(2)
    except OSError:
        return None
    return None


def url_for(path: str) -> str:
    parts = path.replace(os.sep, "/").split("/")
    return "/".join(quote(part, safe="") for part in parts) + "/"


def collect(section: str) -> list[tuple[int, str, str]]:
    if not os.path.isdir(section):
        return []

    found = []
    for name in os.listdir(section):
        match = QUESTION_DIR.match(name)
        directory = os.path.join(section, name)
        if not match or not os.path.isdir(directory):
            continue
        if not os.path.isfile(os.path.join(directory, README)):
            continue

        number = int(match.group(1))
        title = read_title(os.path.join(directory, README))
        if not title:
            title = match.group(2).replace("-", " ").capitalize()
        found.append((number, title, url_for(directory)))

    return sorted(found)


def build() -> str:
    lines = [
        "---",
        "layout: default",
        "title: Statnice — rozcestník",
        "---",
        "",
        "## Příprava na státní závěrečné zkoušky",
        "",
        "Automaticky generovaný rozcestník. Plán učení a rozbor obtížnosti je v "
        "[PLAN.md](PLAN.md).",
        "",
    ]

    for section, label, format_note in SECTIONS:
        questions = collect(section)
        if not questions:
            continue

        lines.append(f"## {label}")
        lines.append("")
        lines.append(f"*KI/{section} — {format_note}*")
        lines.append("")
        for number, title, url in questions:
            lines.append(f"- [{number:02d} — {title}]({url})")
        lines.append("")

    return "\n".join(lines).rstrip() + "\n"


def main() -> None:
    content = build()
    with open(OUTPUT, "w", encoding="utf-8") as handle:
        handle.write(content)
    print("Zapsáno {} ({} řádků)".format(OUTPUT, content.count("\n")))


if __name__ == "__main__":
    main()

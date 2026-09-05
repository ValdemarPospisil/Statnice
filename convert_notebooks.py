#!/usr/bin/env python3
"""Převede Jupyter notebooky na Markdown, aby šly zobrazit na GitHub Pages.

Jekyll `.ipynb` neumí — zkopíroval by ho jako syrový JSON. Tenhle skript proto
každý notebook spustí (aby byly vidět výstupy), převede na Markdown vedle
originálu a doplní hlavičku s odkazem zpět na okruh.

Notebooky, jejichž název odpovídá SOLUTION_PATTERN, se navíc zabalí do
rozbalovacího `<details>` bloku — řešení má být na jeden klik navíc, ne hned.

Spouští se automaticky v CI, ručně: python convert_notebooks.py
"""

import os
import re
import sys

import nbformat
from nbclient.exceptions import CellExecutionError
from nbconvert import MarkdownExporter
from nbconvert.preprocessors import ExecutePreprocessor

# Notebooky s řešením — jejich obsah se schová do <details> a chyba v nich
# shodí build, protože je to skutečná regrese.
SOLUTION_PATTERN = re.compile(r"reseni", re.IGNORECASE)

# Notebooky se zadáním obsahují ZÁMĚRNĚ chybný kód (to je celý smysl úlohy),
# takže výjimka v nich je očekávaná — traceback se vykreslí do výstupu a jede se dál.
EXPECTED_ERRORS_PATTERN = re.compile(r"zadani", re.IGNORECASE)

# Kde se hledá; ostatní složky (.venv, vendor) se přeskakují
SEARCH_ROOTS = ["SZZTP", "SZZPP", "SZZVP"]
SKIP_DIRS = {".git", ".venv", "venv", "vendor", "_site", ".ipynb_checkpoints"}

TIMEOUT = 120  # s na buňku


def find_notebooks() -> list[str]:
    found = []
    for root in SEARCH_ROOTS:
        for dirpath, dirnames, filenames in os.walk(root):
            dirnames[:] = [d for d in dirnames if d not in SKIP_DIRS]
            found.extend(
                os.path.join(dirpath, name)
                for name in sorted(filenames)
                if name.endswith(".ipynb")
            )
    return sorted(found)


def execute(notebook, path: str) -> bool:
    """Spustí notebook na místě. Vrací True, když je výsledek v pořádku.

    U notebooků se zadáním se výjimka bere jako očekávaná — chybný kód tam je
    schválně a jeho traceback patří do výstupu.
    """
    chyby_ocekavane = bool(EXPECTED_ERRORS_PATTERN.search(os.path.basename(path)))

    runner = ExecutePreprocessor(
        timeout=TIMEOUT,
        kernel_name="python3",
        allow_errors=chyby_ocekavane,   # u zadání se po výjimce pokračuje dál
    )
    try:
        runner.preprocess(notebook, {"metadata": {"path": os.path.dirname(path)}})
    except CellExecutionError as error:
        print(f"  CHYBA při spuštění {path}:\n    {error}", file=sys.stderr)
        return False

    if chyby_ocekavane:
        pocet = sum(
            1
            for cell in notebook.cells
            for out in cell.get("outputs", [])
            if out.get("output_type") == "error"
        )
        print(f"  (očekávaných výjimek: {pocet})")
    return True


def header(path: str) -> str:
    """Hlavička s názvem a odkazem zpět na README okruhu."""
    nazev = os.path.splitext(os.path.basename(path))[0]
    # Kod/00-ukazkova-uloha.ipynb leží o úroveň níž než README okruhu
    hloubka = len(os.path.relpath(path, os.path.dirname(path)).split(os.sep))
    return f"[← zpět na okruh](../)\n\n" if hloubka else ""


def wrap_solution(body: str, path: str) -> str:
    """Řešení schová do rozbalovacího bloku, aby nebylo hned vidět."""
    if not SOLUTION_PATTERN.search(os.path.basename(path)):
        return body

    # První nadpis necháme venku jako titulek, zbytek zabalíme
    radky = body.split("\n")
    konec_nadpisu = 0
    for i, radek in enumerate(radky):
        if radek.startswith("#"):
            konec_nadpisu = i + 1
            break

    nadpis = "\n".join(radky[:konec_nadpisu])
    zbytek = "\n".join(radky[konec_nadpisu:])

    return (
        f"{nadpis}\n\n"
        "<details markdown=\"1\">\n"
        "<summary><strong>Rozbalit řešení</strong> — až po vlastním pokusu!</summary>\n\n"
        f"{zbytek}\n\n"
        "</details>\n"
    )


def convert(path: str, spoustet: bool = True) -> bool:
    print(f"převádím {path}")
    with open(path, encoding="utf-8") as handle:
        notebook = nbformat.read(handle, as_version=4)

    uspech = execute(notebook, path) if spoustet else True

    body, _ = MarkdownExporter().from_notebook_node(notebook)
    body = wrap_solution(body, path)

    cil = os.path.splitext(path)[0] + ".md"
    with open(cil, "w", encoding="utf-8") as handle:
        handle.write(header(path) + body)
    print(f"  -> {cil}")
    return uspech


def main() -> int:
    spoustet = "--no-execute" not in sys.argv

    notebooky = find_notebooks()
    if not notebooky:
        print("žádné notebooky nenalezeny")
        return 0

    vysledky = [convert(path, spoustet) for path in notebooky]

    selhalo = vysledky.count(False)
    print(f"\nhotovo: {len(vysledky)} notebooků, {selhalo} s chybou")
    return 1 if selhalo else 0


if __name__ == "__main__":
    sys.exit(main())

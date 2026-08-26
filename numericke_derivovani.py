#!/usr/bin/env python3
"""Numerické derivování — okruh SZZTP 5.

Dopředná, zpětná a centrální diference; řády chyby O(h) a O(h^2)
a past s příliš malým h (ztráta přesnosti při odčítání blízkých čísel).

Spuštění:   python3 numericke_derivovani.py

Skript nic neinstaluje, běží na čisté standardní knihovně.
"""

import math


# ---------------------------------------------------------- tři diference

def dopredna(f, x, h):
    """[f(x+h) - f(x)] / h — sklon měřený dopředu. Chyba O(h)."""
    return (f(x + h) - f(x)) / h


def zpetna(f, x, h):
    """[f(x) - f(x-h)] / h — sklon měřený dozadu. Chyba O(h)."""
    return (f(x) - f(x - h)) / h


def centralni(f, x, h):
    """[f(x+h) - f(x-h)] / (2h) — průměr obou jednostranných. Chyba O(h^2).

    Že je to opravdu průměr, se ověří sečtením: f(x) se vykrátí.
    A právě proto je přesnější — jednostranné se pletou na opačné strany.
    """
    return (f(x + h) - f(x - h)) / (2 * h)


# ------------------------------------------------------------- UKÁZKY

def nadpis(text):
    print("\n" + "=" * 74)
    print(text)
    print("=" * 74 + "\n")


if __name__ == "__main__":
    # -- 1) příklad z okruhu 5: f(x) = x^2 v bodě 3 --------------------
    nadpis("1) f(x) = x^2 v bodě x = 3, h = 0,1     (příklad z okruhu 5)")

    f = lambda x: x * x
    x, h, presne = 3.0, 0.1, 6.0

    print(f"  f({x - h}) = {f(x - h):.4f}    f({x}) = {f(x):.4f}    f({x + h}) = {f(x + h):.4f}\n")
    print(f"  {'metoda':<14} {'výsledek':>12} {'chyba':>12}")
    print("  " + "-" * 40)
    for nazev, metoda in (("dopředná", dopredna), ("zpětná", zpetna), ("centrální", centralni)):
        v = metoda(f, x, h)
        print(f"  {nazev:<14} {v:>12.6f} {v - presne:>+12.6f}")
    print(f"  {'přesně':<14} {presne:>12.6f}")

    print("\n  Jednostranné se pletou o STEJNĚ a na OPAČNOU stranu (+0,1 a -0,1),")
    print("  takže jejich průměr — což centrální diference je — vyjde přesně.")
    print(f"  Kontrola: ({dopredna(f, x, h)} + {zpetna(f, x, h)}) / 2 = "
          f"{(dopredna(f, x, h) + zpetna(f, x, h)) / 2}")

    # -- 2) řády chyby: O(h) proti O(h^2) ------------------------------
    nadpis("2) Řády chyby — co se stane, když h zmenším desetkrát")

    g, x, presne = math.sin, 1.0, math.cos(1.0)
    print(f"  f(x) = sin(x) v bodě x = 1,  přesně f'(1) = cos(1) = {presne:.15f}\n")
    print(f"  {'h':>10} {'chyba dopředné':>18} {'chyba centrální':>18}")
    print("  " + "-" * 48)
    for h in (1e-1, 1e-2, 1e-3, 1e-4):
        print(f"  {h:>10.0e} {abs(dopredna(g, x, h) - presne):>18.2e} "
              f"{abs(centralni(g, x, h) - presne):>18.2e}")

    print("\n  Dopředná: h desetkrát menší -> chyba desetkrát menší     => O(h)")
    print("  Centrální: h desetkrát menší -> chyba STOKRÁT menší       => O(h^2)")

    # -- 3) past: příliš malé h ----------------------------------------
    nadpis("3) PAST — čím menší h, tím lépe? U počítače NE.")

    print(f"  Pořád sin(x) v bodě 1, teď ale ženu h až k nule:\n")
    print(f"  {'h':>10} {'centrální diference':>24} {'chyba':>12}")
    print("  " + "-" * 50)

    radky = []
    for exp in range(1, 17):
        h = 10.0 ** (-exp)
        radky.append((h, centralni(g, x, h), abs(centralni(g, x, h) - presne)))

    nejlepsi = min(radky, key=lambda r: r[2])
    for h, hodnota, chyba in radky:
        znacka = "   <-- nejlepší" if h == nejlepsi[0] else ""
        print(f"  {h:>10.0e} {hodnota:>24.15f} {chyba:>12.2e}{znacka}")

    print(f"\n  Chyba nejdřív klesá, u h = {nejlepsi[0]:.0e} dosáhne minima "
          f"({nejlepsi[2]:.2e})")
    print("  a od té chvíle zase ROSTE. Nakonec se ustálí na hodnotě, která má")
    print("  jedinou platnou číslici — dál už se počítá jen šum ze zaokrouhlení.\n")
    print("  Celková chyba má dvě složky, které jdou proti sobě:")
    print("    - chyba z useknutí limity KLESÁ s h")
    print("    - chyba ze zaokrouhlení ROSTE, protože odčítám skoro stejná čísla")
    print("  Existuje tedy optimální h — a teorie ho pro centrální diferenci klade")
    print("  zhruba na třetí odmocninu ze strojové přesnosti, tedy kolem 6e-06.")
    print("  To je nejlepší argument, proč se derivace počítá vzorcem všude, kde to jde.")

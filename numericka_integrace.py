#!/usr/bin/env python3
"""Numerická integrace — okruh SZZTP 5.

Obdélníkové, lichoběžníkové a Simpsonovo pravidlo, jejich chyby
a řády O(h), O(h^2), O(h^4).

Spuštění:   python3 numericka_integrace.py

Skript nic neinstaluje, běží na čisté standardní knihovně.
"""

import math


# --------------------------------------------------------- tři pravidla

def obdelnik_levy(f, a, b, n):
    """Každý dílek nahradí obdélníkem s výškou v LEVÉM okraji. Chyba O(h)."""
    h = (b - a) / n
    return h * sum(f(a + i * h) for i in range(n))


def obdelnik_pravy(f, a, b, n):
    """Výška se bere v PRAVÉM okraji. Chyba O(h)."""
    h = (b - a) / n
    return h * sum(f(a + i * h) for i in range(1, n + 1))


def obdelnik_stred(f, a, b, n):
    """Výška se bere ve STŘEDU dílku. Chyba O(h^2) — vlevo podstřelí,
    vpravo o zhruba tolik přestřelí, a chyby se vyruší."""
    h = (b - a) / n
    return h * sum(f(a + (i + 0.5) * h) for i in range(n))


def lichobeznik(f, a, b, n):
    """Sousední body spojí ÚSEČKOU. Chyba O(h^2).

    Dvojka u vnitřních uzlů není magie: každý vnitřní uzel je okrajem
    dvou sousedních lichoběžníků, krajní jen jednoho.
    """
    h = (b - a) / n
    s = (f(a) + f(b)) / 2
    for i in range(1, n):
        s += f(a + i * h)
    return s * h


def simpson(f, a, b, n):
    """Dvojicí dílků proloží PARABOLU. Chyba O(h^4), n musí být sudé.

    Váhy 1 : 4 : 1 vzniknou jako vážený průměr obdélníkového pravidla
    se středem a lichoběžníkového v poměru 2 : 1 — viz ukázka 3.
    """
    if n % 2 != 0:
        raise ValueError("Simpsonovo pravidlo potřebuje sudý počet dílků.")
    h = (b - a) / n
    s = f(a) + f(b)
    for i in range(1, n):
        s += (4 if i % 2 else 2) * f(a + i * h)
    return s * h / 3


PRAVIDLA = (
    ("obdélníkové (levé)", obdelnik_levy),
    ("obdélníkové (střed)", obdelnik_stred),
    ("lichoběžníkové", lichobeznik),
    ("Simpsonovo", simpson),
)


# ------------------------------------------------------------- UKÁZKY

def nadpis(text):
    print("\n" + "=" * 74)
    print(text)
    print("=" * 74 + "\n")


def porovnej(f, a, b, n, presne):
    """Vypíše všechna pravidla pro dané dělení a spočítá chyby."""
    print(f"  {'pravidlo':<22} {'výsledek':>18} {'chyba':>12}")
    print("  " + "-" * 54)
    for nazev, pravidlo in PRAVIDLA:
        v = pravidlo(f, a, b, n)
        print(f"  {nazev:<22} {v:>18.10f} {v - presne:>+12.2e}")
    print(f"  {'PŘESNĚ':<22} {presne:>18.10f}")


def konvergence(f, a, b, presne):
    """Ukáže, jak chyba klesá se zjemňováním — tady jsou vidět řády."""
    print(f"  {'n':>5} {'obdélník levý':>16} {'obdélník střed':>16} "
          f"{'lichoběžník':>14} {'Simpson':>14}")
    print("  " + "-" * 72)
    for n in (2, 4, 8, 16, 32, 64):
        chyby = [abs(pravidlo(f, a, b, n) - presne) for _, pravidlo in PRAVIDLA]
        print(f"  {n:>5} " + " ".join(f"{c:>16.2e}" if i < 2 else f"{c:>14.2e}"
                                      for i, c in enumerate(chyby)))
    print("\n  Zdvojnásobím n (tedy zmenším h na polovinu) a chyba klesne:")
    print("    obdélník levý       2x     => O(h)")
    print("    obdélník se středem 4x     => O(h^2)")
    print("    lichoběžník         4x     => O(h^2)")
    print("    Simpson            16x     => O(h^4)")


if __name__ == "__main__":
    # -- 1) příklad z okruhu 5 -----------------------------------------
    nadpis("1) integrál od 1 do 2 z dx/x = ln 2     (příklad z okruhu 5)")

    f = lambda x: 1 / x
    presne = math.log(2)

    print(f"  Přesná hodnota: ln 2 = {presne:.10f}")
    print(f"  Funkční hodnoty: f(1) = {f(1):.6f}, f(1,5) = {f(1.5):.6f}, f(2) = {f(2):.6f}\n")

    print("  Nejhrubší možné dělení — celý interval jako jeden kus:\n")
    m = obdelnik_stred(f, 1, 2, 1)
    t = lichobeznik(f, 1, 2, 1)
    s = simpson(f, 1, 2, 2)
    for nazev, v in (("obdélníkové (střed)", m), ("lichoběžníkové", t), ("Simpsonovo", s)):
        print(f"  {nazev:<22} {v:>12.6f}   chyba {v - presne:>+10.2e}")
    print(f"  {'PŘESNĚ':<22} {presne:>12.6f}")
    print("\n  Simpson je z týchž tří funkčních hodnot zhruba "
          f"{abs(t - presne) / abs(s - presne):.0f}x přesnější než lichoběžník.")

    # -- 2) konvergence -------------------------------------------------
    nadpis("2) Jak chyba klesá se zjemňováním — tady jsou vidět řády")
    konvergence(f, 1, 2, presne)

    # -- 3) odkud se berou váhy 1 : 4 : 1 -------------------------------
    nadpis("3) Odkud se berou Simpsonovy váhy 1 : 4 : 1")

    print(f"  obdélník se středem   {m:.10f}   chyba {m - presne:+.2e}  (POD)")
    print(f"  lichoběžník           {t:.10f}   chyba {t - presne:+.2e}  (NAD)")
    print(f"\n  Chyby mají opačné znaménko a lichoběžník se plete "
          f"{abs(t - presne) / abs(m - presne):.2f}krát víc.")
    print("  Nabízí se je tedy zprůměrovat v poměru 2 : 1 —")
    print(f"\n    (2*M + T) / 3 = {(2 * m + t) / 3:.10f}")
    print(f"    Simpsonovo    = {s:.10f}")
    print("\n  ...a je to totéž. Rozepsáním té kombinace vypadnou váhy 1, 4, 1.")

    # -- 4) Simpson je přesný pro kubiky --------------------------------
    nadpis("4) Proč je Simpson přesný pro polynomy až do 3. stupně")

    print("  integrál od 0 do 2 z x^3 dx, přesná hodnota 4\n")
    porovnej(lambda x: x**3, 0, 2, 2, 4.0)
    print("\n  Simpson trefil PŘESNĚ, ačkoli prokládá jen parabolu.")
    print("  Důvod: jeho chybový člen obsahuje ČTVRTOU derivaci, a ta je")
    print("  u polynomu do třetího stupně identicky nulová.")

    # -- 5) proč numerika vůbec existuje --------------------------------
    nadpis("5) Funkce BEZ elementární primitivní funkce")

    print("  integrál od 0 do 1 z e^(-x^2) dx — Gaussova křivka.")
    print("  Primitivní funkce v elementárním tvaru NEEXISTUJE, takže")
    print("  Newtonova-Leibnizova formule je tu k ničemu a zbývá jen numerika.\n")

    gauss = lambda x: math.exp(-x * x)
    presne_gauss = math.sqrt(math.pi) / 2 * math.erf(1)   # referenční hodnota
    porovnej(gauss, 0, 1, 8, presne_gauss)
    print(f"\n  Simpson s 8 dílky (9 vyhodnocení funkce) trefil "
          f"{abs(simpson(gauss, 0, 1, 8) - presne_gauss):.1e}.")
    print(f"  Obdélníkové pravidlo by na stejnou přesnost potřebovalo řádově "
          f"statisíce dílků.")
    print("\n  Tohle je celá pointa okruhu 5: vyplatí se spíš zvolit LEPŠÍ pravidlo")
    print("  než počítat víc dílků.")

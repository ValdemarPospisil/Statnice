#!/usr/bin/env python3
"""Numerické řešení nelineárních rovnic — okruh SZZTP 4.

Metoda půlení intervalu (bisekce) a Newtonova metoda (metoda tečen),
včetně toho, kdy Newton selže.

Spuštění:   python3 nelinearni_rovnice.py

Skript nic neinstaluje, běží na čisté standardní knihovně.
"""

import math


# ------------------------------------------------ metoda půlení intervalu

def puleni(f, a, b, eps=1e-10, max_kroku=200, vypis=True):
    """Hledá kořen f na intervalu [a, b]. Předpoklad: f(a) a f(b) mají opačná znaménka.

    Invariant: kořen je pořád uvnitř aktuálního intervalu.
    Konvergence je zaručená, ale lineární — jeden bit přesnosti za krok.
    """
    fa, fb = f(a), f(b)
    if fa * fb > 0:
        raise ValueError(
            f"Bolzanova věta se nedá použít: f({a}) = {fa:.4f} a f({b}) = {fb:.4f} "
            "mají stejné znaménko.")

    if vypis:
        print(f"  Bolzano: f({a}) = {fa:+.6f}, f({b}) = {fb:+.6f} -> znaménka se liší, kořen existuje.\n")
        print(f"  {'krok':>4} {'a':>12} {'b':>12} {'střed s':>12} {'f(s)':>14} {'délka':>10}")
        print("  " + "-" * 68)

    krok = 0
    while (b - a) / 2 > eps and krok < max_kroku:
        krok += 1
        s = (a + b) / 2
        fs = f(s)
        if vypis and krok <= 8:
            print(f"  {krok:>4} {a:>12.6f} {b:>12.6f} {s:>12.6f} {fs:>+14.6e} {b - a:>10.2e}")
        if fs == 0:
            a = b = s
            break
        if fa * fs < 0:
            b, fb = s, fs
        else:
            a, fa = s, fs

    if vypis and krok > 8:
        print(f"  {'...':>4}  (dalších {krok - 8} kroků)")
    return (a + b) / 2, krok


def kroku_puleni(a, b, eps):
    """Teoretický počet kroků: k >= log2((b-a)/eps). Odsud ten logaritmus."""
    return math.ceil(math.log2((b - a) / eps))


# --------------------------------------------------- Newtonova metoda

def newton(f, df, x0, eps=1e-13, max_kroku=50, vypis=True, presny_koren=None):
    """x_{k+1} = x_k - f(x_k)/f'(x_k) — kořen tečny místo kořene funkce.

    Konvergence je kvadratická (počet platných číslic se zdvojnásobí),
    ale není zaručená: metoda může divergovat i cyklovat.
    """
    if vypis:
        hlavicka = f"  {'krok':>4} {'x_k':>18} {'f(x_k)':>14} {'f´(x_k)':>12}"
        if presny_koren is not None:
            hlavicka += f" {'chyba':>12}"
        print(hlavicka)
        print("  " + "-" * (62 if presny_koren is None else 75))

    x = float(x0)
    for krok in range(max_kroku + 1):
        fx, dfx = f(x), df(x)
        if vypis:
            radek = f"  {krok:>4} {x:>18.12f} {fx:>+14.4e} {dfx:>+12.4f}"
            if presny_koren is not None:
                radek += f" {abs(x - presny_koren):>12.2e}"
            print(radek)
        if abs(fx) < 1e-15 or krok == max_kroku:
            break
        if dfx == 0:
            print("  !! f'(x) = 0 — tečna je vodorovná, metoda se zastavila (dělení nulou)")
            break
        novy = x - fx / dfx
        if abs(novy - x) < eps:
            x = novy
            if vypis:
                fx, dfx = f(x), df(x)
                radek = f"  {krok + 1:>4} {x:>18.12f} {fx:>+14.4e} {dfx:>+12.4f}"
                if presny_koren is not None:
                    radek += f" {abs(x - presny_koren):>12.2e}"
                print(radek)
            return x, krok + 1
        x = novy

    return x, krok


# ------------------------------------------------------------- UKÁZKY

def kroky(n):
    """1 krok, 2-4 kroky, 5+ kroků — ať to zní česky."""
    return f"{n} " + ("krok" if n == 1 else "kroky" if n < 5 else "kroků")


def nadpis(text):
    print("\n" + "=" * 74)
    print(text)
    print("=" * 74)


def porovnej(nazev, f, df, a, b, x0, presny=None):
    """Pustí obě metody na tutéž rovnici a porovná počet kroků."""
    nadpis(nazev)

    print("\nMETODA PŮLENÍ INTERVALU\n")
    koren_p, kroku_p = puleni(f, a, b)

    print("\nNEWTONOVA METODA\n")
    koren_n, kroku_n = newton(f, df, x0, presny_koren=presny)

    print("\nSHRNUTÍ")
    if presny is not None:
        print(f"  přesná hodnota          {presny:.15f}")
    print(f"  půlení intervalu        {koren_p:.15f}   ({kroky(kroku_p)})")
    print(f"  Newtonova metoda        {koren_n:.15f}   ({kroky(kroku_n)})")
    for eps in (1e-4, 1e-10):
        print(f"  na přesnost {eps:.0e} potřebuje půlení "
              f"{kroky(kroku_puleni(a, b, eps))}  (k >= log2((b-a)/eps))")


if __name__ == "__main__":
    # -- 1) Wallisova rovnice z okruhu 4 -------------------------------
    porovnej(
        "1) x^3 - 2x - 5 = 0     (příklad z okruhu 4, Wallisova rovnice)",
        f=lambda x: x**3 - 2*x - 5,
        df=lambda x: 3*x**2 - 2,
        a=2, b=3, x0=2,
        presny=2.0945514815423265,
    )

    # -- 2) odmocnina ze dvou -----------------------------------------
    porovnej(
        "2) x^2 - 2 = 0          (hledám odmocninu ze dvou)",
        f=lambda x: x*x - 2,
        df=lambda x: 2*x,
        a=1, b=2, x0=2,
        presny=math.sqrt(2),
    )
    print("\n  Newtonův krok se tu dá zjednodušit: x - (x^2-2)/(2x) = (x + 2/x)/2,")
    print("  což je babylonská metoda na odmocninu, známá tisíce let před Newtonem.")

    # -- 3) Newton najde jen JEDEN kořen, a rozhodne o tom start -------
    nadpis("3) x^4 - 4x^3 - 7x^2 + 22x + 24 = 0     (kořeny -2, -1, 3, 4)")
    p = lambda x: x**4 - 4*x**3 - 7*x**2 + 22*x + 24
    dp = lambda x: 4*x**3 - 12*x**2 - 14*x + 22

    for start in (0, 5, -3):
        print(f"\n  --- start x0 = {start} ---")
        koren, kroku = newton(p, dp, start, vypis=False)
        print(f"  dokonverguje ke kořeni {koren:.6f}   ({kroky(kroku)})")
    print("\n  Stejná rovnice, stejná metoda, RŮZNÉ kořeny — rozhoduje počáteční odhad.")
    print("  Rozklad Hornerem (viz horner.py) proti tomu vrátí všechny čtyři naráz.")

    # -- 4) kdy Newton selže ------------------------------------------
    nadpis("4) Kdy Newtonova metoda selže")

    print("\n  a) skoro vodorovná tečna — start 3,5 leží u lokálního extrému\n")
    newton(p, dp, 3.5, max_kroku=4)
    print("\n     f'(3,5) = -2,5 je blízko nule, takže krok f/f' je obrovský.")
    print("     Metoda odletí na 1,025 (přes dva kořeny), tam narazí na další")
    print("     skoro vodorovnou tečnu a vystřelí až na 56 — a pak se pracně vrací.")

    print("\n  b) cyklení — x^3 - 2x + 2 ze startu 0 skáče pořád mezi 0 a 1\n")
    newton(lambda x: x**3 - 2*x + 2, lambda x: 3*x**2 - 2, 0, max_kroku=5)

    print("\n  c) kořen bez změny znaménka — (x-2)^2 se osy jen DOTKNE\n")
    try:
        puleni(lambda x: (x - 2)**2, 1, 3, vypis=False)
    except ValueError as chyba:
        print(f"     půlení intervalu: {chyba}")
    koren, kroku = newton(lambda x: (x - 2)**2, lambda x: 2*(x - 2), 3,
                          vypis=False, max_kroku=60)
    print(f"     Newtonova metoda: kořen {koren:.8f}   ({kroky(kroku)})")
    print("     -> Newton dojede, ale jen LINEÁRNĚ (chyba se půlí, neumocňuje).")
    print("        U násobného kořene je tedy Newton silnější než půlení.")

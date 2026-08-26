#!/usr/bin/env python3
"""Hornerovo schéma a rozklad polynomu na kořenové činitele — okruh SZZTP 4.

Spuštění:   python3 horner.py

Skript nic neinstaluje, běží na čisté standardní knihovně.
Vlastní polynom si přidáš dole v sekci UKÁZKY: koeficienty se píšou
od nejvyšší mocniny a NULY SE NEVYNECHÁVAJÍ, tedy x^3 - 2x - 5 = [1, 0, -2, -5].
"""

from fractions import Fraction
from math import gcd, isqrt


# ---------------------------------------------------------------- Horner

def horner(koef, c):
    """Jeden průchod Hornerovým schématem.

    Vrací (koeficienty podílu při dělení (x - c), zbytek).
    Zbytek je zároveň hodnota polynomu v bodě c — to je věta o zbytku.
    """
    radek = [koef[0]]
    for a in koef[1:]:
        radek.append(a + c * radek[-1])
    return radek[:-1], radek[-1]


def hodnota(koef, c):
    """P(c) spočítané Hornerem — n násobení a n sčítání, tedy O(n)."""
    return horner(koef, c)[1]


def naivni_pocet_nasobeni(n):
    """Kolik násobení by stálo přímé dosazení s počítáním mocnin od nuly."""
    return n * (n + 1) // 2


# ------------------------------------------------------- výpis schématu

def _cislo(x):
    """Zlomek vypíše jako zlomek, celé číslo jako celé číslo."""
    f = Fraction(x)
    return str(f.numerator) if f.denominator == 1 else f"{f.numerator}/{f.denominator}"


def vypis_schema(koef, c):
    """Vykreslí Hornerovo schéma tak, jak se píše na papír."""
    podil, zbytek = horner(koef, c)
    dolni = podil + [zbytek]
    stredni = [""] + [_cislo(c * b) for b in podil]

    sirka = max(len(_cislo(x)) for x in list(koef) + dolni + [c])
    sirka = max(sirka, max((len(s) for s in stredni), default=0)) + 2
    odsazeni = len(_cislo(c)) + 3

    def radek(bunky, popis=""):
        return popis.rjust(odsazeni) + "".join(str(b).rjust(sirka) for b in bunky)

    print(radek([_cislo(k) for k in koef]))
    print(radek(stredni, f"{_cislo(c)} |"))
    print(" " * odsazeni + "-" * (sirka * len(koef)))
    print(radek([_cislo(x) for x in dolni]))

    if zbytek == 0:
        print(f"\n  zbytek 0  ->  {_cislo(c)} JE kořen, podíl je {polynom_str(podil)}")
    else:
        print(f"\n  zbytek {_cislo(zbytek)}  ->  P({_cislo(c)}) = {_cislo(zbytek)}, kořen to není")
    print()


def polynom_str(koef):
    """Koeficienty -> čitelný zápis polynomu."""
    n = len(koef) - 1
    casti = []
    for i, a in enumerate(koef):
        if a == 0:
            continue
        mocnina = n - i
        znamenko = "-" if a < 0 else ("+" if casti else "")
        velikost = abs(Fraction(a))
        cislo = "" if velikost == 1 and mocnina > 0 else _cislo(velikost)
        promenna = "" if mocnina == 0 else ("x" if mocnina == 1 else f"x^{mocnina}")
        casti.append(f"{znamenko} {cislo}{promenna}".strip())
    return " ".join(casti) if casti else "0"


# --------------------------------------------- hledání racionálních kořenů

def _deliteli(n):
    n = abs(n)
    return [d for d in range(1, n + 1) if n % d == 0]


def kandidati(koef):
    """Věta o racionálních kořenech: kandidát je p/q, kde
    p dělí absolutní člen a q dělí vedoucí koeficient.

    Je-li polynom normovaný (vedoucí koeficient 1), je q = 1
    a kandidáti jsou prostě celí dělitelé absolutního členu.
    """
    zlomky = [Fraction(k) for k in koef]

    # přenásobím společným jmenovatelem, ať pracuji s celými čísly
    m = 1
    for z in zlomky:
        m = m * z.denominator // gcd(m, z.denominator)
    cele = [int(z * m) for z in zlomky]

    vedouci, absolutni = cele[0], cele[-1]
    if absolutni == 0:            # x je společný činitel, nula je kořen
        return [Fraction(0)]

    vysledek = set()
    for p in _deliteli(absolutni):
        for q in _deliteli(vedouci):
            vysledek.add(Fraction(p, q))
            vysledek.add(Fraction(-p, q))
    return sorted(vysledek, key=lambda f: (abs(f), f))


def _kvadraticka(a, b, c):
    """Kořeny ax^2 + bx + c popsané textem (i iracionální a komplexní)."""
    D = b * b - 4 * a * c
    if D > 0:
        odm = isqrt(int(D)) if Fraction(D).denominator == 1 else None
        if odm is not None and odm * odm == D:
            return [Fraction(-b + odm, 2 * a), Fraction(-b - odm, 2 * a)], "racionální"
        h = float(D) ** 0.5
        return [(-float(b) + h) / (2 * float(a)), (-float(b) - h) / (2 * float(a))], "iracionální"
    if D == 0:
        return [Fraction(-b, 2 * a)], "dvojnásobný"
    return [], "komplexní (D < 0, reálné kořeny nejsou)"


def rozloz(koef, ukaz_schemata=True):
    """Opakovaným Hornerem odloupne racionální kořeny, zbytek dořeší vzorcem."""
    zbyva = [Fraction(k) for k in koef]
    koreny = []

    print(f"Polynom:  {polynom_str(zbyva)}")
    n = len(zbyva) - 1
    slovo = "kořen" if n == 1 else ("kořeny" if n < 5 else "kořenů")
    print(f"Stupeň {n}, takže čekám {n} {slovo} (s násobností).\n")

    seznam = kandidati(zbyva)
    print("Kandidáti na racionální kořen (p dělí absolutní člen, q vedoucí koeficient):")
    print("  " + ", ".join(_cislo(k) for k in seznam) + "\n")

    # hádá se jen dokud nezbude kvadratická rovnice
    while len(zbyva) - 1 > 2:
        for c in kandidati(zbyva):
            podil, zbytek = horner(zbyva, c)
            if zbytek == 0:
                if ukaz_schemata:
                    print(f"--- zkouším {_cislo(c)} ---")
                    vypis_schema(zbyva, c)
                koreny.append(c)
                zbyva = podil
                break
        else:
            zbylo = "další " if koreny else "žádný "
            print(f"Racionální kořen {zbylo}není — dál to ručně nejde, nastupuje numerika.\n")
            return koreny, zbyva

    if len(zbyva) - 1 == 2:
        a, b, c = zbyva
        print(f"Zbyla kvadratická rovnice:  {polynom_str(zbyva)} = 0")
        dalsi, druh = _kvadraticka(a, b, c)
        D = b * b - 4 * a * c
        print(f"  diskriminant D = {_cislo(D)}  ->  kořeny {druh}")
        for k in dalsi:
            print(f"  x = {_cislo(k) if isinstance(k, Fraction) else f'{k:.6f}'}")
        koreny.extend(dalsi)
        print()
    elif len(zbyva) - 1 == 1:
        a, b = zbyva
        koreny.append(Fraction(-b, a))

    return koreny, None


def shrn(koef):
    koreny, nedoresene = rozloz(koef)

    print("KOŘENY:", ", ".join(
        _cislo(k) if isinstance(k, Fraction) else f"{k:.6f}" for k in koreny) or "žádné racionální")

    if nedoresene is None and all(isinstance(k, Fraction) for k in koreny):
        vedouci = Fraction(koef[0])
        cinitele = "".join(
            f"(x {'-' if k > 0 else '+'} {_cislo(abs(k))})" for k in koreny)
        predni = "" if vedouci == 1 else f"{_cislo(vedouci)}"
        print(f"ROZKLAD: {predni}{cinitele}")

    print("Na grafu jsou to x-ové souřadnice průsečíků s osou x.")
    n = len(koef) - 1
    print(f"Cena vyhodnocení: Horner {n} násobení, naivní dosazení "
          f"{naivni_pocet_nasobeni(n)}.\n")


# ------------------------------------------------------------- UKÁZKY

def nadpis(text):
    print("\n" + "=" * 70)
    print(text)
    print("=" * 70 + "\n")


if __name__ == "__main__":
    nadpis("1) Vyhodnocení: x^3 - 2x - 5 v bodech 2 a 3  (příklad z okruhu 4)")
    for c in (2, 3):
        vypis_schema([1, 0, -2, -5], c)
    print("Znaménka se liší -> podle Bolzanovy věty leží kořen v intervalu (2, 3).")

    nadpis("2) Rozklad: x^4 - 4x^3 - 7x^2 + 22x + 24  (normovaný polynom)")
    shrn([1, -4, -7, 22, 24])

    nadpis("3) Rozklad: 4x^4 + 8x^3 - 33x^2 - 2x + 8  (NEnormovaný — zlomkové kořeny)")
    shrn([4, 8, -33, -2, 8])

    nadpis("4) Polynom bez racionálního kořene: x^3 - 2x - 5")
    shrn([1, 0, -2, -5])
    print("Proto se na něj v okruhu 4 pouští půlení intervalu a Newtonova metoda —")
    print("viz skript nelinearni_rovnice.py")

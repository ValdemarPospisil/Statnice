## 5 — Architektura počítačů: diagnostika a řešení problémů

- [Zadání okruhu (PDF)](../ZadaniOkruhu/PCA-II.pdf)

### Požadované znalosti a dovednosti

- běžné problémy s hardwarem a jejich příčiny
- diagnostické nástroje a jejich použití
- postupy řešení běžných problémů s hardwarem
- upgrade komponent a kompatibilita
- identifikace a diagnostika závad

### Charakteristika zkušební úlohy

Simulovaná situace se závadou hardwaru. Identifikovat a diagnostikovat závadu, použít diagnostické nástroje, vyřešit problém, případně navrhnout upgrade.

### Postup u zkoušky (60 min přípravy)

1. Postupovat systematicky od nejjednoduššího: napájení → signalizace (pípání, LED) → minimální sestava.
2. Metoda vyloučení: odpojit vše nepodstatné, přidávat po jedné komponentě.
3. Nasadit diagnostický nástroj a interpretovat výstup.
4. Zaznamenávat kroky — zadání to výslovně chce.
5. Navrhnout řešení a případný upgrade s rozpočtem.

### Co si nacvičit

- [ ] Vyřešit ukázkovou úlohu z PDF (počítač se nespouští, černá obrazovka)
- [ ] MemTest86+, CPU-Z, GPU-Z, CrystalDiskInfo (SMART) — co který ukáže
- [ ] Reset BIOSu (CMOS baterie / jumper)
- [ ] Typické projevy: vadná RAM, vadný zdroj, přehřívání, umírající disk
- [ ] POST kódy a zvuková signalizace

### Poznámky

<!-- Sem vlastní výpisky, příkazy, útržky kódu. -->

### Na co se doptají

- Jak odlišíš vadnou grafiku od vadné základní desky?
- Co ti řekne SMART a kdy disk vyměnit, i když ještě funguje?
- Počítač náhodně mrzne — jak postupuješ?
- Kdy má smysl upgradovat a kdy koupit novou sestavu?

### Užitečné odkazy

-

## 6 — Základy elektroniky: analogová část

- [Zadání okruhu (PDF)](../ZadaniOkruhu/ZEL-2okruhy.pdf)

### Požadované znalosti a dovednosti

- řešení obvodů stejnosměrného proudu pomocí 1. a 2. Kirchhoffova zákona
- metoda smyčkových proudů
- metoda uzlových napětí
- metoda lineární superpozice
- Théveninova poučka o náhradním zdroji napětí
- Nortonova poučka o náhradním zdroji proudu
- pojmy napětí, proud, uzel obvodu, větev obvodu, rezistor

### Charakteristika zkušební úlohy

Zadaný obvod se zdroji napětí a rezistory. Spočítat proudy ve **všech větvích** postupně šesti metodami. K řešení soustav lze použít povolený software (Python, R).

### Postup u zkoušky (60 min přípravy)

1. Očíslovat uzly a větve, zvolit a zakreslit orientace proudů — a pak už je neměnit.
2. Kirchhoff: sestavit rovnice pro uzly a smyčky, vyřešit soustavu.
3. Smyčkové proudy: zvolit nezávislé smyčky, sestavit soustavu.
4. Uzlová napětí: zvolit referenční uzel.
5. Superpozice: nechat vždy jeden zdroj, ostatní nahradit zkratem, výsledky sečíst.
6. Thévenin / Norton: odpojit dotyčný rezistor, spočítat U_oc / I_sc a R_i.

### Co si nacvičit

- [ ] Vyřešit ukázkový obvod z PDF všemi šesti metodami — **rukou, na čas**
- [ ] Ověřit si výsledky v Pythonu (numpy.linalg.solve)
- [ ] Vědět, kolik nezávislých rovnic dá který zákon
- [ ] Převod Thévenin ↔ Norton

### Poznámky

<!-- Sem vlastní výpisky, příkazy, útržky kódu. -->

### Na co se doptají

- Kolik nezávislých rovnic dostaneš z 1. a kolik z 2. Kirchhoffova zákona?
- Proč se u superpozice napěťový zdroj nahrazuje zkratem a proudový rozpojením?
- Jak spočítáš vnitřní odpor náhradního zdroje?
- Zkontroluj si výsledek — sedí energetická bilance?

### Užitečné odkazy

-

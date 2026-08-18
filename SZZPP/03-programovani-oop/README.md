## 3 — Programování: základy OOP

- [Zadání okruhu (PDF)](../ZadaniOkruhu/APR-I-II-3okruhy.pdf)

### Požadované znalosti a dovednosti

- vlastní jednoduché třídy (konstruktor, metody)
- speciální metody `__str__` / `__repr__`, `__contains__`, `__eq__`
- property
- iterátor (`__iter__`, `__next__`)
- vyvolávání výjimek
- vstup a výstup na konzoli

### Charakteristika zkušební úlohy

Opravit chybnou definici třídy (chybějící `self`, špatné odsazení, přístup k atributům třídy) a rozšířit ji o validaci v konstruktoru, property, porovnávání instancí a iterátor.

### Postup u zkoušky (60 min přípravy)

1. Zkontrolovat `self` u všech metod a odsazení celé třídy.
2. Odlišit atribut třídy od atributu instance.
3. Validovat vstup v konstruktoru a vyhodit výjimku.
4. Doplnit `__str__` / `__repr__`, `__eq__`, property, iterátor.
5. Sepsat výsledky ladění.

### Co si nacvičit

- [ ] Ukázková úloha z PDF: třída Semaphore, celá včetně rozšíření
- [ ] `__str__` vs. `__repr__` — kdy se který volá
- [ ] `@property` a setter s validací
- [ ] `__eq__` (a proč s ním souvisí `__hash__`)
- [ ] Vlastní iterátor: `__iter__` vracející self + `__next__` se `StopIteration`

### Poznámky

<!-- Sem vlastní výpisky, příkazy, útržky kódu. -->

### Na co se doptají

- Jaký je rozdíl mezi atributem třídy a atributem instance? Ukaž na svém kódu.
- Proč `__str__` a `__repr__` zvlášť?
- Když předefinuji `__eq__`, co se stane při vložení do množiny?
- Jak by vypadalo řešení generátorem místo plného iterátoru?

### Užitečné odkazy

-

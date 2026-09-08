## 4 — Objektově orientované návrhové vzory

- [Zadání okruhu (PDF)](../ZadaniOkruhu/SZZVP-SW.pdf)

### Požadované znalosti a dovednosti

- typový systém staticky typovaných objektových jazyků
- polymorfismus přes sdílené rozhraní a přes dědičnost (specifikátory přístupu)
- vytvářející vzory: Tovární metoda, Tovární objekt, Jedináček, Prototyp
- strukturální vzory: Adaptér, Dekorátor, Most, Muší váha
- vzory chování: Příkaz, Pozorovatel, Memento, Iterátor, Strategie
- diagramy tříd, návrh SW architektury, verzování, testování, validace a verifikace

### Charakteristika zkušební úlohy

Objektově orientovaná konzolová aplikace v C# implementující **tři návrhové vzory**. Odevzdává se funkční aplikace, zdrojový kód v Git repozitáři, uživatelská příručka, dokumentace vzorů a jednotkové testy.

### Postup řešení úlohy

**1. Přečti zadání a vypiš si tři vzory, které chce.** Zadání je jmenuje konkrétně (Prototype, Command, Iterator — nebo Factory Method, Observer, Strategy). **Nesmíš je nahradit jinými.** Ke každému si hned napiš jednu větu: *jaký problém v téhle aplikaci řeší*.

**2. Než napíšeš první třídu, urči doménovou entitu.** Kontakt, student, kurz. Ta je základ — vzory se na ni nabalují. Chyba je začít vzorem a hledat, na co ho napasovat.

**3. Navrhni strukturu projektu.** Oddělení vrstev je samo o sobě hodnoceno:

```
Aplikace/
├── Model/          — doménové entity (Kontakt, Student, Kurz)
├── Patterns/       — implementace vzorů, po jednom souboru
├── Services/       — obchodní logika, úložiště (repository)
├── UI/             — konzolové menu, nic jiného než čtení vstupu a výpis
└── Program.cs      — jen složí aplikaci a spustí menu
Aplikace.Tests/     — xUnit
```

Podstatné: **UI nesmí obsahovat logiku.** Zkoušející se ptá „co se stane, když to předěláš na webovou aplikaci" — správná odpověď je „vyměním vrstvu UI a nic jiného".

**4. Implementuj vzory postupně a každý hned vyzkoušej.** Ne všechny naráz. Pořadí, které se osvědčí: nejdřív model a úložiště → pak vzor, který se týká vytváření (Factory/Prototype) → pak chování (Command/Observer/Strategy) → nakonec Iterator.

**5. Ke každému vzoru napiš XML dokumentační komentář** přímo nad třídu — proč tam je a jakou roli ve vzoru hraje. Tohle je zároveň ta „dokumentace použitých vzorů", kterou zadání chce, a generuje se z ní dokumentace.

**6. Napiš jednotkové testy.** Zadání je vyžaduje explicitně a je to nejčastěji vynechaná položka. Testuj:

- že `Undo` u Commandu skutečně vrátí stav
- že klon u Prototype je **hluboký** (změna klonu nezmění originál) — tohle je nejlepší test v celé úloze
- že Strategy vrací pro tatáž data různé výsledky podle zvolené strategie
- že Observer dostane notifikaci

**7. Nakresli diagram tříd.** PlantUML v repu (textový soubor, verzovatelný) je lepší než obrázek z draw.io. Nemusí být kompletní — stačí ty tři vzory a doménová entita.

**8. Napiš `README.md`**: jak spustit (`dotnet run`), co aplikace umí, kde je který vzor a jak je zapojený.

### Checklist odevzdání

Společné:

- [ ] funkční konzolová aplikace, spustitelná podle README
- [ ] zdrojový kód v **Git repozitáři**, ne ZIP
- [ ] rozumná historie commitů
- [ ] uživatelská příručka — návod na použití aplikace
- [ ] komentáře v kódu

Specifické pro tento okruh (přímo z PDF):

- [ ] **přesně ty tři vzory, které zadání jmenuje** — každý skutečně funkční, ne dekorace
- [ ] **dokumentace použitých vzorů** — u každého popis, jakou roli plní
- [ ] **jednotkové testy** klíčových funkcí (xUnit/NUnit)
- [ ] perzistence — ukládání do souboru a načtení při startu
- [ ] přehledné konzolové rozhraní (menu, ne holé `Console.ReadLine()` bez nápovědy)
- [ ] diagram tříd

Body navíc:

- [ ] rozhraní `IRepository` a dependency injection přes konstruktor — ukazuje SOLID
- [ ] ošetření chybného vstupu (`int.TryParse`, ne `Convert.ToInt32`)

### Pasti a časté chyby

- **Vzor „použitý" jen jménem.** Třída `KontaktFactory` s jedinou metodou `new Kontakt()` není Factory Method. Musí být polymorfní rozhodnutí — jinak se zeptají „a co se stane, když přidám další typ" a odpověď bude trapná.
- **Prototype s mělkou kopií.** `MemberwiseClone()` zkopíruje reference, ne obsah. Když má kontakt `List<string> Telefony`, klon sdílí **stejný seznam** a změna se projeví u obou. Tohle je nejčastější chyba v celé úloze a zkoušející ji zná.
- **Command bez `Undo`.** Command, který jen provede akci, je jen metoda navíc. Smysl vzoru je zaznamenatelnost a vratnost — musí mít `Execute()` **i** `Undo()` a zásobník historie.
- **Observer bez odhlášení.** Chybějící `Unsubscribe` = únik paměti. Klasická doplňující otázka.
- **Iterator přes `foreach` na `List`.** To je vestavěné, ne tvůj vzor. Musíš implementovat `IEnumerable<T>`/`IEnumerator<T>` vlastní (nebo aspoň `yield return` s vlastní logikou průchodu — filtrování, řazení).
- **Chybějící testy.** Zadání je vyjmenovává, bez nich je to neúplné.
- **Perzistence zapomenutá.** „Načítání kontaktů při spuštění" je funkční požadavek, ne bonus.
- **Statický Singleton na všechno.** Když ho použiješ, umět říct, proč je považován za antipattern (skrytá globální závislost, špatná testovatelnost).

### Technické minimum

```bash
dotnet new console -o SpravceKontaktu
cd SpravceKontaktu
dotnet run

# testy
cd ..
dotnet new xunit -o SpravceKontaktu.Tests
dotnet add SpravceKontaktu.Tests reference SpravceKontaktu
dotnet test

# solution, ať to drží pohromadě
dotnet new sln -n SpravceKontaktu
dotnet sln add SpravceKontaktu SpravceKontaktu.Tests
```

JSON perzistence bez instalace čehokoli (je součástí .NET):

```csharp
using System.Text.Json;

var opt = new JsonSerializerOptions { WriteIndented = true };
File.WriteAllText("kontakty.json", JsonSerializer.Serialize(kontakty, opt));
var nactene = JsonSerializer.Deserialize<List<Kontakt>>(File.ReadAllText("kontakty.json"));
```

PlantUML do PNG:

```bash
plantuml diagram.puml          # nebo online: https://www.plantuml.com/plantuml
```

### Řešení ukázkové úlohy I.1 — Správce kontaktů

**Vzory ze zadání:** Prototype (kopírování kontaktů), Command (vratné změny), Iterator (průchod kolekcí).

#### Doménová entita a Prototype

```csharp
/// <summary>Kontaktní záznam. Implementuje Prototype pro rychlé vytváření kopií.</summary>
public class Kontakt : IPrototyp<Kontakt>
{
    public string Jmeno { get; set; } = "";
    public string Email { get; set; } = "";
    public List<string> Telefony { get; set; } = new();

    /// <summary>Vytvoří HLUBOKOU kopii — nový seznam telefonů, ne sdílená reference.</summary>
    public Kontakt Klonuj() => new Kontakt
    {
        Jmeno    = this.Jmeno,
        Email    = this.Email,
        Telefony = new List<string>(this.Telefony)   // <<< tady je celý vtip
    };
}

public interface IPrototyp<T> { T Klonuj(); }
```

**Tohle je místo, kde se úloha láme.** Kdybys napsal `Telefony = this.Telefony`, klon i originál by sdílely týž seznam a přidání čísla u kopie by ho přidalo i originálu. `MemberwiseClone()` dělá přesně tuhle chybu automaticky.

Argument pro obhajobu: *„Prototype tu má smysl proto, že vytvořit kontakt kopií existujícího (kolega ze stejné firmy — stejná adresa, doména e-mailu) je levnější a méně chybové než vyplňovat vše znovu."*

#### Command s Undo

```csharp
public interface IPrikaz
{
    void Proved();
    void Vrat();
    string Popis { get; }
}

/// <summary>Úprava kontaktu. Před provedením si uloží původní stav pro Undo.</summary>
public class UpravKontaktPrikaz : IPrikaz
{
    private readonly Kontakt _cil;
    private readonly Kontakt _nove;
    private Kontakt? _puvodni;          // stav před změnou

    public UpravKontaktPrikaz(Kontakt cil, Kontakt nove) { _cil = cil; _nove = nove; }

    public string Popis => $"Úprava kontaktu {_cil.Jmeno}";

    public void Proved()
    {
        _puvodni = _cil.Klonuj();       // Prototype se tu hodí i pro Command
        _cil.Jmeno = _nove.Jmeno;
        _cil.Email = _nove.Email;
        _cil.Telefony = new List<string>(_nove.Telefony);
    }

    public void Vrat()
    {
        if (_puvodni is null) return;
        _cil.Jmeno = _puvodni.Jmeno;
        _cil.Email = _puvodni.Email;
        _cil.Telefony = new List<string>(_puvodni.Telefony);
    }
}

/// <summary>Invoker — provádí příkazy a drží historii pro vrácení.</summary>
public class SpravcePrikazu
{
    private readonly Stack<IPrikaz> _historie = new();

    public void Spust(IPrikaz p) { p.Proved(); _historie.Push(p); }

    public bool Vrat()
    {
        if (_historie.Count == 0) return false;
        _historie.Pop().Vrat();
        return true;
    }

    public IEnumerable<string> Historie() => _historie.Select(p => p.Popis);
}
```

Všimni si, že **Prototype obsluhuje Command** — klon slouží k uložení stavu před změnou. Tuhle provázanost u obhajoby zmiň, ukazuje, že vzory nejsou nalepené vedle sebe.

#### Iterator

Vlastní iterátor musí dělat něco, co `foreach` nad `List` neumí — jinak je to formalita:

```csharp
/// <summary>Kolekce kontaktů s vlastními iterátory (abecední, filtrovaný).</summary>
public class KontaktKolekce : IEnumerable<Kontakt>
{
    private readonly List<Kontakt> _polozky = new();

    public void Pridej(Kontakt k) => _polozky.Add(k);

    // výchozí iterátor: abecedně podle jména
    public IEnumerator<Kontakt> GetEnumerator()
    {
        foreach (var k in _polozky.OrderBy(k => k.Jmeno))
            yield return k;
    }

    IEnumerator IEnumerable.GetEnumerator() => GetEnumerator();

    /// <summary>Iterátor procházející jen kontakty s doménou e-mailu.</summary>
    public IEnumerable<Kontakt> ProDomenu(string domena)
    {
        foreach (var k in _polozky)
            if (k.Email.EndsWith("@" + domena, StringComparison.OrdinalIgnoreCase))
                yield return k;
    }
}
```

Obhajoba: *„Iterator odděluje způsob průchodu od vnitřní reprezentace. Kdybych `List` vyměnil za strom nebo databázi, `foreach` v UI zůstane beze změny."*

#### Jednotkové testy

```csharp
public class KontaktTesty
{
    [Fact]
    public void Klon_JeHluboky_ZmenaKlonuNeovlivniOriginal()
    {
        var orig = new Kontakt { Jmeno = "Anna", Telefony = { "111" } };
        var klon = orig.Klonuj();

        klon.Telefony.Add("222");

        Assert.Single(orig.Telefony);          // originál má pořád jen jedno číslo
        Assert.Equal(2, klon.Telefony.Count);
    }

    [Fact]
    public void Undo_VratiPuvodniStav()
    {
        var k = new Kontakt { Jmeno = "Anna", Email = "a@x.cz" };
        var spravce = new SpravcePrikazu();

        spravce.Spust(new UpravKontaktPrikaz(k, new Kontakt { Jmeno = "Bára", Email = "b@x.cz" }));
        Assert.Equal("Bára", k.Jmeno);

        spravce.Vrat();
        Assert.Equal("Anna", k.Jmeno);
        Assert.Equal("a@x.cz", k.Email);
    }
}
```

První test je ten, který stojí za to ukázat u obhajoby — přesně dokládá, že chápeš rozdíl mělké a hluboké kopie.

#### Diagram tříd (PlantUML)

```plantuml
@startuml
interface IPrototyp<T> { +Klonuj(): T }
interface IPrikaz      { +Proved(); +Vrat(); +Popis: string }

class Kontakt {
  +Jmeno: string
  +Email: string
  +Telefony: List<string>
  +Klonuj(): Kontakt
}
class UpravKontaktPrikaz { -puvodni: Kontakt }
class SpravcePrikazu     { -historie: Stack<IPrikaz> }
class KontaktKolekce     { +GetEnumerator(); +ProDomenu(domena) }

IPrototyp <|.. Kontakt
IPrikaz   <|.. UpravKontaktPrikaz
SpravcePrikazu o--> IPrikaz : historie
UpravKontaktPrikaz --> Kontakt : upravuje
KontaktKolekce o--> Kontakt
@enduml
```

### Řešení ukázkové úlohy I.2 — Studijní systém (stručně)

**Vzory ze zadání:** Factory Method (typy účtů/kurzů), Observer (informování studentů o změnách), Strategy (metody hodnocení).

Doména: `Uzivatel` (Student, Ucitel, Spravce), `Kurz`, `Znamka`. Rozdíly proti první úloze:

**Factory Method** — polymorfní rozhodnutí, ne `switch` s `new`:

```csharp
public abstract class UcetFactory
{
    public abstract Uzivatel VytvorUcet(string jmeno);      // tovární metoda

    public Uzivatel Registruj(string jmeno)                 // společná logika
    {
        var u = VytvorUcet(jmeno);
        u.Id = Guid.NewGuid();
        u.Vytvoren = DateTime.Now;
        return u;
    }
}

public class StudentFactory : UcetFactory
{ public override Uzivatel VytvorUcet(string j) => new Student { Jmeno = j, Kredity = 0 }; }

public class UcitelFactory : UcetFactory
{ public override Uzivatel VytvorUcet(string j) => new Ucitel { Jmeno = j, Uvazek = 1.0 }; }
```

Odpověď na „proč ne prostě `new`": přidání typu účtu znamená **novou třídu, ne zásah do existujícího kódu** — to je princip otevřenosti/uzavřenosti (O ze SOLID).

**Observer** — kurz je pozorovaný, studenti pozorovatelé. **Nezapomeň na odhlášení:**

```csharp
public interface IPozorovatel { void Aktualizuj(string zprava); }

public class Kurz
{
    private readonly List<IPozorovatel> _pozorovatele = new();

    public void Prihlas(IPozorovatel p)   => _pozorovatele.Add(p);
    public void Odhlas(IPozorovatel p)    => _pozorovatele.Remove(p);   // <<< nezapomeň

    private void Oznam(string z)
    {
        foreach (var p in _pozorovatele.ToList())   // ToList: bezpečné při odhlášení v průběhu
            p.Aktualizuj(z);
    }

    private string _termin = "";
    public string Termin
    {
        get => _termin;
        set { _termin = value; Oznam($"Kurz {Nazev}: nový termín {value}"); }
    }
}
```

**Strategy** — výměna algoritmu hodnocení za běhu:

```csharp
public interface IHodnoceni { double Vypocti(IEnumerable<Znamka> znamky); }

public class AritmetickyPrumer : IHodnoceni
{ public double Vypocti(IEnumerable<Znamka> z) => z.Average(x => x.Hodnota); }

public class VazenyPrumer : IHodnoceni
{
    public double Vypocti(IEnumerable<Znamka> z)
        => z.Sum(x => x.Hodnota * x.Kredity) / z.Sum(x => x.Kredity);
}

public class Student
{
    public IHodnoceni Strategie { get; set; } = new AritmetickyPrumer();   // vyměnitelné za běhu
    public double Prumer() => Strategie.Vypocti(Znamky);
}
```

Test, který to hezky doloží: tytéž známky, dvě strategie, dva různé výsledky.

```csharp
[Fact]
public void Strategie_MeniVysledek()
{
    var znamky = new[] { new Znamka(1, kredity: 2), new Znamka(3, kredity: 6) };
    var s = new Student { Znamky = znamky.ToList() };

    s.Strategie = new AritmetickyPrumer();
    Assert.Equal(2.0, s.Prumer());                  // (1+3)/2

    s.Strategie = new VazenyPrumer();
    Assert.Equal(2.5, s.Prumer(), 2);               // (1*2 + 3*6)/8 = 20/8
}
```

Ta čísla si spočítej v hlavě, ať je umíš u obhajoby vyslovit: aritmetický průměr 2,0, vážený 2,5 — protože horší známka má víc kreditů.

### Mé řešení úlohy

<!-- Zadání přijde 3–10 dní předem, na řešení je 5 hodin. Sem popis postupu, odkaz na repo, diagramy. -->

### Kostra prezentace (7–10 min)

1. Zadání a jaké tři vzory jsem měl použít
2. Architektura aplikace — diagram tříd
3. Vzor 1: jaký problém řeší, jak jsem ho zapojil, ukázka kódu
4. Vzor 2: totéž
5. Vzor 3: totéž
6. Perzistence a načítání dat
7. Jednotkové testy — co testují
8. Co by se dalo udělat lépe

### Na co se doptají (diskuse po prezentaci)

- Co by se stalo, kdybys ten vzor nepoužil? Ukaž alternativu.
- Jaký je rozdíl mezi Tovární metodou a Abstraktní továrnou?
- Jedináček — proč se mu často říká antipattern?
- Rozdíl mezi Adaptérem, Dekorátorem a Mostem?
- Vysvětli SOLID principy na svém kódu.
- Rozhraní vs. abstraktní třída — kdy co?

### Užitečné odkazy

- Refactoring Guru — návrhové vzory (česky): <https://refactoring.guru/cs/design-patterns>
- Dokumentace C#: <https://learn.microsoft.com/cs-cz/dotnet/csharp/>
- xUnit: <https://xunit.net/docs/getting-started/v3/getting-started>
- PlantUML — diagram tříd: <https://plantuml.com/class-diagram>
- Diagrams.net: <https://app.diagrams.net/>

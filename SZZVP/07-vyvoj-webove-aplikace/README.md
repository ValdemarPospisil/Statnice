## 7 — Vývoj webové aplikace

- [Zadání okruhu (PDF)](../ZadaniOkruhu/SZZVP-SW.pdf)

### Požadované znalosti a dovednosti

- XML a jeho specifikace, XSD validace, XML DOM
- HTML DOM, JavaScript
- PHP: ukládání dat, cookies a session, práce s objekty, SimpleXML, práce s databázemi
- analýza požadavků, návrh SW architektury, verzování
- testování, validace a verifikace, API, nasazení a podpora

### Charakteristika zkušební úlohy

Webová aplikace s databází (nebo XML jako úložištěm) řešící podnikový problém. Povinný je jazyk PHP. Součástí bývá autentizace, role, API a zabezpečení proti běžným hrozbám.

### Postup řešení úlohy

Zadání má dvě dost odlišné varianty — **XML jako úložiště** (zápisník úkolů) nebo **relační databáze** (skladový systém). Společné je: **povinný je jazyk PHP**, autentizace a bezpečnost.

**1. Rozlišuj, kterou variantu máš.** Podle toho se liší polovina práce:

| | Varianta XML (IV.1) | Varianta DB (IV.2) |
|---|---|---|
| úložiště | XML soubory + **XSD validace** | MySQL/MariaDB |
| jádro hodnocení | práce s SimpleXML/DOM, validace | schéma DB, **role a oprávnění**, **API** |
| bezpečnost | bezpečné uložení osobních údajů | **SQL injection**, role |

**2. Navrhni datovou vrstvu jako první.** U DB varianty schéma (produkty, objednávky, zásoby, uživatelé — zadání je jmenuje), u XML varianty strukturu dokumentu a k ní **hned XSD**.

**3. Postav kostru projektu s oddělenými vrstvami.** I v PHP se hodnotí návrh:

```
projekt/
├── public/          — jediné, co je vystavené webu (index.php, css, js)
├── src/
│   ├── Model/       — entity (Produkt, Objednavka, Uzivatel)
│   ├── Repository/  — přístup k datům (PDO nebo SimpleXML)
│   ├── Service/     — obchodní logika (Auth, Sklad)
│   └── Api/         — REST endpointy
├── templates/       — šablony, oddělené od logiky
├── data/            — XML soubory, XSD (mimo public!)
└── README.md
```

Že `data/` **není** ve `public/`, je bezpečnostní rozhodnutí — jinak si kdokoli stáhne `uzivatele.xml` s hesly. Připrav si to jako odpověď.

**4. Autentizace hned na začátku**, ne nakonec. `password_hash()` + `session_start()`. Role řeš jako sloupec/atribut a kontroluj je **na serveru**, ne skrýváním tlačítek.

**5. Každý dotaz do databáze přes prepared statements.** Od prvního řádku, ne jako pozdější úklid. Zadání ochranu proti SQL injection vyžaduje výslovně.

**6. Každý výpis uživatelských dat přes `htmlspecialchars()`.** Ochrana proti XSS. Zadání ji nejmenuje, ale u obhajoby se na ni ptají.

**7. Funkce implementuj v pořadí podle zadání** a každou hned vyzkoušej v prohlížeči.

**8. API** (varianta IV.2 ho vyžaduje) — pár REST endpointů vracejících JSON. Nemusí být velké, ale musí být promyšlené: správné HTTP metody a stavové kódy.

**9. Nakonec projdi zadání bod po bodu** a odškrtej. U webové varianty je funkčních požadavků nejvíc ze všech okruhů a nejsnáz se na některý zapomene.

### Checklist odevzdání

Společné:

- [ ] funkční webová aplikace, spustitelná podle README
- [ ] zdrojový kód v **Git repozitáři**, ne ZIP
- [ ] rozumná historie commitů
- [ ] uživatelská příručka — návod na použití
- [ ] komentáře v kódu
- [ ] **PHP** jako jazyk (povinné podle zadání)

Varianta IV.1 — zápisník úkolů s XML:

- [ ] registrace a přihlášení uživatelů, **XML jako databáze**
- [ ] bezpečné zpracování a uložení osobních údajů (hashovaná hesla!)
- [ ] přidávání, editace a mazání úkolů
- [ ] **kategorizace** úkolů (práce, osobní, studium)
- [ ] **filtrování** podle kategorie nebo stavu (nezahájené / zahájené / dokončené)
- [ ] **import úkolu z XML přes formulář**
- [ ] **XSD soubor** pro validaci — a skutečně použitý při importu
- [ ] funkce pro čtení i zápis XML
- [ ] stylované, intuitivní rozhraní (CSS/Bootstrap)

Varianta IV.2 — skladový systém s relační databází:

- [ ] CRUD produktů
- [ ] správa objednávek včetně sledování stavu
- [ ] **sledování zásob a upozornění na nízký stav**
- [ ] **API pro integraci** s externími systémy
- [ ] schéma databáze: produkty, objednávky, zásoby, uživatelé
- [ ] **ochrana proti SQL injection** (prepared statements)
- [ ] **uživatelské role a oprávnění** (správce, skladník)

### Pasti a časté chyby

- **Skládání SQL řetězcem.** `"SELECT * FROM produkty WHERE id = $id"` je přesně to, proti čemu zadání varuje. Vždy `prepare()` + `execute([...])`.
- **Prepared statement s vloženým názvem sloupce.** Parametry nahrazují **hodnoty**, ne identifikátory. `ORDER BY ?` nefunguje — název sloupce musíš ověřit proti bílé listině.
- **Heslo v `md5()` nebo `sha1()`.** Obojí je pro hesla nevhodné. `password_hash($h, PASSWORD_DEFAULT)` a `password_verify()`.
- **Výpis dat bez `htmlspecialchars()`** → XSS. Cokoli od uživatele, co jde na stránku, se musí escapovat.
- **Kontrola role jen v šabloně.** Skrýt tlačítko nestačí — když skladník napíše URL ručně, akce se provede. Kontroluj **na začátku akce**.
- **Data XML uvnitř `public/`** — přímo stažitelná z internetu.
- **XSD vytvořené, ale nepoužité.** Zadání říká, že se má použít **k validaci importovaného souboru**. Samotný soubor v repu nestačí.
- **`session_start()` až po výpisu** — PHP hlásí „headers already sent". Patří na první řádek.
- **Chybějící ověření nahrávaného souboru** u importu (typ, velikost).
- **API bez správných stavových kódů** — vracet 200 s textem „chyba" je špatně.

### Technické minimum

```bash
# vestavěný server, žádný Apache potřeba
php -S localhost:8000 -t public

# MySQL v Dockeru
docker run --name mysql -e MYSQL_ROOT_PASSWORD=heslo -e MYSQL_DATABASE=sklad \
  -p 3306:3306 -d mysql:8
```

Připojení k databázi přes PDO — takhle a nijak jinak:

```php
$pdo = new PDO(
    'mysql:host=localhost;dbname=sklad;charset=utf8mb4',
    'root', 'heslo',
    [
        PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,  // chyby jako výjimky
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
        PDO::ATTR_EMULATE_PREPARES   => false,                   // skutečné prepared statements
    ]
);
```

`EMULATE_PREPARES => false` je důležité: bez něj PHP dotaz jen skládá samo a ochrana je slabší. Dobrá věta pro obhajobu.

### Řešení ukázkové úlohy IV.2 — Skladový systém (relační databáze)

Beru ji jako hlavní, protože pokrývá víc požadovaných znalostí (DB, role, API, bezpečnost).

#### Schéma databáze

```sql
CREATE TABLE uzivatele (
    id            INT AUTO_INCREMENT PRIMARY KEY,
    email         VARCHAR(190) NOT NULL UNIQUE,
    heslo_hash    VARCHAR(255) NOT NULL,          -- hash, NIKDY heslo
    role          ENUM('spravce','skladnik') NOT NULL DEFAULT 'skladnik',
    vytvoren      TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE produkty (
    id            INT AUTO_INCREMENT PRIMARY KEY,
    kod           VARCHAR(50)  NOT NULL UNIQUE,
    nazev         VARCHAR(200) NOT NULL,
    jednotka      VARCHAR(20)  NOT NULL DEFAULT 'ks',
    cena          DECIMAL(10,2) NOT NULL CHECK (cena >= 0),
    min_zasoba    INT NOT NULL DEFAULT 0          -- práh pro upozornění
);

CREATE TABLE zasoby (
    produkt_id    INT PRIMARY KEY,
    mnozstvi      INT NOT NULL DEFAULT 0 CHECK (mnozstvi >= 0),
    aktualizovano TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (produkt_id) REFERENCES produkty(id) ON DELETE CASCADE
);

CREATE TABLE objednavky (
    id            INT AUTO_INCREMENT PRIMARY KEY,
    cislo         VARCHAR(30) NOT NULL UNIQUE,
    uzivatel_id   INT NOT NULL,
    stav          ENUM('nova','vyrizuje_se','vyrizena','stornovana') NOT NULL DEFAULT 'nova',
    vytvorena     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (uzivatel_id) REFERENCES uzivatele(id)
);

CREATE TABLE polozky_objednavky (      -- vazební tabulka M:N s dodatečnými atributy
    objednavka_id INT NOT NULL,
    produkt_id    INT NOT NULL,
    mnozstvi      INT NOT NULL CHECK (mnozstvi > 0),
    cena_kus      DECIMAL(10,2) NOT NULL,        -- cena V DOBĚ objednání
    PRIMARY KEY (objednavka_id, produkt_id),
    FOREIGN KEY (objednavka_id) REFERENCES objednavky(id) ON DELETE CASCADE,
    FOREIGN KEY (produkt_id)    REFERENCES produkty(id)
);
```

Dvě rozhodnutí, na která se ptají:

- **`cena_kus` uložená v položce**, i když je cena i v `produkty`. Není to redundance — je to **historická cena**. Když se ceník změní, staré objednávky musí zůstat, jak byly.
- **`zasoby` jako samostatná tabulka**, ne sloupec v `produkty`. Mění se často a nezávisle na kmenových datech, má vlastní časové razítko.

#### Autentizace a role

```php
/** Registrace uživatele. Heslo se ukládá výhradně jako hash. */
public function registruj(string $email, string $heslo, string $role = 'skladnik'): void
{
    $stmt = $this->pdo->prepare(
        'INSERT INTO uzivatele (email, heslo_hash, role) VALUES (?, ?, ?)'
    );
    $stmt->execute([$email, password_hash($heslo, PASSWORD_DEFAULT), $role]);
}

/** Ověří přihlašovací údaje a uloží uživatele do session. */
public function prihlas(string $email, string $heslo): bool
{
    $stmt = $this->pdo->prepare('SELECT * FROM uzivatele WHERE email = ?');
    $stmt->execute([$email]);
    $u = $stmt->fetch();

    if (!$u || !password_verify($heslo, $u['heslo_hash'])) {
        return false;                        // stejná hláška pro obě chyby — neprozrazuje, že e-mail existuje
    }
    session_regenerate_id(true);             // ochrana proti session fixation
    $_SESSION['uzivatel_id'] = $u['id'];
    $_SESSION['role']        = $u['role'];
    return true;
}

/** Zastaví zpracování, pokud přihlášený uživatel nemá požadovanou roli. */
function vyzadujRoli(string $role): void
{
    if (($_SESSION['role'] ?? null) !== $role) {
        http_response_code(403);
        exit('Nemáte oprávnění k této akci.');
    }
}
```

`password_hash()` si sůl generuje sám a ukládá ji do výsledného řetězce — proto není potřeba zvláštní sloupec. To je typická doplňující otázka („kde máš sůl?").

#### Prepared statements — ukázka, kterou budeš předvádět

```php
/** Vyhledá produkty podle názvu. Vstup jde VÝHRADNĚ přes parametr. */
public function najdi(string $hledany, string $razeni = 'nazev'): array
{
    // název sloupce nelze předat parametrem → bílá listina
    $povolene = ['nazev', 'cena', 'kod'];
    if (!in_array($razeni, $povolene, true)) {
        $razeni = 'nazev';
    }

    $stmt = $this->pdo->prepare(
        "SELECT p.*, z.mnozstvi
           FROM produkty p
           LEFT JOIN zasoby z ON z.produkt_id = p.id
          WHERE p.nazev LIKE :hledany
          ORDER BY p.$razeni"
    );
    $stmt->execute(['hledany' => '%' . $hledany . '%']);
    return $stmt->fetchAll();
}
```

Umět vysvětlit obě věci: **hodnota jde parametrem** (databáze ji nikdy neinterpretuje jako SQL) a **identifikátor přes bílou listinu** (parametrem to nejde). Tohle je nejlepší odpověď na „jak bráníš SQL injection".

#### Objednávka v transakci a hlídání zásob

```php
/** Vytvoří objednávku a odepíše zásoby. Celé atomicky. */
public function vytvorObjednavku(int $uzivatelId, array $polozky): int
{
    $this->pdo->beginTransaction();
    try {
        $stmt = $this->pdo->prepare(
            'INSERT INTO objednavky (cislo, uzivatel_id) VALUES (?, ?)'
        );
        $stmt->execute(['OBJ-' . date('Ymd-His'), $uzivatelId]);
        $objId = (int)$this->pdo->lastInsertId();

        foreach ($polozky as $p) {
            // odepsání zásoby — podmínka v UPDATE brání zápornému stavu
            $upd = $this->pdo->prepare(
                'UPDATE zasoby SET mnozstvi = mnozstvi - ?
                  WHERE produkt_id = ? AND mnozstvi >= ?'
            );
            $upd->execute([$p['mnozstvi'], $p['produkt_id'], $p['mnozstvi']]);

            if ($upd->rowCount() === 0) {
                throw new RuntimeException("Nedostatek zásoby produktu {$p['produkt_id']}.");
            }

            $ins = $this->pdo->prepare(
                'INSERT INTO polozky_objednavky (objednavka_id, produkt_id, mnozstvi, cena_kus)
                 VALUES (?, ?, ?, (SELECT cena FROM produkty WHERE id = ?))'
            );
            $ins->execute([$objId, $p['produkt_id'], $p['mnozstvi'], $p['produkt_id']]);
        }

        $this->pdo->commit();
        return $objId;
    } catch (Throwable $e) {
        $this->pdo->rollBack();         // nic se neuloží — žádná poloviční objednávka
        throw $e;
    }
}
```

Podmínka `AND mnozstvi >= ?` přímo v `UPDATE` je lepší než dotaz + kontrola + zápis — mezi nimi by mohl zboží vybrat někdo jiný (souběh). Skvělá odpověď na otázku o současném přístupu.

Upozornění na nízké zásoby (funkční požadavek 3):

```php
/** Produkty pod minimální zásobou — podklad pro upozornění. */
public function nizkeZasoby(): array
{
    return $this->pdo->query(
        'SELECT p.kod, p.nazev, z.mnozstvi, p.min_zasoba
           FROM produkty p
           JOIN zasoby z ON z.produkt_id = p.id
          WHERE z.mnozstvi <= p.min_zasoba
          ORDER BY z.mnozstvi ASC'
    )->fetchAll();
}
```

#### API pro integraci

```php
// public/api.php
header('Content-Type: application/json; charset=utf-8');

$metoda = $_SERVER['REQUEST_METHOD'];
$cesta  = trim($_GET['cesta'] ?? '', '/');

try {
    match (true) {
        $metoda === 'GET'  && $cesta === 'produkty' =>
            odpoved(200, $repo->vsechny()),

        $metoda === 'GET'  && preg_match('#^produkty/(\d+)$#', $cesta, $m) === 1 =>
            ($p = $repo->podleId((int)$m[1]))
                ? odpoved(200, $p)
                : odpoved(404, ['chyba' => 'Produkt nenalezen']),

        $metoda === 'POST' && $cesta === 'produkty' =>
            odpoved(201, $repo->vytvor(json_decode(file_get_contents('php://input'), true))),

        default => odpoved(405, ['chyba' => 'Nepodporovaná operace']),
    };
} catch (Throwable $e) {
    odpoved(500, ['chyba' => 'Vnitřní chyba serveru']);   // detail NE ven, jen do logu
}

function odpoved(int $kod, mixed $data): void
{
    http_response_code($kod);
    echo json_encode($data, JSON_UNESCAPED_UNICODE);
}
```

Stavové kódy, které musíš umět vyjmenovat: **200** OK, **201** vytvořeno, **400** chybný požadavek, **401** nepřihlášen, **403** nemá oprávnění, **404** nenalezeno, **405** špatná metoda, **500** chyba serveru.

#### Výpis do šablony bez XSS

```php
<?php foreach ($produkty as $p): ?>
  <tr>
    <td><?= htmlspecialchars($p['kod'], ENT_QUOTES, 'UTF-8') ?></td>
    <td><?= htmlspecialchars($p['nazev'], ENT_QUOTES, 'UTF-8') ?></td>
    <td><?= number_format((float)$p['cena'], 2, ',', ' ') ?> Kč</td>
    <td class="<?= $p['mnozstvi'] <= $p['min_zasoba'] ? 'text-danger fw-bold' : '' ?>">
      <?= (int)$p['mnozstvi'] ?>
    </td>
  </tr>
<?php endforeach; ?>
```

### Řešení ukázkové úlohy IV.1 — Zápisník úkolů s XML (stručně)

Rozdíl proti variantě s databází: **úložištěm jsou XML soubory a musí k nim být XSD**, které se **skutečně použije** při importu.

Struktura dat:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<ukoly>
  <ukol id="1">
    <nazev>Dopsat prezentaci</nazev>
    <popis>Slidy na obhajobu SZZ</popis>
    <kategorie>studium</kategorie>
    <stav>zahajene</stav>
    <termin>2026-09-15</termin>
  </ukol>
</ukoly>
```

XSD, které to popisuje — všimni si výčtů, ty dělají validaci užitečnou:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <xs:element name="ukol">
    <xs:complexType>
      <xs:sequence>
        <xs:element name="nazev"     type="xs:string"/>
        <xs:element name="popis"     type="xs:string" minOccurs="0"/>
        <xs:element name="kategorie">
          <xs:simpleType>
            <xs:restriction base="xs:string">
              <xs:enumeration value="prace"/>
              <xs:enumeration value="osobni"/>
              <xs:enumeration value="studium"/>
            </xs:restriction>
          </xs:simpleType>
        </xs:element>
        <xs:element name="stav">
          <xs:simpleType>
            <xs:restriction base="xs:string">
              <xs:enumeration value="nezahajene"/>
              <xs:enumeration value="zahajene"/>
              <xs:enumeration value="dokoncene"/>
            </xs:restriction>
          </xs:simpleType>
        </xs:element>
        <xs:element name="termin" type="xs:date" minOccurs="0"/>
      </xs:sequence>
      <xs:attribute name="id" type="xs:positiveInteger" use="required"/>
    </xs:complexType>
  </xs:element>
</xs:schema>
```

Validace při importu — **tohle je ta hodnocená část**:

```php
/**
 * Ověří nahraný XML soubor proti XSD schématu.
 * @return string[] seznam chyb; prázdné pole = soubor je v pořádku
 */
function validujUkol(string $cestaXml, string $cestaXsd): array
{
    libxml_use_internal_errors(true);        // chyby si vyzvednu sám, nevypisují se
    $doc = new DOMDocument();
    $doc->load($cestaXml);

    if ($doc->schemaValidate($cestaXsd)) {
        return [];
    }
    $chyby = array_map(
        fn(LibXMLError $e) => "Řádek {$e->line}: " . trim($e->message),
        libxml_get_errors()
    );
    libxml_clear_errors();
    return $chyby;
}
```

Čtení a zápis přes SimpleXML:

```php
/** Přidá úkol do XML úložiště. */
function pridejUkol(string $soubor, array $data): void
{
    $xml  = file_exists($soubor)
        ? simplexml_load_file($soubor)
        : new SimpleXMLElement('<ukoly/>');

    $ukol = $xml->addChild('ukol');
    $ukol->addAttribute('id', (string)(count($xml->ukol)));
    foreach (['nazev','popis','kategorie','stav','termin'] as $pole) {
        $ukol->addChild($pole, htmlspecialchars($data[$pole] ?? '', ENT_XML1, 'UTF-8'));
    }
    $xml->asXML($soubor);
}

/** Filtrování podle kategorie a stavu — XPath je na to elegantnější než smyčka. */
function filtruj(SimpleXMLElement $xml, ?string $kategorie, ?string $stav): array
{
    $podminky = [];
    if ($kategorie) { $podminky[] = "kategorie='" . addslashes($kategorie) . "'"; }
    if ($stav)      { $podminky[] = "stav='"      . addslashes($stav)      . "'"; }
    $vyraz = '//ukol' . ($podminky ? '[' . implode(' and ', $podminky) . ']' : '');
    return $xml->xpath($vyraz) ?: [];
}
```

Odpověď na „proč XSD" v jedné větě: *„Zaručuje, že importovaný dokument má správnou strukturu, povinné prvky a hodnoty z povoleného výčtu — aplikace pak nemusí ověřovat každý prvek zvlášť a nespadne na neočekávaném vstupu."*

Bezpečnostní upozornění, které si připrav: XML soubory **musí ležet mimo `public/`**, jinak si kdokoli stáhne `uzivatele.xml`. A hesla i v XML variantě patří jen jako `password_hash()`, ne v čitelné podobě.

### Mé řešení úlohy

<!-- Zadání přijde 3–10 dní předem, na řešení je 5 hodin. Sem popis postupu, odkaz na repo, diagramy. -->

### Kostra prezentace (7–10 min)

1. Zadání a řešený problém
2. Architektura aplikace a použité technologie
3. Datová vrstva: schéma databáze nebo struktura XML + XSD
4. Klíčové funkce a jak jsou implementované
5. Autentizace, role a oprávnění
6. Zabezpečení — SQL injection, XSS, hashování hesel
7. API pro integraci
8. Ukázka běhu

### Na co se doptají (diskuse po prezentaci)

- Jak konkrétně bráníš SQL injection? Ukaž to v kódu.
- Jak ukládáš hesla a proč zrovna tak?
- Rozdíl mezi cookie a session — kde session doopravdy leží?
- Co je XSS a kde ti hrozilo?
- K čemu je XSD a co ti validace zaručí?
- Jak jsi navrhoval API — proč tyhle endpointy?

### Užitečné odkazy

- PHP — dokumentace PDO (prepared statements): <https://www.php.net/manual/en/book.pdo.php>
- PHP — hashování hesel: <https://www.php.net/manual/en/faq.passwords.php>
- PHP — SimpleXML: <https://www.php.net/manual/en/book.simplexml.php>
- W3Schools PHP: <https://www.w3schools.com/php/default.asp>
- W3Schools XML a XSD: <https://www.w3schools.com/xml/>
- OWASP Top 10 (bezpečnostní hrozby): <https://owasp.org/www-project-top-ten/>
- Bootstrap 5: <https://getbootstrap.com/docs/5.3/getting-started/introduction/>

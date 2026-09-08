## 6 — Vývoj mobilní aplikace

- [Zadání okruhu (PDF)](../ZadaniOkruhu/SZZVP-SW.pdf)

### Požadované znalosti a dovednosti

- Java (základy) nebo C#, Android SDK
- aktivity a činnost na pozadí
- přístup k webovým službám, zpracování JSON a XML
- využití senzorů včetně pozičních služeb
- ukládání dat do databáze (SQLite)
- UML

### Charakteristika zkušební úlohy

Jednoduchá aplikace pro Android se dvěma aktivitami a činností na pozadí. Odevzdává se Git projekt, UML diagramy vlastní logiky, dokumentace pro vývojáře i pro uživatele.

### Postup řešení úlohy

Zadání je krátké, ale má **tři tvrdé požadavky**, které tam musí být: **dvě aktivity**, **činnost na pozadí** a jedna z trojice *webová služba / senzory a poloha / databáze*. Ukázková úloha (RSS čtečka) chce webovou službu i databázi zároveň.

**1. Rozhodni technologii.** Zadání připouští Javu i C#:

- **Kotlin + Android Studio** — dnes výchozí volba pro Android, nejvíc materiálů, Room a WorkManager jsou přímočaré. (Zadání jmenuje „Java (základy)", Kotlin je její nástupce na téže platformě — u obhajoby to zmiň.)
- **Java + Android Studio** — doslovně podle zadání, víc boilerplatu
- **C# + .NET MAUI** — jde, ale u obhajoby budeš vysvětlovat víc

**2. Rozvrhni si obrazovky dřív, než začneš.** Dvě aktivity typicky znamenají **seznam → detail**. Nakresli si, co se mezi nimi předává (ID položky, ne celý objekt).

**3. Postav vrstvy v tomhle pořadí** — každou vyzkoušej dřív, než postavíš další:

```
Model (data class)  →  DAO + databáze (Room)  →  Repository  →  ViewModel  →  UI (Activity)
                              ↑
                       síťová vrstva (Retrofit / HttpURLConnection)
```

Repository je ta vrstva, která rozhoduje „vzít z databáze, nebo stáhnout ze sítě" — právě tam žije offline režim.

**4. Síť nikdy na hlavním vlákně.** Android to přímo zakáže (`NetworkOnMainThreadException`). Korutiny (`viewModelScope.launch`) nebo `AsyncTask` (zastaralé, nepoužívej).

**5. Perzistence přes Room**, ne holé SQLite. Room je oficiální ORM nad SQLite, generuje DAO a hlídá SQL při překladu.

**6. Práce na pozadí — použij WorkManager.** Tohle je místo, kde se úloha nejčastěji láme: moderní Android **zabíjí procesy na pozadí** kvůli baterii, takže `Timer` ani `Service` periodickou aktualizaci spolehlivě neudělá. WorkManager přežije restart telefonu a respektuje úsporné režimy. Minimální perioda je **15 minut** — tohle číslo si zapamatuj, ptají se na ně.

**7. Nezapomeň na oprávnění.** `INTERNET` v manifestu stačí deklarovat, ale **poloha a notifikace se musí vyžádat za běhu** (Android 6+ / 13+).

**8. Otestuj otočení displeje.** Aktivita se zničí a znovu vytvoří — pokud data držíš v aktivitě, zmizí. Proto ViewModel.

**9. Dokumentace ve dvou verzích.** Zadání chce **pro vývojáře** (může být generovaná z KDoc/Javadoc) **i pro uživatele** (popis chování). Jsou to dvě samostatné položky.

### Checklist odevzdání

Společné:

- [ ] funkční aplikace (ověřená na emulátoru i po restartu)
- [ ] zdrojový kód v **Git repozitáři**, ne ZIP
- [ ] rozumná historie commitů
- [ ] komentáře v kódu

Specifické pro tento okruh (přímo z PDF):

- [ ] **dvě aktivity** a navigace mezi nimi
- [ ] **činnost na pozadí**
- [ ] webová služba / senzory a poloha / databáze (podle zadání; RSS čtečka chce web + DB)
- [ ] **UML diagramy vlastní logiky programu** — ne diagram Android SDK, ale tvých tříd
- [ ] **dokumentace pro vývojáře** (může být generovaná z anotovaných zdrojáků)
- [ ] **dokumentace pro uživatele** (popis chování programu)
- [ ] uživatelská příručka

U ukázkové úlohy navíc:

- [ ] `RecyclerView` se seznamem
- [ ] detail po kliknutí na položku
- [ ] **offline režim** — zobrazují se uložené zprávy
- [ ] **jen časově relevantní** zprávy (mazání starých)
- [ ] automatická aktualizace v intervalu

### Pasti a časté chyby

- **Síť na hlavním vlákně** → `NetworkOnMainThreadException`, okamžitý pád.
- **Chybějící `<uses-permission android:name="android.permission.INTERNET"/>`** v manifestu — aplikace jde spustit, ale nic nestáhne a chyba je nenápadná.
- **Data držená v aktivitě** — otočení displeje je vymaže. Patří do ViewModelu.
- **Únik kontextu (memory leak)** — statická reference na `Activity` nebo `Context` drží celou aktivitu v paměti. Používej `applicationContext` tam, kde nepotřebuješ UI.
- **`Timer`/`Handler` na periodickou práci** — systém proces uspí a aktualizace přestane chodit. WorkManager.
- **Perioda kratší než 15 minut** u `PeriodicWorkRequest` — Android ji tiše zvedne na 15. Neuvést to je klasický chyták.
- **Předávání celých objektů mezi aktivitami** přes `Intent`. Předávej **ID** a načti z databáze.
- **Zapomenuté mazání starých dat** — zadání chce „jen časově relevantní" zprávy, což znamená úklidový dotaz.
- **Chybějící ošetření offline stavu** — aplikace při vypnuté síti spadne místo toho, aby ukázala uložená data.
- **Jen jedna dokumentace.** Zadání chce vývojářskou i uživatelskou zvlášť.

### Technické minimum

`app/build.gradle.kts` — závislosti, které potřebuješ:

```kotlin
dependencies {
    implementation("androidx.room:room-runtime:2.6.1")
    ksp("androidx.room:room-compiler:2.6.1")
    implementation("androidx.room:room-ktx:2.6.1")
    implementation("androidx.work:work-runtime-ktx:2.9.0")
    implementation("androidx.lifecycle:lifecycle-viewmodel-ktx:2.7.0")
    implementation("androidx.recyclerview:recyclerview:1.3.2")
}
```

`AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
<!-- jen když potřebuješ polohu: -->
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>

<application ...>
    <activity android:name=".SeznamActivity" android:exported="true">
        <intent-filter>
            <action android:name="android.intent.action.MAIN"/>
            <category android:name="android.intent.category.LAUNCHER"/>
        </intent-filter>
    </activity>
    <activity android:name=".DetailActivity"/>
</application>
```

Přechod mezi aktivitami:

```kotlin
val i = Intent(this, DetailActivity::class.java)
i.putExtra("ZPRAVA_ID", zprava.id)      // ID, ne celý objekt
startActivity(i)

// v DetailActivity:
val id = intent.getLongExtra("ZPRAVA_ID", -1L)
```

### Řešení ukázkové úlohy III.1 — Čtečka RSS

**Funkční požadavky z PDF:** načtení RSS kanálu z veřejného zdroje · seznamové zobrazení (nejlépe `RecyclerView`) · detail po zvolení zprávy · **persistentní ukládání** (offline režim, ale jen časově relevantní zprávy) · automatická aktualizace v intervalu.

#### Model a databáze

```kotlin
/**
 * Jedna zpráva z RSS kanálu.
 * @property odkaz slouží zároveň jako primární klíč — v RSS je unikátní,
 *   takže opakované stažení téže zprávy ji přepíše místo duplikace.
 */
@Entity(tableName = "zpravy")
data class Zprava(
    @PrimaryKey val odkaz: String,
    val titulek: String,
    val popis: String,
    val publikovano: Long,      // milisekundy od epochy — kvůli řazení a mazání starých
    val stazeno: Long = System.currentTimeMillis()
)
```

Volba `odkaz` jako primárního klíče je malé, ale dobré rozhodnutí — **řeší duplicity zadarmo** při každé aktualizaci. Připrav si to jako odpověď na „jak zabráníš duplicitám".

```kotlin
@Dao
interface ZpravaDao {
    /** Zprávy seřazené od nejnovější; LiveData → UI se obnoví samo při změně v DB. */
    @Query("SELECT * FROM zpravy ORDER BY publikovano DESC")
    fun vsechny(): LiveData<List<Zprava>>

    @Query("SELECT * FROM zpravy WHERE odkaz = :odkaz")
    suspend fun podleOdkazu(odkaz: String): Zprava?

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun vlozVse(zpravy: List<Zprava>)

    /** Úklid: smaže zprávy starší než zadané datum („časově relevantní" ze zadání). */
    @Query("DELETE FROM zpravy WHERE publikovano < :hranice")
    suspend fun smazStarsiNez(hranice: Long)
}

@Database(entities = [Zprava::class], version = 1)
abstract class AppDatabaze : RoomDatabase() {
    abstract fun zpravaDao(): ZpravaDao
}
```

#### Stažení a parsování RSS (XML)

```kotlin
/** Stáhne RSS kanál a rozparsuje ho na seznam zpráv. Volat pouze mimo hlavní vlákno. */
suspend fun stahni(url: String): List<Zprava> = withContext(Dispatchers.IO) {
    val zpravy = mutableListOf<Zprava>()
    URL(url).openStream().use { stream ->
        val parser = Xml.newPullParser()
        parser.setInput(stream, null)

        var titulek = ""; var odkaz = ""; var popis = ""; var datum = 0L
        var tag = ""
        while (parser.next() != XmlPullParser.END_DOCUMENT) {
            when (parser.eventType) {
                XmlPullParser.START_TAG -> tag = parser.name
                XmlPullParser.TEXT -> when (tag) {
                    "title"       -> titulek = parser.text.trim()
                    "link"        -> odkaz   = parser.text.trim()
                    "description" -> popis   = parser.text.trim()
                    "pubDate"     -> datum   = parsujDatum(parser.text)
                }
                XmlPullParser.END_TAG -> {
                    if (parser.name == "item" && odkaz.isNotEmpty())
                        zpravy += Zprava(odkaz, titulek, popis, datum)
                    tag = ""
                }
            }
        }
    }
    zpravy
}
```

`withContext(Dispatchers.IO)` je ta záruka, že to neběží na hlavním vlákně. U obhajoby to je konkrétní odpověď na „jak jsi to ošetřil".

#### Repository — tady žije offline režim

```kotlin
class ZpravaRepository(private val dao: ZpravaDao) {

    /** Zprávy z databáze. Fungují i offline, protože pocházejí z lokálního úložiště. */
    val zpravy: LiveData<List<Zprava>> = dao.vsechny()

    /**
     * Aktualizuje zprávy ze sítě a smaže ty starší než 7 dní.
     * Při chybě sítě neselže — v UI zůstanou dosud uložené zprávy.
     */
    suspend fun aktualizuj(url: String): Result<Int> = try {
        val nove = stahni(url)
        dao.vlozVse(nove)
        val tyden = System.currentTimeMillis() - 7L * 24 * 60 * 60 * 1000
        dao.smazStarsiNez(tyden)                 // „časově relevantní" ze zadání
        Result.success(nove.size)
    } catch (e: IOException) {
        Result.failure(e)                        // offline: UI ukáže uložená data
    }
}
```

Jádro offline režimu v jedné větě pro obhajobu: *„UI čte vždy z databáze, nikdy přímo ze sítě. Síť databázi jen doplňuje. Když spojení není, aplikace funguje dál, jen s daty z posledního stažení."*

#### Automatická aktualizace na pozadí

```kotlin
/** Periodická aktualizace RSS na pozadí. */
class AktualizacniWorker(ctx: Context, params: WorkerParameters) :
    CoroutineWorker(ctx, params) {

    override suspend fun doWork(): Result {
        val dao  = AppDatabaze.instance(applicationContext).zpravaDao()
        val repo = ZpravaRepository(dao)
        return repo.aktualizuj(RSS_URL).fold(
            onSuccess = { Result.success() },
            onFailure = { Result.retry() }        // zkusí znovu, až bude síť
        )
    }
}

// registrace (v Application nebo při startu aktivity):
val pozadavek = PeriodicWorkRequestBuilder<AktualizacniWorker>(15, TimeUnit.MINUTES)
    .setConstraints(
        Constraints.Builder()
            .setRequiredNetworkType(NetworkType.CONNECTED)   // spustí se, až bude síť
            .build()
    )
    .build()

WorkManager.getInstance(this).enqueueUniquePeriodicWork(
    "rss-aktualizace",
    ExistingPeriodicWorkPolicy.KEEP,      // nezaloží duplicitní úlohu při restartu aktivity
    pozadavek
)
```

Tři věci, které se u tohohle kódu ptají a ty na ně máš odpověď: **proč 15 minut** (systémové minimum), **proč `Constraints`** (šetří baterii, nespouští se bez sítě) a **proč `KEEP`** (opakované spuštění aktivity nenaplánuje úlohu znovu).

#### Aktivita se seznamem

```kotlin
class SeznamActivity : AppCompatActivity() {
    private val vm: ZpravyViewModel by viewModels()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_seznam)

        val adapter = ZpravaAdapter { zprava ->
            startActivity(Intent(this, DetailActivity::class.java)
                .putExtra("ZPRAVA_ODKAZ", zprava.odkaz))
        }
        findViewById<RecyclerView>(R.id.seznam).apply {
            layoutManager = LinearLayoutManager(this@SeznamActivity)
            this.adapter  = adapter
        }

        // LiveData: seznam se překreslí sám, když WorkManager na pozadí přidá zprávy
        vm.zpravy.observe(this) { adapter.submitList(it) }

        findViewById<Button>(R.id.btnNacti).setOnClickListener { vm.aktualizuj() }
    }
}

class ZpravyViewModel(app: Application) : AndroidViewModel(app) {
    private val repo = ZpravaRepository(AppDatabaze.instance(app).zpravaDao())
    val zpravy = repo.zpravy

    /** Spustí aktualizaci v korutině — hlavní vlákno zůstane volné. */
    fun aktualizuj() = viewModelScope.launch { repo.aktualizuj(RSS_URL) }
}
```

`ViewModel` je odpověď na otázku o otočení displeje: aktivita se zničí a vytvoří znovu, **ViewModel přežije** a data zůstanou.

#### UML diagram vlastní logiky

Zadání chce diagram *vlastní logiky programu* — tedy tvoje třídy, ne Android SDK:

```plantuml
@startuml
class SeznamActivity
class DetailActivity
class ZpravyViewModel { +zpravy: LiveData<List<Zprava>>; +aktualizuj() }
class ZpravaRepository { +zpravy; +aktualizuj(url): Result<Int> }
interface ZpravaDao { +vsechny(); +vlozVse(); +smazStarsiNez() }
class Zprava <<entity>> { +odkaz <<PK>>; +titulek; +popis; +publikovano }
class RssParser { +stahni(url): List<Zprava> }
class AktualizacniWorker { +doWork(): Result }

SeznamActivity --> ZpravyViewModel
SeznamActivity ..> DetailActivity : Intent(odkaz)
ZpravyViewModel --> ZpravaRepository
ZpravaRepository --> ZpravaDao
ZpravaRepository --> RssParser
AktualizacniWorker --> ZpravaRepository
ZpravaDao ..> Zprava
@enduml
```

Když k tomu přidáš **sekvenční diagram** pro „uživatel klikne na Načíst → ViewModel → Repository → síť → DB → LiveData → UI", máš u obhajoby nejlepší možný obrázek k vysvětlení asynchronního toku.

### Mé řešení úlohy

<!-- Zadání přijde 3–10 dní předem, na řešení je 5 hodin. Sem popis postupu, odkaz na repo, diagramy. -->

### Kostra prezentace (7–10 min)

1. Zadání a funkční požadavky
2. Struktura aplikace: aktivity, navigace mezi nimi, UML
3. Práce na pozadí — jak je řešena a proč tak
4. Přístup k webové službě a parsování odpovědi
5. Perzistence v SQLite a offline režim
6. Ukázka běhu
7. Dokumentace

### Na co se doptají (diskuse po prezentaci)

- Popiš životní cyklus aktivity — co se stane při otočení displeje?
- Jak předáváš data mezi aktivitami?
- Proč nesmí síťový požadavek běžet na hlavním vlákně?
- Jak funguje periodická aktualizace na pozadí a co jí brání v moderním Androidu?
- Jak řešíš oprávnění za běhu (poloha, síť)?
- Jak zajistíš, že se offline zobrazí jen časově relevantní data?

### Užitečné odkazy

- Průvodce architekturou aplikací pro Android: <https://developer.android.com/topic/architecture>
- Room (perzistence): <https://developer.android.com/training/data-storage/room>
- WorkManager (práce na pozadí): <https://developer.android.com/topic/libraries/architecture/workmanager>
- Životní cyklus aktivity: <https://developer.android.com/guide/components/activities/activity-lifecycle>
- Korutiny v Kotlinu: <https://kotlinlang.org/docs/coroutines-overview.html>
- RSS kanály iDNES (zdroj ze zadání): <https://www.idnes.cz/rss>

using FraktalniStrom.Jadro;

namespace FraktalniStrom.Testy;

/// <summary>
/// Testy generátoru geometrie fraktálního stromu (<see cref="Generator"/>).
/// </summary>
public class GeneratorTesty
{
    private static ParametryStromu VytvorParametry(int iterace = 1) => new()
    {
        Iterace = iterace,
        UhelStupne = 25,
        Koeficient = 0.7,
        DelkaKmene = 120,
    };

    [Fact]
    public void Generuj_SJednouIteraci_VratiPouzeKmen()
    {
        var p = VytvorParametry(iterace: 1);

        var vetve = Generator.Generuj(p, null, null, CancellationToken.None);

        Assert.Single(vetve);
    }

    [Fact]
    public void Generuj_StriIteracemi_VratiSedmVetvi()
    {
        // Počet větví = 2^n - 1 => pro n=3: 1 + 2 + 4 = 7
        var p = VytvorParametry(iterace: 3);

        var vetve = Generator.Generuj(p, null, null, CancellationToken.None);

        Assert.Equal(7, vetve.Count);
    }

    [Fact]
    public void Generuj_Kmen_ZacinaVPocatkuAMiriVzhuru()
    {
        var p = VytvorParametry(iterace: 1);

        var vetve = Generator.Generuj(p, null, null, CancellationToken.None);
        var kmen = vetve[0];

        Assert.Equal(0, kmen.X1, precision: 9);
        Assert.Equal(0, kmen.Y1, precision: 9);
        // Úhel je -PI/2 a v obrazovkových souřadnicích roste Y dolů,
        // proto konec kmene musí mít menší (zápornější) Y než počátek.
        Assert.True(kmen.Y2 < kmen.Y1);
    }

    [Fact]
    public void Generuj_DelkaVetveVUrovni1_JeDelkaKmeneKratKoeficient()
    {
        var p = VytvorParametry(iterace: 2);

        var vetve = Generator.Generuj(p, null, null, CancellationToken.None);
        var vetevUroven1 = vetve.First(v => v.Uroven == 1);

        var delka = Math.Sqrt(
            Math.Pow(vetevUroven1.X2 - vetevUroven1.X1, 2) +
            Math.Pow(vetevUroven1.Y2 - vetevUroven1.Y1, 2));

        Assert.Equal(p.DelkaKmene * p.Koeficient, delka, precision: 9);
    }

    [Fact]
    public void Generuj_NaKonci_ReportujeStoProcent()
    {
        var p = VytvorParametry(iterace: 5);
        var nahlaseneHodnoty = new List<int>();
        var progress = new Progress<int>(nahlaseneHodnoty.Add);

        Generator.Generuj(p, progress, null, CancellationToken.None);

        // Progress<T> reportuje asynchronně přes SynchronizationContext, proto
        // v testu bez UI kontextu je vyvolání synchronní, ale pro jistotu
        // dáme běhu šanci se dokončit.
        Assert.Contains(100, nahlaseneHodnoty);
    }

    [Fact]
    public void Generuj_SeZrusenymTokenem_VyhodiOperationCanceledException()
    {
        var p = VytvorParametry(iterace: 5);
        using var cts = new CancellationTokenSource();
        cts.Cancel();

        Assert.Throws<OperationCanceledException>(() =>
            Generator.Generuj(p, null, null, cts.Token));
    }

    [Fact]
    public void Generuj_SPozastavenimAZrusenim_SkonciOperationCanceledExceptionANezablokujeSeNavzdy()
    {
        var p = VytvorParametry(iterace: 10);
        using var pauza = new ManualResetEventSlim(false); // hned na začátku se zablokuje
        using var cts = new CancellationTokenSource(TimeSpan.FromMilliseconds(200));

        var vyjimka = Record.Exception(() =>
            Generator.Generuj(p, null, pauza, cts.Token));

        Assert.IsType<OperationCanceledException>(vyjimka);
    }
}

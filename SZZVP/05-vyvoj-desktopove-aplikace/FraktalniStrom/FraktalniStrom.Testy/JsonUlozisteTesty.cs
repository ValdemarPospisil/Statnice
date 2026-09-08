using FraktalniStrom.Jadro;

namespace FraktalniStrom.Testy;

/// <summary>
/// Testy perzistence stromu do a z JSON souboru (<see cref="JsonUloziste"/>).
/// </summary>
public class JsonUlozisteTesty
{
    [Fact]
    public void UlozANacti_RoundTrip_ZachovaParametryIPocetVetvi()
    {
        var p = new ParametryStromu
        {
            Iterace = 4,
            UhelStupne = 30,
            Koeficient = 0.6,
            DelkaKmene = 100,
            BarvaHex = "#2E7D32",
        };
        var vetve = Generator.Generuj(p, null, null, CancellationToken.None);
        var cesta = Path.GetTempFileName();

        try
        {
            JsonUloziste.Uloz(cesta, p, vetve);
            var nactena = JsonUloziste.Nacti(cesta);

            Assert.Equal(p.Iterace, nactena.Parametry.Iterace);
            Assert.Equal(p.UhelStupne, nactena.Parametry.UhelStupne);
            Assert.Equal(p.Koeficient, nactena.Parametry.Koeficient);
            Assert.Equal(p.DelkaKmene, nactena.Parametry.DelkaKmene);
            Assert.Equal(p.BarvaHex, nactena.Parametry.BarvaHex);
            Assert.Equal(vetve.Count, nactena.Vetve.Count);
            Assert.Equal(vetve[0], nactena.Vetve[0]);
        }
        finally
        {
            File.Delete(cesta);
        }
    }

    [Fact]
    public async Task UlozAsyncANactiAsync_RoundTrip_ZachovaData()
    {
        var p = new ParametryStromu { Iterace = 2 };
        var vetve = Generator.Generuj(p, null, null, CancellationToken.None);
        var cesta = Path.GetTempFileName();

        try
        {
            await JsonUloziste.UlozAsync(cesta, p, vetve);
            var nactena = await JsonUloziste.NactiAsync(cesta);

            Assert.Equal(vetve.Count, nactena.Vetve.Count);
        }
        finally
        {
            File.Delete(cesta);
        }
    }

    [Fact]
    public void Nacti_NaNeexistujiciCestu_VyhodiFileNotFoundException()
    {
        var neexistujiciCesta = Path.Combine(Path.GetTempPath(), $"neexistuje-{Guid.NewGuid()}.json");

        Assert.Throws<FileNotFoundException>(() => JsonUloziste.Nacti(neexistujiciCesta));
    }

    [Fact]
    public void Nacti_SPoskozenymJson_VyhodiInvalidDataException()
    {
        var cesta = Path.GetTempFileName();
        File.WriteAllText(cesta, "{ toto neni platny json ");

        try
        {
            Assert.Throws<InvalidDataException>(() => JsonUloziste.Nacti(cesta));
        }
        finally
        {
            File.Delete(cesta);
        }
    }
}

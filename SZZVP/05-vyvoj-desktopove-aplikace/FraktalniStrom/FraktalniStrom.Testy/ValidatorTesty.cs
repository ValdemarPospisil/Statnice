using FraktalniStrom.Jadro;

namespace FraktalniStrom.Testy;

/// <summary>
/// Testy validace parametrů stromu a bezpečného parsování vstupů
/// (<see cref="Validator"/>).
/// </summary>
public class ValidatorTesty
{
    private static ParametryStromu PlatneParametry() => new()
    {
        Iterace = 10,
        UhelStupne = 25,
        Koeficient = 0.7,
        DelkaKmene = 120,
        BarvaHex = "#2E7D32",
    };

    [Fact]
    public void Zkontroluj_SPlatnymiParametry_VratiTrueABezChyby()
    {
        var vysledek = Validator.Zkontroluj(PlatneParametry(), out var chyba);

        Assert.True(vysledek);
        Assert.Equal(string.Empty, chyba);
    }

    [Fact]
    public void Zkontroluj_SNulovymPoctemIteraci_VratiFalseASHlaskou()
    {
        var p = PlatneParametry();
        p.Iterace = 0;

        var vysledek = Validator.Zkontroluj(p, out var chyba);

        Assert.False(vysledek);
        Assert.False(string.IsNullOrWhiteSpace(chyba));
    }

    [Fact]
    public void Zkontroluj_SKoeficientemNad1_VratiFalseASHlaskou()
    {
        var p = PlatneParametry();
        p.Koeficient = 1.5;

        var vysledek = Validator.Zkontroluj(p, out var chyba);

        Assert.False(vysledek);
        Assert.False(string.IsNullOrWhiteSpace(chyba));
    }

    [Fact]
    public void Zkontroluj_SUhlem200Stupnu_VratiFalseASHlaskou()
    {
        var p = PlatneParametry();
        p.UhelStupne = 200;

        var vysledek = Validator.Zkontroluj(p, out var chyba);

        Assert.False(vysledek);
        Assert.False(string.IsNullOrWhiteSpace(chyba));
    }

    [Fact]
    public void Zkontroluj_SNeplatnouBarvou_VratiFalseASHlaskou()
    {
        var p = PlatneParametry();
        p.BarvaHex = "xyz";

        var vysledek = Validator.Zkontroluj(p, out var chyba);

        Assert.False(vysledek);
        Assert.False(string.IsNullOrWhiteSpace(chyba));
    }

    [Theory]
    [InlineData(19)]
    [InlineData(-1)]
    public void Zkontroluj_SIteracemiMimoRozsah_VratiFalse(int iterace)
    {
        var p = PlatneParametry();
        p.Iterace = iterace;

        var vysledek = Validator.Zkontroluj(p, out var chyba);

        Assert.False(vysledek);
        Assert.False(string.IsNullOrWhiteSpace(chyba));
    }

    [Theory]
    [InlineData("abc")]
    [InlineData("")]
    [InlineData(null)]
    public void ZkusParsovatDouble_SNeplatnymVstupem_VratiFalseANeshodiSe(string? vstup)
    {
        var vysledek = Validator.ZkusParsovat(vstup, out double hodnota);

        Assert.False(vysledek);
        Assert.Equal(0, hodnota);
    }

    [Theory]
    [InlineData("abc")]
    [InlineData("")]
    [InlineData(null)]
    public void ZkusParsovatInt_SNeplatnymVstupem_VratiFalseANeshodiSe(string? vstup)
    {
        var vysledek = Validator.ZkusParsovat(vstup, out int hodnota);

        Assert.False(vysledek);
        Assert.Equal(0, hodnota);
    }

    [Fact]
    public void ZkusParsovatDouble_SPlatnymVstupem_VratiTrueASpravnouHodnotu()
    {
        var vysledek = Validator.ZkusParsovat("25.5", out double hodnota);

        Assert.True(vysledek);
        Assert.Equal(25.5, hodnota, precision: 9);
    }

    [Fact]
    public void ZkusParsovatInt_SPlatnymVstupem_VratiTrueASpravnouHodnotu()
    {
        var vysledek = Validator.ZkusParsovat("10", out int hodnota);

        Assert.True(vysledek);
        Assert.Equal(10, hodnota);
    }
}

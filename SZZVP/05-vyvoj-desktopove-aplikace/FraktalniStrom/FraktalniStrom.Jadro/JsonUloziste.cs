using System.Text.Json;

namespace FraktalniStrom.Jadro;

/// <summary>
/// Zajišťuje ukládání a načítání vygenerovaného fraktálního stromu (jeho
/// parametrů a větví) do a z JSON souboru na disku. Obsahuje synchronní i
/// asynchronní varianty operací, aby I/O nemuselo blokovat vlákno uživatelského
/// rozhraní.
/// </summary>
public static class JsonUloziste
{
    /// <summary>
    /// Nastavení serializace používané pro ukládání — výstupní JSON je odsazený
    /// (čitelný pro člověka).
    /// </summary>
    private static readonly JsonSerializerOptions Nastaveni = new() { WriteIndented = true };

    /// <summary>
    /// Synchronně uloží parametry a větve stromu do JSON souboru na zadané cestě.
    /// </summary>
    /// <param name="cesta">Cesta k cílovému souboru.</param>
    /// <param name="p">Parametry stromu.</param>
    /// <param name="vetve">Seznam větví stromu.</param>
    public static void Uloz(string cesta, ParametryStromu p, List<Vetev> vetve)
    {
        var data = new StromData { Parametry = p, Vetve = vetve };
        var json = JsonSerializer.Serialize(data, Nastaveni);
        File.WriteAllText(cesta, json);
    }

    /// <summary>
    /// Asynchronně uloží parametry a větve stromu do JSON souboru na zadané cestě.
    /// </summary>
    /// <param name="cesta">Cesta k cílovému souboru.</param>
    /// <param name="p">Parametry stromu.</param>
    /// <param name="vetve">Seznam větví stromu.</param>
    /// <returns>Úloha reprezentující probíhající asynchronní zápis.</returns>
    public static async Task UlozAsync(string cesta, ParametryStromu p, List<Vetev> vetve)
    {
        var data = new StromData { Parametry = p, Vetve = vetve };
        var json = JsonSerializer.Serialize(data, Nastaveni);
        await File.WriteAllTextAsync(cesta, json).ConfigureAwait(false);
    }

    /// <summary>
    /// Synchronně načte uložený strom ze zadaného JSON souboru.
    /// </summary>
    /// <param name="cesta">Cesta ke zdrojovému souboru.</param>
    /// <returns>Načtená data stromu.</returns>
    /// <exception cref="FileNotFoundException">Pokud soubor na zadané cestě neexistuje.</exception>
    /// <exception cref="InvalidDataException">Pokud obsah souboru není platný JSON popisující strom.</exception>
    public static StromData Nacti(string cesta)
    {
        if (!File.Exists(cesta))
        {
            throw new FileNotFoundException($"Soubor '{cesta}' nebyl nalezen.", cesta);
        }

        var json = File.ReadAllText(cesta);
        return Deserializuj(json, cesta);
    }

    /// <summary>
    /// Asynchronně načte uložený strom ze zadaného JSON souboru.
    /// </summary>
    /// <param name="cesta">Cesta ke zdrojovému souboru.</param>
    /// <returns>Úloha vracející načtená data stromu.</returns>
    /// <exception cref="FileNotFoundException">Pokud soubor na zadané cestě neexistuje.</exception>
    /// <exception cref="InvalidDataException">Pokud obsah souboru není platný JSON popisující strom.</exception>
    public static async Task<StromData> NactiAsync(string cesta)
    {
        if (!File.Exists(cesta))
        {
            throw new FileNotFoundException($"Soubor '{cesta}' nebyl nalezen.", cesta);
        }

        var json = await File.ReadAllTextAsync(cesta).ConfigureAwait(false);
        return Deserializuj(json, cesta);
    }

    /// <summary>
    /// Deserializuje textový obsah JSON souboru na <see cref="StromData"/> a
    /// obalí případnou chybu formátu srozumitelnou výjimkou.
    /// </summary>
    /// <param name="json">Textový obsah souboru.</param>
    /// <param name="cesta">Cesta k souboru (pro chybovou hlášku).</param>
    /// <returns>Načtená data stromu.</returns>
    /// <exception cref="InvalidDataException">Pokud obsah není platný JSON popisující strom.</exception>
    private static StromData Deserializuj(string json, string cesta)
    {
        try
        {
            var data = JsonSerializer.Deserialize<StromData>(json);
            return data ?? throw new InvalidDataException($"Soubor '{cesta}' neobsahuje platná data stromu.");
        }
        catch (JsonException ex)
        {
            throw new InvalidDataException($"Soubor '{cesta}' obsahuje neplatný JSON a nelze jej načíst.", ex);
        }
    }
}

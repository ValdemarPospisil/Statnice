namespace FraktalniStrom.Jadro;

/// <summary>
/// Vstupní parametry pro generování fraktálního stromu. Instance této třídy
/// popisuje jak geometrii (počet iterací, úhel větvení, koeficient zmenšování,
/// délku kmene), tak vzhled (barvu větví) generovaného stromu.
/// </summary>
public class ParametryStromu
{
    /// <summary>
    /// Počet iterací (úrovní větvení) stromu. Výchozí hodnota je 10.
    /// Rozumný horní limit je 18 (viz <see cref="Validator"/>), protože počet
    /// větví roste exponenciálně jako 2^Iterace - 1.
    /// </summary>
    public int Iterace { get; set; } = 10;

    /// <summary>
    /// Úhel odklonu potomků od směru rodičovské větve ve stupních.
    /// Výchozí hodnota je 25°.
    /// </summary>
    public double UhelStupne { get; set; } = 25;

    /// <summary>
    /// Koeficient (scaling factor) zmenšování délky větve v každé další úrovni,
    /// hodnota z otevřeného intervalu (0, 1). Výchozí hodnota je 0.7.
    /// </summary>
    public double Koeficient { get; set; } = 0.7;

    /// <summary>
    /// Délka kmene (větve v úrovni 0) v pixelech. Výchozí hodnota je 120.
    /// </summary>
    public double DelkaKmene { get; set; } = 120;

    /// <summary>
    /// Barva větví stromu ve formátu hexadecimálního zápisu "#RRGGBB".
    /// Výchozí hodnota je "#2E7D32" (tmavě zelená).
    /// </summary>
    public string BarvaHex { get; set; } = "#2E7D32";
}

namespace FraktalniStrom.Jadro;

/// <summary>
/// Datový přenosový objekt (DTO) reprezentující kompletní uložený stav
/// fraktálního stromu — vstupní parametry, ze kterých byl strom vygenerován,
/// a seznam všech jeho větví. Slouží pro serializaci a deserializaci do/z JSON.
/// </summary>
public class StromData
{
    /// <summary>
    /// Parametry, se kterými byl strom vygenerován.
    /// </summary>
    public ParametryStromu Parametry { get; set; } = new();

    /// <summary>
    /// Seznam všech větví vygenerovaného stromu.
    /// </summary>
    public List<Vetev> Vetve { get; set; } = new();
}

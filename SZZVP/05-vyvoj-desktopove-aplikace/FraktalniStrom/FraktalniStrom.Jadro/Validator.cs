using System.Globalization;
using System.Text.RegularExpressions;

namespace FraktalniStrom.Jadro;

/// <summary>
/// Poskytuje validaci parametrů fraktálního stromu a bezpečné (nevyhazující)
/// parsování číselných vstupů ze vstupních polí uživatelského rozhraní.
/// </summary>
public static class Validator
{
    /// <summary>
    /// Regulární výraz pro kontrolu formátu hexadecimální barvy "#RRGGBB".
    /// </summary>
    private static readonly Regex VzorBarvy = new("^#[0-9A-Fa-f]{6}$", RegexOptions.Compiled);

    /// <summary>
    /// Minimální povolený počet iterací.
    /// </summary>
    private const int MinIterace = 1;

    /// <summary>
    /// Maximální povolený počet iterací. Počet generovaných větví roste
    /// exponenciálně jako 2^Iterace - 1, takže při Iterace = 18 vznikne
    /// přibližně 262 143 větví. Vyšší hodnoty by vedly k řádově milionům
    /// větví a k neúměrné spotřebě paměti i času generování, proto je 18
    /// zvoleno jako smysluplný horní limit.
    /// </summary>
    private const int MaxIterace = 18;

    /// <summary>
    /// Zkontroluje, zda jsou parametry stromu platné pro generování.
    /// </summary>
    /// <param name="p">Parametry stromu, které se mají zkontrolovat.</param>
    /// <param name="chyba">Srozumitelná česká chybová hláška, nebo prázdný řetězec, pokud jsou parametry v pořádku.</param>
    /// <returns><c>true</c>, pokud jsou parametry platné, jinak <c>false</c>.</returns>
    public static bool Zkontroluj(ParametryStromu p, out string chyba)
    {
        if (p.Iterace < MinIterace || p.Iterace > MaxIterace)
        {
            chyba = $"Počet iterací musí být v rozsahu {MinIterace} až {MaxIterace} (nad {MaxIterace} by počet větví (2^n - 1) vedl k nadměrné spotřebě paměti).";
            return false;
        }

        if (p.UhelStupne <= 0 || p.UhelStupne >= 180)
        {
            chyba = "Úhel větvení musí být v rozsahu 0° až 180° (bez krajních hodnot).";
            return false;
        }

        if (p.Koeficient <= 0 || p.Koeficient >= 1)
        {
            chyba = "Koeficient zmenšování musí být v rozsahu 0 až 1 (bez krajních hodnot).";
            return false;
        }

        if (p.DelkaKmene <= 0)
        {
            chyba = "Délka kmene musí být kladné číslo.";
            return false;
        }

        if (string.IsNullOrWhiteSpace(p.BarvaHex) || !VzorBarvy.IsMatch(p.BarvaHex))
        {
            chyba = "Barva musí být zadána ve formátu #RRGGBB (např. #2E7D32).";
            return false;
        }

        chyba = string.Empty;
        return true;
    }

    /// <summary>
    /// Bezpečně se pokusí naparsovat řetězec na desetinné číslo bez ohledu na
    /// aktuální kulturu (používá invariantní kulturu). Nikdy nevyhazuje výjimku.
    /// </summary>
    /// <param name="vstup">Vstupní řetězec, může být <c>null</c> nebo prázdný.</param>
    /// <param name="hodnota">Naparsovaná hodnota, nebo 0, pokud parsování selhalo.</param>
    /// <returns><c>true</c>, pokud se parsování povedlo, jinak <c>false</c>.</returns>
    public static bool ZkusParsovat(string? vstup, out double hodnota)
    {
        if (string.IsNullOrWhiteSpace(vstup))
        {
            hodnota = 0;
            return false;
        }

        return double.TryParse(vstup, NumberStyles.Float, CultureInfo.InvariantCulture, out hodnota);
    }

    /// <summary>
    /// Bezpečně se pokusí naparsovat řetězec na celé číslo bez ohledu na
    /// aktuální kulturu (používá invariantní kulturu). Nikdy nevyhazuje výjimku.
    /// </summary>
    /// <param name="vstup">Vstupní řetězec, může být <c>null</c> nebo prázdný.</param>
    /// <param name="hodnota">Naparsovaná hodnota, nebo 0, pokud parsování selhalo.</param>
    /// <returns><c>true</c>, pokud se parsování povedlo, jinak <c>false</c>.</returns>
    public static bool ZkusParsovat(string? vstup, out int hodnota)
    {
        if (string.IsNullOrWhiteSpace(vstup))
        {
            hodnota = 0;
            return false;
        }

        return int.TryParse(vstup, NumberStyles.Integer, CultureInfo.InvariantCulture, out hodnota);
    }
}

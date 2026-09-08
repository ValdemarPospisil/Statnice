namespace FraktalniStrom.Jadro;

/// <summary>
/// Generátor geometrie fraktálního stromu (fractal canopy) postavený na
/// iterativním (nikoli rekurzivním) zpracování po jednotlivých úrovních.
/// </summary>
public static class Generator
{
    /// <summary>
    /// Vnitřní pomocná reprezentace růstového bodu větve před jejím vykreslením:
    /// souřadnice počátku, směrový úhel v radiánech a délka, kterou má větev mít.
    /// </summary>
    private readonly record struct BodRustu(double X, double Y, double Uhel, double Delka);

    /// <summary>
    /// Vygeneruje seznam všech větví fraktálního stromu podle zadaných parametrů.
    /// Zpracování probíhá po úrovních: pro každou úroveň se ze seznamu aktuálních
    /// růstových bodů vytvoří výsledné větve a zároveň se připraví růstové body
    /// pro úroveň následující (každá větev se rozdělí na dva potomky).
    /// </summary>
    /// <param name="p">Parametry stromu (počet iterací, úhel, koeficient, délka kmene).</param>
    /// <param name="progress">
    /// Volitelný reportér průběhu generování v procentech (0–100), používaný
    /// pro informování uživatelského rozhraní. Může být <c>null</c>.
    /// </param>
    /// <param name="pauza">
    /// Volitelný signál pro pozastavení generování. Pokud je nenastavený
    /// (<c>false</c>), generování se na začátku každé úrovně zablokuje, dokud
    /// není nastaven zpět na <c>true</c>, nebo dokud není zrušen <paramref name="token"/>.
    /// Může být <c>null</c>, pak se pauza neuplatňuje.
    /// </param>
    /// <param name="token">Token pro zrušení běžícího generování.</param>
    /// <returns>Seznam všech vygenerovaných větví napříč všemi úrovněmi.</returns>
    /// <exception cref="OperationCanceledException">
    /// Je vyhozena, pokud je generování zrušeno pomocí <paramref name="token"/>
    /// (ať už před spuštěním, nebo v průběhu čekání na pauzu).
    /// </exception>
    public static List<Vetev> Generuj(
        ParametryStromu p,
        IProgress<int>? progress,
        ManualResetEventSlim? pauza,
        CancellationToken token)
    {
        var vysledek = new List<Vetev>();
        var aktualni = new List<BodRustu> { new(0, 0, -Math.PI / 2, p.DelkaKmene) };
        var rad = p.UhelStupne * Math.PI / 180;

        for (var uroven = 0; uroven < p.Iterace; uroven++)
        {
            pauza?.Wait(token);
            token.ThrowIfCancellationRequested();

            var dalsi = new List<BodRustu>();

            foreach (var bod in aktualni)
            {
                var x2 = bod.X + bod.Delka * Math.Cos(bod.Uhel);
                var y2 = bod.Y + bod.Delka * Math.Sin(bod.Uhel);

                vysledek.Add(new Vetev(bod.X, bod.Y, x2, y2, uroven));

                dalsi.Add(new BodRustu(x2, y2, bod.Uhel - rad, bod.Delka * p.Koeficient));
                dalsi.Add(new BodRustu(x2, y2, bod.Uhel + rad, bod.Delka * p.Koeficient));
            }

            aktualni = dalsi;
            progress?.Report(100 * (uroven + 1) / p.Iterace);
        }

        return vysledek;
    }
}

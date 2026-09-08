namespace FraktalniStrom.Jadro;

/// <summary>
/// Reprezentuje jednu úsečku (větev) fraktálního stromu definovanou počátečním
/// bodem [<see cref="X1"/>, <see cref="Y1"/>], koncovým bodem
/// [<see cref="X2"/>, <see cref="Y2"/>] a úrovní větvení, ve které vznikla.
/// </summary>
/// <param name="X1">Souřadnice X počátečního bodu větve.</param>
/// <param name="Y1">Souřadnice Y počátečního bodu větve.</param>
/// <param name="X2">Souřadnice X koncového bodu větve.</param>
/// <param name="Y2">Souřadnice Y koncového bodu větve.</param>
/// <param name="Uroven">Úroveň (hloubka) větvení, kde 0 je kmen.</param>
public record Vetev(double X1, double Y1, double X2, double Y2, int Uroven);

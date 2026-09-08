using System;
using System.Collections.Generic;
using Avalonia;
using Avalonia.Controls;
using Avalonia.Media;
using FraktalniStrom.Jadro;

namespace FraktalniStrom.App.Controls;

/// <summary>
/// Vlastní kreslicí control, který vykresluje seznam větví fraktálního stromu
/// vygenerovaných třídou <see cref="Generator"/>. Souřadnice větví jsou
/// definovány kolem počátku (0, 0) s kmenem rostoucím vzhůru (v záporném
/// směru osy Y), proto se při vykreslování transformují tak, aby se strom
/// zobrazil uprostřed dolní části plochy controlu.
/// </summary>
public class PlatnoStromu : Control
{
    /// <summary>
    /// Definuje vlastnost <see cref="Vetve"/> — seznam větví, které se mají vykreslit.
    /// </summary>
    public static readonly StyledProperty<IReadOnlyList<Vetev>?> VetveProperty =
        AvaloniaProperty.Register<PlatnoStromu, IReadOnlyList<Vetev>?>(nameof(Vetve));

    /// <summary>
    /// Definuje vlastnost <see cref="Barva"/> — štětec použitý pro vykreslení větví.
    /// </summary>
    public static readonly StyledProperty<IBrush?> BarvaProperty =
        AvaloniaProperty.Register<PlatnoStromu, IBrush?>(nameof(Barva), Brushes.Black);

    /// <summary>
    /// Statický konstruktor, který zaregistruje vlastnosti <see cref="Vetve"/>
    /// a <see cref="Barva"/> tak, aby jejich změna vyvolala překreslení controlu.
    /// </summary>
    static PlatnoStromu()
    {
        AffectsRender<PlatnoStromu>(VetveProperty, BarvaProperty);
    }

    /// <summary>
    /// Seznam větví fraktálního stromu, které se mají vykreslit. Pokud je
    /// <c>null</c> nebo prázdný, control nevykreslí žádnou geometrii.
    /// </summary>
    public IReadOnlyList<Vetev>? Vetve
    {
        get => GetValue(VetveProperty);
        set => SetValue(VetveProperty, value);
    }

    /// <summary>
    /// Štětec, kterým se vykreslují všechny větve stromu.
    /// </summary>
    public IBrush? Barva
    {
        get => GetValue(BarvaProperty);
        set => SetValue(BarvaProperty, value);
    }

    /// <summary>
    /// Vykreslí všechny větve stromu na plochu controlu. Souřadnice ze
    /// generátoru jsou posunuty tak, aby počátek kmene ležel uprostřed dolního
    /// okraje plochy controlu (s malou rezervou 20 px od spodního okraje).
    /// Tloušťka jednotlivých větví klesá s rostoucí úrovní větvení.
    /// </summary>
    /// <param name="context">Kontext kreslení poskytnutý Avalonií.</param>
    public override void Render(DrawingContext context)
    {
        base.Render(context);

        var vetve = Vetve;
        if (vetve is null || vetve.Count == 0)
        {
            return;
        }

        var barva = Barva ?? Brushes.Black;
        var stredX = Bounds.Width / 2;
        var stredY = Bounds.Height - 20;

        foreach (var v in vetve)
        {
            var tloustka = Math.Max(1, 6 - v.Uroven * 0.4);
            var pero = new Pen(barva, tloustka);

            var bod1 = new Point(stredX + v.X1, stredY + v.Y1);
            var bod2 = new Point(stredX + v.X2, stredY + v.Y2);

            context.DrawLine(pero, bod1, bod2);
        }
    }
}

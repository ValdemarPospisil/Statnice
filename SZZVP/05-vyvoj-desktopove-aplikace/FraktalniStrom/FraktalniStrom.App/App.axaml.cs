using Avalonia;
using Avalonia.Controls.ApplicationLifetimes;
using Avalonia.Markup.Xaml;
using FraktalniStrom.App.ViewModels;
using FraktalniStrom.App.Views;

namespace FraktalniStrom.App;

/// <summary>
/// Vstupní bod Avalonia aplikace. Zajišťuje načtení globálních stylů a
/// vytvoření hlavního okna s napojeným view modelem.
/// </summary>
public partial class App : Application
{
    /// <summary>
    /// Načte definice XAML pro tuto aplikaci (styly, datové šablony).
    /// </summary>
    public override void Initialize()
    {
        AvaloniaXamlLoader.Load(this);
    }

    /// <summary>
    /// Po dokončení inicializace frameworku vytvoří hlavní okno aplikace a
    /// nastaví mu jako <c>DataContext</c> novou instanci <see cref="MainViewModel"/>.
    /// </summary>
    public override void OnFrameworkInitializationCompleted()
    {
        if (ApplicationLifetime is IClassicDesktopStyleApplicationLifetime desktop)
        {
            desktop.MainWindow = new MainWindow
            {
                DataContext = new MainViewModel(),
            };
        }

        base.OnFrameworkInitializationCompleted();
    }
}
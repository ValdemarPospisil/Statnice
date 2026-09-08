using Avalonia;
using System;

namespace FraktalniStrom.App;

/// <summary>
/// Obsahuje vstupní bod aplikace a konfiguraci Avalonia frameworku.
/// </summary>
sealed class Program
{
    // Initialization code. Don't use any Avalonia, third-party APIs or any
    // SynchronizationContext-reliant code before AppMain is called: things aren't initialized
    // yet and stuff might break.
    /// <summary>
    /// Vstupní bod aplikace. Spouští Avalonia aplikaci v klasickém desktopovém
    /// životním cyklu.
    /// </summary>
    /// <param name="args">Argumenty příkazové řádky.</param>
    [STAThread]
    public static void Main(string[] args) => BuildAvaloniaApp()
        .StartWithClassicDesktopLifetime(args);

    // Avalonia configuration, don't remove; also used by visual designer.
    /// <summary>
    /// Sestaví a nakonfiguruje instanci <see cref="AppBuilder"/> pro tuto aplikaci.
    /// </summary>
    /// <returns>Nakonfigurovaný <see cref="AppBuilder"/>.</returns>
    public static AppBuilder BuildAvaloniaApp()
        => AppBuilder.Configure<App>()
            .UsePlatformDetect()
#if DEBUG
            .WithDeveloperTools()
#endif
            .WithInterFont()
            .LogToTrace();
}

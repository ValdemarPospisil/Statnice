using System.Threading.Tasks;
using Avalonia.Controls;
using Avalonia.Platform.Storage;
using FraktalniStrom.App.ViewModels;

namespace FraktalniStrom.App.Views;

/// <summary>
/// Hlavní okno aplikace. Obsahuje výhradně napojení zobrazování souborových
/// dialogů (přes <see cref="TopLevel.StorageProvider"/>) na view model —
/// veškerá aplikační a doménová logika zůstává v <see cref="MainViewModel"/>,
/// aby byl view model nezávislý na Avalonia oknech a testovatelný.
/// </summary>
public partial class MainWindow : Window
{
    /// <summary>
    /// Vytvoří hlavní okno a napojí na jeho view model delegáta pro
    /// zobrazování dialogů pro výběr souboru.
    /// </summary>
    public MainWindow()
    {
        InitializeComponent();

        DataContextChanged += (_, _) =>
        {
            if (DataContext is MainViewModel vm)
            {
                vm.VyzadatCestu = VyzadatCestuAsync;
            }
        };
    }

    /// <summary>
    /// Zobrazí dialog pro uložení nebo otevření souboru pomocí
    /// <see cref="IStorageProvider"/> aktuálního okna a vrátí zvolenou
    /// lokální cestu, nebo <c>null</c>, pokud uživatel dialog zrušil.
    /// </summary>
    /// <param name="proUlozeni">
    /// <c>true</c>, pokud se má zobrazit dialog pro uložení souboru;
    /// <c>false</c> pro dialog otevření souboru.
    /// </param>
    /// <returns>Vybraná lokální cesta k souboru, nebo <c>null</c>.</returns>
    private async Task<string?> VyzadatCestuAsync(bool proUlozeni)
    {
        var top = TopLevel.GetTopLevel(this);
        if (top?.StorageProvider is null)
        {
            return null;
        }

        var typJson = new FilePickerFileType("JSON") { Patterns = new[] { "*.json" } };

        if (proUlozeni)
        {
            var soubor = await top.StorageProvider.SaveFilePickerAsync(new FilePickerSaveOptions
            {
                Title = "Uložit strom jako JSON",
                SuggestedFileName = "strom.json",
                DefaultExtension = "json",
                FileTypeChoices = new[] { typJson },
            });

            return soubor?.TryGetLocalPath();
        }

        var soubory = await top.StorageProvider.OpenFilePickerAsync(new FilePickerOpenOptions
        {
            Title = "Otevřít strom z JSON",
            AllowMultiple = false,
            FileTypeFilter = new[] { typJson },
        });

        return soubory.Count > 0 ? soubory[0].TryGetLocalPath() : null;
    }
}

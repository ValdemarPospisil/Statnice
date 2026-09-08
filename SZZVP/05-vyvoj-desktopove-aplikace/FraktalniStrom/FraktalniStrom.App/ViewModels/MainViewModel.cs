using System;
using System.Collections.Generic;
using System.IO;
using System.Threading;
using System.Threading.Tasks;
using Avalonia.Media;
using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using FraktalniStrom.Jadro;

namespace FraktalniStrom.App.ViewModels;

/// <summary>
/// Hlavní view model aplikace. Obsahuje textové vstupy pro parametry
/// fraktálního stromu, řídí asynchronní generování (včetně pozastavení a
/// zrušení), zobrazuje průběh a stav výpočtu a zprostředkovává export/import
/// vygenerovaného stromu do/z JSON souboru.
/// </summary>
public partial class MainViewModel : ViewModelBase
{
    /// <summary>
    /// Signál pro pozastavení/pokračování běžícího generování. Ve výchozím
    /// (nastaveném) stavu generování neblokuje.
    /// </summary>
    private readonly ManualResetEventSlim _pauza = new(initialState: true);

    /// <summary>
    /// Zdroj zrušení pro aktuálně běžící (nebo poslední) výpočet generování.
    /// </summary>
    private CancellationTokenSource? _cts;

    /// <summary>
    /// Textová hodnota počtu iterací zadaná uživatelem.
    /// </summary>
    [ObservableProperty]
    private string _iteraceText = "10";

    /// <summary>
    /// Textová hodnota úhlu větvení ve stupních zadaná uživatelem.
    /// </summary>
    [ObservableProperty]
    private string _uhelText = "25";

    /// <summary>
    /// Textová hodnota koeficientu zmenšování délky větve zadaná uživatelem.
    /// </summary>
    [ObservableProperty]
    private string _koeficientText = "0.7";

    /// <summary>
    /// Textová hodnota délky kmene zadaná uživatelem.
    /// </summary>
    [ObservableProperty]
    private string _delkaKmeneText = "120";

    /// <summary>
    /// Barva větví stromu vybraná uživatelem pomocí <c>ColorPicker</c>u.
    /// </summary>
    [ObservableProperty]
    private Color _barva = Color.Parse("#2E7D32");

    /// <summary>
    /// Aktuální průběh generování v procentech (0–100), zobrazovaný v <c>ProgressBar</c>u.
    /// </summary>
    [ObservableProperty]
    private int _prubeh;

    /// <summary>
    /// Textová hláška popisující aktuální stav aplikace (chyby, informace o průběhu apod.).
    /// </summary>
    [ObservableProperty]
    private string _stav = "Připraveno.";

    /// <summary>
    /// Poslední vygenerovaný (nebo načtený) seznam větví stromu k vykreslení.
    /// </summary>
    [ObservableProperty]
    private IReadOnlyList<Vetev>? _vetve;

    /// <summary>
    /// Určuje, zda aktuálně probíhá generování stromu.
    /// </summary>
    [ObservableProperty]
    [NotifyCanExecuteChangedFor(nameof(SpustitCommand))]
    [NotifyCanExecuteChangedFor(nameof(ImportovatCommand))]
    private bool _beziVypocet;

    /// <summary>
    /// Určuje, zda je běžící generování aktuálně pozastaveno.
    /// </summary>
    [ObservableProperty]
    private bool _jePozastaveno;

    /// <summary>
    /// Text tlačítka pro pozastavení/pokračování, měnící se podle
    /// <see cref="JePozastaveno"/>.
    /// </summary>
    public string TextPozastaveni => JePozastaveno ? "Pokračovat" : "Pozastavit";

    /// <summary>
    /// Funkce zprostředkovávající zobrazení dialogu pro výběr cesty k souboru.
    /// Parametr <c>true</c> znamená ukládání (Save dialog), <c>false</c>
    /// otevírání (Open dialog). Návratová hodnota je vybraná lokální cesta,
    /// nebo <c>null</c>, pokud uživatel dialog zrušil.
    /// </summary>
    /// <remarks>
    /// View model záměrně nezná <c>TopLevel</c> ani <c>StorageProvider</c> —
    /// ty jsou dostupné jen z okna (View). Aby zůstal view model testovatelný
    /// a nezávislý na Avalonia oknech, je zobrazení dialogu vystaveno jako
    /// delegát, který si nastaví code-behind okna (viz <c>MainWindow.axaml.cs</c>).
    /// Code-behind tak obsahuje pouze volání dialogu, žádnou aplikační logiku.
    /// </remarks>
    public Func<bool, Task<string?>>? VyzadatCestu { get; set; }

    /// <summary>
    /// Poskládá <see cref="ParametryStromu"/> z aktuálních textových vstupů.
    /// Numerické hodnoty se parsují přes <see cref="Validator.ZkusParsovat(string?, out double)"/>,
    /// aby nesmyslný vstup nevedl k výjimce, pouze k neplatné (výchozí) hodnotě,
    /// kterou následně odchytí <see cref="Validator.Zkontroluj"/>.
    /// </summary>
    private ParametryStromu SestavParametry()
    {
        Validator.ZkusParsovat(IteraceText, out int iterace);
        Validator.ZkusParsovat(UhelText, out double uhel);
        Validator.ZkusParsovat(KoeficientText, out double koeficient);
        Validator.ZkusParsovat(DelkaKmeneText, out double delkaKmene);

        return new ParametryStromu
        {
            Iterace = iterace,
            UhelStupne = uhel,
            Koeficient = koeficient,
            DelkaKmene = delkaKmene,
            BarvaHex = $"#{Barva.R:X2}{Barva.G:X2}{Barva.B:X2}",
        };
    }

    /// <summary>
    /// Naplní textové vstupy a barvu z existujících parametrů stromu, např.
    /// po importu ze souboru.
    /// </summary>
    /// <param name="p">Parametry, kterými se mají formulářová pole přepsat.</param>
    private void NactiParametryDoFormulare(ParametryStromu p)
    {
        IteraceText = p.Iterace.ToString();
        UhelText = p.UhelStupne.ToString();
        KoeficientText = p.Koeficient.ToString();
        DelkaKmeneText = p.DelkaKmene.ToString();

        if (Color.TryParse(p.BarvaHex, out var barva))
        {
            Barva = barva;
        }
    }

    /// <summary>
    /// Určuje, zda lze aktuálně spustit nové generování (nesmí již jedno běžet).
    /// </summary>
    private bool MuzeSpustit() => !BeziVypocet;

    /// <summary>
    /// Sestaví parametry stromu z formuláře, ověří jejich platnost a pokud
    /// jsou v pořádku, spustí asynchronní generování na vlákně z fondu vláken
    /// (přes <see cref="Task.Run(Action)"/>), aby výpočet neblokoval UI vlákno.
    /// Průběh generování je hlášen do <see cref="Prubeh"/>. Zrušení výpočtu
    /// (<see cref="Zrusit"/>) je odchyceno a promítnuto do <see cref="Stav"/>
    /// bez pádu aplikace.
    /// </summary>
    [RelayCommand(CanExecute = nameof(MuzeSpustit))]
    private async Task SpustitAsync()
    {
        var p = SestavParametry();

        if (!Validator.Zkontroluj(p, out var chyba))
        {
            Stav = chyba;
            return;
        }

        _cts = new CancellationTokenSource();
        _pauza.Set();
        JePozastaveno = false;
        OnPropertyChanged(nameof(TextPozastaveni));
        BeziVypocet = true;
        Prubeh = 0;
        Stav = "Generuji strom…";

        try
        {
            var token = _cts.Token;
            var progress = new Progress<int>(hodnota => Prubeh = hodnota);

            var vysledek = await Task.Run(() => Generator.Generuj(p, progress, _pauza, token), token);

            Vetve = vysledek;
            Stav = $"Hotovo. Vygenerováno {vysledek.Count} větví.";
        }
        catch (OperationCanceledException)
        {
            Stav = "Výpočet zrušen uživatelem.";
        }
        finally
        {
            BeziVypocet = false;
            JePozastaveno = false;
            OnPropertyChanged(nameof(TextPozastaveni));
            _cts?.Dispose();
            _cts = null;
        }
    }

    /// <summary>
    /// Určuje, zda lze aktuálně pozastavit nebo obnovit generování (musí právě běžet).
    /// </summary>
    private bool MuzePozastavit() => BeziVypocet;

    /// <summary>
    /// Přepne stav pozastavení běžícího generování. Pokud generování běží
    /// (signál je nastavený), pozastaví jej (<see cref="ManualResetEventSlim.Reset"/>).
    /// Pokud je pozastavené, nechá jej pokračovat (<see cref="ManualResetEventSlim.Set"/>).
    /// </summary>
    [RelayCommand(CanExecute = nameof(MuzePozastavit))]
    private void Pozastavit()
    {
        if (_pauza.IsSet)
        {
            _pauza.Reset();
            JePozastaveno = true;
            Stav = "Pozastaveno.";
        }
        else
        {
            _pauza.Set();
            JePozastaveno = false;
            Stav = "Generuji strom…";
        }

        OnPropertyChanged(nameof(TextPozastaveni));
    }

    /// <summary>
    /// Zruší běžící generování. Pokud je výpočet v danou chvíli pozastavený,
    /// je nutné jej nejprve uvolnit signálem <see cref="ManualResetEventSlim.Set"/>,
    /// jinak by generátor zůstal navždy čekat na <c>pauza.Wait(token)</c> a
    /// zrušení by se nikdy neprojevilo (i když <c>Wait</c> na token reaguje,
    /// spolehlivě to funguje jen pokud vlákno čekání vůbec opustí).
    /// </summary>
    [RelayCommand(CanExecute = nameof(MuzePozastavit))]
    private void Zrusit()
    {
        _cts?.Cancel();
        _pauza.Set();
        JePozastaveno = false;
        OnPropertyChanged(nameof(TextPozastaveni));
    }

    /// <summary>
    /// Vyexportuje aktuálně vygenerovaný strom (parametry i větve) do JSON
    /// souboru zvoleného uživatelem pomocí <see cref="VyzadatCestu"/>.
    /// </summary>
    [RelayCommand]
    private async Task ExportovatAsync()
    {
        if (Vetve is null || Vetve.Count == 0)
        {
            Stav = "Není co exportovat — nejprve vygenerujte strom.";
            return;
        }

        if (VyzadatCestu is null)
        {
            return;
        }

        var cesta = await VyzadatCestu(true);
        if (string.IsNullOrWhiteSpace(cesta))
        {
            return;
        }

        try
        {
            var p = SestavParametry();
            await JsonUloziste.UlozAsync(cesta, p, new List<Vetev>(Vetve));
            Stav = $"Strom uložen do souboru '{cesta}'.";
        }
        catch (Exception ex) when (ex is IOException or UnauthorizedAccessException)
        {
            Stav = $"Uložení se nezdařilo: {ex.Message}";
        }
    }

    /// <summary>
    /// Naimportuje strom (parametry i větve) z JSON souboru zvoleného
    /// uživatelem pomocí <see cref="VyzadatCestu"/>. Po úspěšném načtení
    /// obnoví formulářová pole podle načtených parametrů a rovnou vykreslí
    /// načtené větve.
    /// </summary>
    [RelayCommand]
    private async Task ImportovatAsync()
    {
        if (VyzadatCestu is null)
        {
            return;
        }

        var cesta = await VyzadatCestu(false);
        if (string.IsNullOrWhiteSpace(cesta))
        {
            return;
        }

        try
        {
            var data = await JsonUloziste.NactiAsync(cesta);
            NactiParametryDoFormulare(data.Parametry);
            Vetve = data.Vetve;
            Stav = $"Strom načten ze souboru '{cesta}' ({data.Vetve.Count} větví).";
        }
        catch (FileNotFoundException ex)
        {
            Stav = ex.Message;
        }
        catch (InvalidDataException ex)
        {
            Stav = ex.Message;
        }
    }
}

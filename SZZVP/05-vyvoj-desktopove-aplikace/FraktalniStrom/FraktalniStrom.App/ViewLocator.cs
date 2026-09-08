using System;
using System.Diagnostics.CodeAnalysis;
using Avalonia.Controls;
using Avalonia.Controls.Templates;
using FraktalniStrom.App.ViewModels;

namespace FraktalniStrom.App;

/// <summary>
/// Given a view model, returns the corresponding view if possible.
/// </summary>
[RequiresUnreferencedCode(
    "Default implementation of ViewLocator involves reflection which may be trimmed away.",
    Url = "https://docs.avaloniaui.net/docs/concepts/view-locator")]
public class ViewLocator : IDataTemplate
{
    /// <summary>
    /// Podle typu předaného view modelu dohledá odpovídající typ View (podle
    /// konvence názvu, kde se "ViewModel" nahradí za "View") a vytvoří jeho instanci.
    /// </summary>
    /// <param name="param">Instance view modelu, pro kterou se hledá odpovídající View.</param>
    /// <returns>Vytvořený control View, nebo textová hláška, pokud View nebylo nalezeno.</returns>
    public Control? Build(object? param)
    {
        if (param is null)
            return null;

        var name = param.GetType().FullName!.Replace("ViewModel", "View", StringComparison.Ordinal);
        var type = Type.GetType(name);

        if (type != null)
        {
            return (Control)Activator.CreateInstance(type)!;
        }

        return new TextBlock { Text = "Not Found: " + name };
    }

    /// <summary>
    /// Určuje, zda tato šablona umí zpracovat daná data — tedy zda jde o
    /// instanci <see cref="ViewModelBase"/>.
    /// </summary>
    /// <param name="data">Objekt, pro který se ověřuje shoda.</param>
    /// <returns><c>true</c>, pokud je <paramref name="data"/> typu <see cref="ViewModelBase"/>.</returns>
    public bool Match(object? data)
    {
        return data is ViewModelBase;
    }
}

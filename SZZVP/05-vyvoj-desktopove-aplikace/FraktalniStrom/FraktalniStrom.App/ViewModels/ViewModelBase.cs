using CommunityToolkit.Mvvm.ComponentModel;

namespace FraktalniStrom.App.ViewModels;

/// <summary>
/// Společný základ pro všechny view modely aplikace, poskytující notifikace
/// o změně vlastností (<see cref="ObservableObject"/>).
/// </summary>
public abstract class ViewModelBase : ObservableObject
{
}

using Avalonia.Controls;
using Avalonia.Threading;
using Remoteapp.Desktop.Core.Interfaces;
using Remoteapp.Desktop.XPlat.Views;

namespace Remoteapp.Desktop.XPlat.Services
{
    public class SessionIndicatorLinux : ISessionIndicator
    {
        public void Show()
        {
            Dispatcher.UIThread.Post(() =>
            {
                var indicatorWindow = new SessionIndicatorWindow();
                indicatorWindow.Show();
            });
        }
    }
}

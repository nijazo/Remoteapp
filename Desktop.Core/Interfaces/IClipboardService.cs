using System;
using System.Threading.Tasks;

namespace Remoteapp.Desktop.Core.Interfaces
{
    public interface IClipboardService
    {
        event EventHandler<string> ClipboardTextChanged;

        void BeginWatching();

        Task SetText(string clipboardText);
    }
}

using Remoteapp.Shared.Models;
using System;

namespace Remoteapp.Desktop.Core.Interfaces
{
    public interface ICursorIconWatcher
    {
        event EventHandler<CursorInfo> OnChange;

        CursorInfo GetCurrentCursor();
    }

}

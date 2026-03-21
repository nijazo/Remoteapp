using Microsoft.Extensions.DependencyInjection;
using Remoteapp.Desktop.Core;
using Remoteapp.Desktop.Core.Interfaces;
using Remoteapp.Desktop.Core.Services;
using Remoteapp.Shared.Utilities;
using System;
using System.Diagnostics;
using System.Threading.Tasks;

namespace Remoteapp.Desktop.XPlat.Services
{
    public class ShutdownServiceLinux : IShutdownService
    {
        public async Task Shutdown()
        {
            Logger.Debug($"Exiting process ID {Environment.ProcessId}.");
            var casterSocket = ServiceContainer.Instance.GetRequiredService<ICasterSocket>();
            await casterSocket.DisconnectAllViewers();
            Environment.Exit(0);
        }
    }
}

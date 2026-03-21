using System;
using System.Threading.Tasks;

namespace Remoteapp.Agent.Interfaces
{
    public interface IUpdater : IDisposable
    {
        Task BeginChecking();
        Task CheckForUpdates();
        Task InstallLatestVersion();
    }
}
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Remoteapp.Server.Auth;
using Remoteapp.Server.Services;
using Remoteapp.Shared.Models;

namespace Remoteapp.Server.Pages
{
    [ServiceFilter(typeof(RemoteControlFilterAttribute))]
    public class RemoteControlModel : PageModel
    {
        private readonly IDataService _dataService;
        public RemoteControlModel(IDataService dataService)
        {
            _dataService = dataService;
        }

        public RemoteappUser RemoteappUser { get; private set; }
        public void OnGet()
        {
            if (User.Identity.IsAuthenticated)
            {
                RemoteappUser = _dataService.GetUserByNameWithOrg(base.User.Identity.Name);
            }
        }
    }
}

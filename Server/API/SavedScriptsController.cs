using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Remoteapp.Server.Auth;
using Remoteapp.Server.Services;
using Remoteapp.Shared.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Remoteapp.Server.API
{
    [Route("api/[controller]")]
    [ApiController]
    public class SavedScriptsController : ControllerBase
    {
        private readonly IDataService _dataService;

        public SavedScriptsController(IDataService dataService)
        {
            _dataService = dataService;
        }

        [ServiceFilter(typeof(ExpiringTokenFilter))]
        [HttpGet("{scriptId}")]
        public async Task<SavedScript> GetScript(Guid scriptId)
        {
            return await _dataService.GetSavedScript(scriptId);
        }
    }
}

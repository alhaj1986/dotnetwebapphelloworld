using System;
using Microsoft.AspNetCore.Mvc;

namespace hello_world_dotnet.Controllers
{
    [ApiController]
    [Route("")]
    public class HelloWorldController : ControllerBase
    {
        [HttpGet]
        public HelloWorld Get()
        {
            return new()
            {
                Message = "Hello-World Dot Net Application!",
                Timestamp = DateTime.Now
            };
        }
    }
}

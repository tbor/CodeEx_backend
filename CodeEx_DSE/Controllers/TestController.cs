using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using CodeEx_DSE.Data;
using CodeEx_DSE.Data.Models;

namespace CodeEx_DSE.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class TestController : ControllerBase
    {
        private readonly IDataRepository _dataRepository;

        public TestController(IDataRepository dataRepository)
        {
            _dataRepository = dataRepository;
        }

        [HttpGet]
        public IEnumerable<string> Get()
        {
            return new string[] { "test", "test2", "Test3" };
        }
    }
}

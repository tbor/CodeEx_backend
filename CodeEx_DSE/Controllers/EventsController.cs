using Microsoft.AspNetCore.Mvc;
using CodeEx_DSE.Data;
using CodeEx_DSE.Data.Models;
using Microsoft.AspNetCore.Authorization;

namespace CodeEx_DSE.Controllers
{
    [Route("api/[controller]")]
    [ApiController]

    public class EventsController : ControllerBase
    {
        private readonly IDataRepository _dataRepository;
        private readonly IHttpClientFactory _clientFactory;
        private readonly string _auth0UserInfo;
        public EventsController(IDataRepository dataRepository, IHttpClientFactory clientFactory, IConfiguration configuration)
        {
            _dataRepository = dataRepository;
            _clientFactory = clientFactory;
            _auth0UserInfo = $"{configuration["Auth0:Authority"]}userinfo";
        }

        //[Authorize]
        [HttpGet]
        public async Task<IEnumerable<Event>> GetEvents(string? search) 
        {
            if (string.IsNullOrEmpty(search))
            {
                return await _dataRepository.GetEventMany(); 
            }
            else
            {
                return await _dataRepository.GetEventMany_bySearch(search);
            }
        }

        //[Authorize]
        [HttpGet("{eventId}")]
        public async Task<ActionResult<Event>> GetEvent(int eventId, string? search)
        {
            var thisEvent = _dataRepository.GetEventSingle(eventId, search);

            if (thisEvent == null)
            {
                return NotFound();
            }
            return await thisEvent;
        }

        [Authorize(Policy = "MustBeEventCoordinator")] 
        [HttpPost("new")]
        public async Task<Event> PostEvent(EventPostFullRequest newEventRequest)
        {
            return await _dataRepository.PostNewEvent(newEventRequest);
        }

        [Authorize]
        [HttpGet("{eventId}/Registrations")]
        public async Task<IEnumerable<EventRegistration>> GetRegistrations(int? eventId, string? search)
        {
            if (string.IsNullOrEmpty(search))
            {
                return await _dataRepository.GetEventRegistrations(eventId, "");
            }
            else
            {
                return await _dataRepository.GetEventRegistrations(eventId, search);
            }
        }

        [Authorize(Policy = "MustBeEventCoordinator")]
        [HttpPost("{eventId}/registrations/update")]
        public async Task<EventRegistration> UpdateRegistration(EventRegistration eventRegistration)
        {
            return await _dataRepository.PostRegistration(eventRegistration);
        }


        [Authorize]
        [HttpPost("registrations/new")]
        public async Task<EventRegistration> PostRegistration(EventRegistration newEventRegistration)
        {
            return await _dataRepository.PostRegistration(newEventRegistration);
        }

        [Authorize]
        [HttpGet("user/{userId}")]
        public async Task<User> GetUser(string userId)
        {
            var thisUser = _dataRepository.GetUserSingle(userId);
            return await thisUser;
        }

        //[Authorize]
        [HttpPost("user/update")]
        public async Task<User> PostUser(UserPostFullRequest user)
        {
            var thisUser = _dataRepository.PostUser(user);
            return await thisUser;
        }

    }
}

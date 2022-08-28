using System;
using CodeEx_DSE.Data.Models;

namespace CodeEx_DSE.Data
{
    public interface IDataRepository
    {
        Task<IEnumerable<User>> GetUserMany();
        Task<User> GetUserSingle(string userId);
        Task<User> PostUser(UserPostFullRequest thisUser);
        Task<IEnumerable<EventRegistration>> GetEventRegistrations(int? eventId, string? search); 
        Task<EventRegistration> PostRegistration(EventRegistration newEventRegistration);
        Task<Event> GetEventSingle(int idEvent, string? search); 
        Task<IEnumerable<Event>> GetEventMany();
        Task<IEnumerable<Event>> GetEventMany_bySearch(string search);
        Task<IEnumerable<EventStatusList>> EventStatusListGet();
        Task<bool> AttendeeAuthorized(int EventId, string UserId);
        Task<Event> PostNewEvent(EventPostFullRequest thisEvent);


    }
}

using Microsoft.Data.SqlClient;
using Dapper;
using CodeEx_DSE.Data.Models;

namespace CodeEx_DSE.Data
{
    public class DataRepository : IDataRepository
    {
        private readonly string _connectionString;
        public DataRepository(IConfiguration configuration)
        {
            _connectionString = configuration["ConnectionStrings:DefaultConnection"];
        }

        public async Task<User> GetUserSingle(string userId)
        {
            using (var connection = new SqlConnection(_connectionString))
            {
                await connection.OpenAsync();
                return await connection.QueryFirstOrDefaultAsync<User>(@"EXEC dbo.User_Get @UserId = @userId", new { userId = userId });
            }
        }

        public async Task<IEnumerable<User>> GetUserMany()
        {
            using (var connection = new SqlConnection(_connectionString))
            {
                await connection.OpenAsync();
                return await connection.QueryAsync<User>(@"EXEC dbo.User_Get");
            }
        }

        public async Task<User> PostUser(UserPostFullRequest thisUser)
        {
            using (var connection = new SqlConnection(_connectionString))
            {
                await connection.OpenAsync();
                return await connection.QueryFirstOrDefaultAsync<User>(@"EXEC dbo.User_Post @userId = @userId, @userEmail = @userEmail, @userName = @userName, @isCoordinator = @isCoordinator", new { userId = thisUser.userId, userEmail = thisUser.userEmail, userName = thisUser.userName, isCoordinator = thisUser.isCoordinator });
            }
        }
        public async Task<IEnumerable<Event>> GetEventMany()
        {
            using (var connection = new SqlConnection(_connectionString))
            {
                await connection.OpenAsync();
                return await connection.QueryAsync<Event>(@"EXEC dbo.Event_Get");
            }
        }
        public async Task<IEnumerable<Event>> GetEventMany_bySearch(string search)
        {
            using (var connection = new SqlConnection(_connectionString))
            {
                await connection.OpenAsync();
                return await connection.QueryAsync<Event>(@"EXEC dbo.Event_Get @Search = @Search", new { Search = search });
            }
        }
        public async Task<Event> GetEventSingle(int idEvent, string? search) 
        {
            if (string.IsNullOrEmpty(search)) search = "";

            using (var connection = new SqlConnection(_connectionString))
            {
                await connection.OpenAsync();
                Event eventGet = await connection.QueryFirstOrDefaultAsync<Event>(@"EXEC dbo.Event_Get @EventId = @idEvent, @Search = @Search", new { idEvent = idEvent.ToString(), Search = search });
                if (eventGet != null)
                {
                    eventGet.Attendees = await connection.QueryAsync<EventRegistration>(@"EXEC dbo.EventRegistration_Get @EventId = @idEvent, @Search = @Search", new { idEvent = idEvent.ToString(), Search = search });
                }
                return eventGet;
            }
        }
        public async Task<IEnumerable<EventRegistration>> GetEventRegistrations(int? eventId, string? search)
        {
            using (var connection = new SqlConnection(_connectionString))
            {
                await connection.OpenAsync();
                if (string.IsNullOrEmpty(search))
                {
                    return await connection.QueryAsync<EventRegistration>(@"EXEC [dbo].[EventRegistration_Get] @EventId = @eventId", new { EventId = eventId.ToString() });
                }
                else
                {
                    return await connection.QueryAsync<EventRegistration>(@"EXEC [dbo].[EventRegistration_Get] @EventId = @eventId, @Search = @search", new { EventId = eventId.ToString(), Search = search });
                }
            }

        }
        public async Task<IEnumerable<EventStatusList>> EventStatusListGet()
        {
            using (var connection = new SqlConnection(_connectionString))
            {
                await connection.OpenAsync();
                return await connection.QueryAsync<EventStatusList>(@"EXEC dbo.EventStatus_Get");
            }
        }

        public async Task<bool> AttendeeAuthorized(int EventId, string UserId)
        {
            using (var connection = new SqlConnection(_connectionString))
            {
                await connection.OpenAsync();
                return await connection.QueryFirstOrDefaultAsync<bool>(@"EXEC dbo.User_Authorized @EventId = @idEvent, @UserId = @idUser", new { idEvent = EventId, idUser = UserId });
            }
        }

        public async Task<Event> PostNewEvent(EventPostFullRequest newEventRequest)
        {
            using (var connection = new SqlConnection(_connectionString))
            {
                await connection.OpenAsync();
                return await connection.QueryFirstAsync<Event>(@"EXEC dbo.Event_Post @eventTitle = @EventTitle, @eventDescription = @EventDescription,@coordinatorId = @CoordinatorId,@coordinatorEmail = @CoordinatorEmail, @eventDate = @EventDate,@eventStatusId = @EventStatusId", newEventRequest);
            }
        }

        public async Task<EventRegistration> PostRegistration(EventRegistration newEventRegistration)
        {
            using (var connection = new SqlConnection(_connectionString))
            {
                await connection.OpenAsync();
                var newReg = await connection.QueryFirstAsync<EventRegistration>(@"EXEC [dbo].[EventRegistration_Put] @EventId = @eventId, @UserId = @attendeeId, @UserEmail = @attendeeEmail, @UserName = @attendeeName, @AttendeeStatusId = @attendeeStatusId, @RequestComment = @requestComment, @RequestReply = @requestReply", newEventRegistration);
                return newReg;
            }
        }
    }
}

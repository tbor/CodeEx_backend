using System;
using System.Security.Claims;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using CodeEx_DSE.Data;

namespace CodeEx_DSE.Authorization
{
	public class MustBeEventCoordinatorHandler : AuthorizationHandler<MustBeEventCoordinatorRequirement>
	{
		private readonly IDataRepository _dataRepository;
		private readonly IHttpContextAccessor _httpContextAccessor;

		public MustBeEventCoordinatorHandler(IDataRepository dataRepository, IHttpContextAccessor httpContextAccessor)
		{
			_dataRepository = dataRepository;
			_httpContextAccessor = httpContextAccessor;            
        }

        protected async override Task HandleRequirementAsync(AuthorizationHandlerContext context, MustBeEventCoordinatorRequirement requirement)
		{
            // check that the user is authenticated
            if (!context.User.Identity.IsAuthenticated)
            {
                context.Fail();
                return;
            }

            var actionValue = _httpContextAccessor.HttpContext.Request.RouteValues["action"];
            var userId = context.User.FindFirst(ClaimTypes.NameIdentifier).Value;

            switch (actionValue)
            {
                case "UpdateRegistration":
                    var eventId = _httpContextAccessor.HttpContext.Request.RouteValues["eventId"];
                    int eventIdAsInt = Convert.ToInt32(eventId);
                    // get the event from the data repository; if the event can't be found go to the next piece of middleware
                    var thisEvent = await _dataRepository.GetEventSingle(eventIdAsInt, "");
                    if (thisEvent == null || thisEvent.CoordinatorId != userId)
                    {
                        context.Fail();
                        return;
                    }
                    break;
                case "PostEvent":
                    // get the event from the data repository; if the event can't be found go to the next piece of middleware
                    var thisUser = await _dataRepository.GetUserSingle(userId);
                    if (thisUser == null || !thisUser.isCoordinator)
                    {
                        context.Fail();
                        return;
                    }
                    break;
            }

            // return success
            context.Succeed(requirement);
        }
    }

}

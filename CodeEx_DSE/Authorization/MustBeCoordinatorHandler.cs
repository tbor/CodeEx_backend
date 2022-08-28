using System;
using System.Security.Claims;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using CodeEx_DSE.Data;
using CodeEx_DSE.Data.Models;

namespace CodeEx_DSE.Authorization
{
    public class MustBeCoordinatorHandler : AuthorizationHandler<MustBeCoordinatorRequirement>
    {
        private readonly IDataRepository _dataRepository;
        private readonly IHttpContextAccessor _httpContextAccessor;
        private readonly string _route;
        public MustBeCoordinatorHandler(IDataRepository dataRepository, IHttpContextAccessor httpContextAccessor)
        {
            _dataRepository = dataRepository;
            _httpContextAccessor = httpContextAccessor;
            var eventId = _httpContextAccessor.HttpContext.Request.RouteValues["eventId"];
            var actionValue = _httpContextAccessor.HttpContext.Request.RouteValues["action"];
        }

        protected async override Task HandleRequirementAsync(AuthorizationHandlerContext context, MustBeCoordinatorRequirement requirement)
        {

            var eventId = _httpContextAccessor.HttpContext.Request.RouteValues["eventId"];

            // check that the user is authenticated
            if (!context.User.Identity.IsAuthenticated)
            {
                context.Fail();
                return;
            }

            var userId = context.User.FindFirst(ClaimTypes.NameIdentifier).Value;

            // get the event from the data repository; if the event can't be found go to the next piece of middleware
            var thisUser = await _dataRepository.GetUserSingle(userId);
            if (thisUser == null || !thisUser.isCoordinator)
            {
                context.Fail();
                return;
            }

            // return success
            context.Succeed(requirement);

        }

    }
}

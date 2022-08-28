using Microsoft.AspNetCore.Authorization;
namespace CodeEx_DSE.Authorization
{
    public class MustBeCoordinatorRequirement : IAuthorizationRequirement
    {
        public MustBeCoordinatorRequirement()
        {

        }
    }
}

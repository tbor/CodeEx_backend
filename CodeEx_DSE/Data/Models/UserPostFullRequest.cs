namespace CodeEx_DSE.Data.Models
{
    public class UserPostFullRequest
    {
        public string userId { get; set; }
        public string userEmail { get; set; }
        public string userName { get; set; }
        public bool isCoordinator { get; set; }
    }
}

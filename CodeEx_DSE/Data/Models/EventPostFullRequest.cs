namespace CodeEx_DSE.Data.Models
{    public class EventPostFullRequest
    {
        public string EventTitle { get; set; }
        public string EventDescription { get; set; }
        public string CoordinatorId { get; set; }
        public string CoordinatorEmail { get; set; }
        public DateTime EventDate { get; set; }
        public int EventStatusId { get; set; }
    }
}

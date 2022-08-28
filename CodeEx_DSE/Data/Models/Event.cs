namespace CodeEx_DSE.Data.Models
{
    public class Event
    {
        public int EventId { get; set; }
        public string EventTitle { get; set; }
        public string EventDescription { get; set; }
        public string CoordinatorId { get; set; }
        public string CoordinatorName { get; set; }
        public DateTime EventDate { get; set; }
        public int EventStatusId { get; set; }
        public string EventStatus { get; set; }
        public IEnumerable<EventRegistration> Attendees { get; set; }
    }
}

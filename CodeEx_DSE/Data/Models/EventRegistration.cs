namespace CodeEx_DSE.Data.Models
{
    public class EventRegistration
    {
        public int RegistrationId { get; set; }
        public int EventID { get; set; }
        public string AttendeeId { get; set; }
        public string AttendeeEmail { get; set; }
        public string AttendeeName { get; set; }
        public string RequestComment { get; set; }
        public string RequestReply { get; set; }
        public int AttendeeStatusId { get; set; }
        public string AttendeeStatus { get; set; }
        public string created { get; set; }
        public bool Authorized { get; set; }
        public bool Rejected { get; set; }
        public bool Attended { get; set; }
        public bool Hold { get; set; }
    }
}

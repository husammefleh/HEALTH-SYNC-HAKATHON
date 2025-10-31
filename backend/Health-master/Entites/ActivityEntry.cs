namespace Entites
{
    public class ActivityEntry
    {
        public int Id { get; set; }
        public int UserId { get; set; }
        public string ActivityType { get; set; } = string.Empty;
        public double Duration { get; set; }
        public double CaloriesBurned { get; set; }
        public DateTime Date { get; set; }

        public User? User { get; set; }
    }
}

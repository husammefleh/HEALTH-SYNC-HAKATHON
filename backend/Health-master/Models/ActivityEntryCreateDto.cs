namespace Models
{
    public class ActivityEntryCreateDto
    {
        public string ActivityType { get; set; } = string.Empty;
        public double Duration { get; set; }
        public double CaloriesBurned { get; set; }
        public DateTime Date { get; set; }
    }
}

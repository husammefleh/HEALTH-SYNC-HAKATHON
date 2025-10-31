namespace Models
{
    public class HealthReadingCreateDto
    {
        public double BloodPressure { get; set; }
        public double HeartRate { get; set; }
        public DateTime RecordedAt { get; set; }
    }
}

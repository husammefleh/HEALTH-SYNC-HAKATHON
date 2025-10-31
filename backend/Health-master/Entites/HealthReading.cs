namespace Entites
{
    public class HealthReading
    {
        public int Id { get; set; }
        public int UserId { get; set; }
        public double BloodPressure { get; set; }
        public double HeartRate { get; set; }
        public DateTime RecordedAt { get; set; }

        public User? User { get; set; }
    }
}

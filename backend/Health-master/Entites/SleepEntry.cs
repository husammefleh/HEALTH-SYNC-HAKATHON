namespace Entites
{
    public class SleepEntry
    {
        public int Id { get; set; }
        public int UserId { get; set; }
        public double HoursSlept { get; set; }
        public DateTime SleepDate { get; set; }

        public User? User
        {
            get; set;
        }
    }
}

namespace Entites
{
    public class UserProfile
    {
        public int Id { get; set; }
        public int UserId { get; set; }
        public string Gender { get; set; } = string.Empty;
        public DateTime DateOfBirth { get; set; }
        public double Height { get; set; }
        public double Weight { get; set; }

        public User? User { get; set; }
    }
}

namespace Models
{
    public class UserProfileCreateDto
    {
        public string Gender { get; set; } = string.Empty;
        public DateTime DateOfBirth { get; set; }
        public double Height { get; set; }
        public double Weight { get; set; }
    }
}

namespace Entites
{
    public class AppSettings
    {
        public int Id { get; set; }
        public int UserId { get; set; }
        public bool NotificationsEnabled { get; set; }
        public string Theme { get; set; } = "light";

        public User? User { get; set; }
    }
}

namespace Models
{
    public class AppSettingsCreateDto
    {
        public bool NotificationsEnabled { get; set; }
        public string Theme { get; set; } = "light";
    }
}

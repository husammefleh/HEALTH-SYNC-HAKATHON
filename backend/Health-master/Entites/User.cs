namespace Entites
{
    public class User
    {
        public int Id { get; set; }

        // Unique username or email (your choice, here we do both)
        public string Username { get; set; } = default!;
        public string Email { get; set; } = default!;

        // Store hashed password ONLY
        public string PasswordHash { get; set; } = default!;

        public UserProfile? Profile { get; set; }

        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    }
}

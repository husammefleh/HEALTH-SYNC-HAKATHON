using Entites;
using Microsoft.EntityFrameworkCore;

namespace Data
{
    public class ApplicationDbContext : DbContext
    {
        public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options) : base(options)
        {

        }

        public DbSet<User> User { get; set; }
        public DbSet<ActivityEntry> ActivityEntry { get; set; }
        public DbSet<AppSettings> AppSettings { get; set; }
        public DbSet<FoodEntry> FoodEntry { get; set; }
        public DbSet<HealthReading> HealthReading { get; set; }
        public DbSet<MedicineEntry> MedicineEntry { get; set; }
        public DbSet<SleepEntry> SleepEntry { get; set; }
        public DbSet<UserProfile> UserProfile { get; set; }
    }
}

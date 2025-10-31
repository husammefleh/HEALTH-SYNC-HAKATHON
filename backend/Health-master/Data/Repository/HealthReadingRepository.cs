using Data.Repository.IRepository;
using Entites;

namespace Data.Repository
{
    public class HealthReadingRepository : Repository<HealthReading>, IHealthReadingRepositery
    {
        private ApplicationDbContext _db;

        public HealthReadingRepository(ApplicationDbContext db) : base(db)
        {
            _db = db;
        }

        public void Save()
        {
            _db.SaveChanges();
        }

        public void Update(HealthReading obj)
        {
            _db.HealthReading.Update(obj);
        }
    }
}

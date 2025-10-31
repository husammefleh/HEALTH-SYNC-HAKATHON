using Data.Repository.IRepository;
using Entites;

namespace Data.Repository
{
    public class SleepEntryRepository : Repository<SleepEntry>, ISleepEntryRepository
    {
        private ApplicationDbContext _db;

        public SleepEntryRepository(ApplicationDbContext db) : base(db)
        {
            _db = db;
        }

        public void Save()
        {
            _db.SaveChanges();
        }

        public void Update(SleepEntry obj)
        {
            _db.SleepEntry.Update(obj);
        }
    }
}

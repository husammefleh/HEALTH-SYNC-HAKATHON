using Data.IRepository;
using Entites;

namespace Data.Repository
{
    public class ActivityEntryRepository : Repository<ActivityEntry>, IActivityEntryRepository
    {
        private ApplicationDbContext _db;

        public ActivityEntryRepository(ApplicationDbContext db) : base(db)
        {
            _db = db;
        }

        public void Save()
        {
            _db.SaveChanges();
        }

        public void Update(ActivityEntry obj)
        {
            _db.ActivityEntry.Update(obj);
        }
    }
}

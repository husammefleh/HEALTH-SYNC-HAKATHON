using Data.IRepository;
using Entites;

namespace Data.Repository
{
    public class AppSettingsRepository : Repository<AppSettings>, IAppSettingsRepository
    {
        private ApplicationDbContext _db;

        public AppSettingsRepository(ApplicationDbContext db) : base(db)
        {
            _db = db;
        }

        public void Save()
        {
            _db.SaveChanges();
        }

        public void Update(AppSettings obj)
        {
            _db.AppSettings.Update(obj);
        }
    }
}

using Data.Repository.IRepository;
using Entites;

namespace Data.Repository
{
    public class MedicineEntryRepository : Repository<MedicineEntry>, IMedicineEntryRepository
    {
        private ApplicationDbContext _db;

        public MedicineEntryRepository(ApplicationDbContext db) : base(db)
        {
            _db = db;
        }

        public void Save()
        {
            _db.SaveChanges();
        }

        public void Update(MedicineEntry obj)
        {
            _db.MedicineEntry.Update(obj);
        }
    }
}

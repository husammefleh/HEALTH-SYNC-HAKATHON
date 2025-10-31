using Data.IRepository;
using Entites;

namespace Data.Repository
{
    public class FoodEntryRepository : Repository<FoodEntry>, IFoodEntryRepository
    {
        private ApplicationDbContext _db;

        public FoodEntryRepository(ApplicationDbContext db) : base(db)
        {
            _db = db;
        }

        public void Save()
        {
            _db.SaveChanges();
        }

        public void Update(FoodEntry obj)
        {
            _db.FoodEntry.Update(obj);
        }
    }
}

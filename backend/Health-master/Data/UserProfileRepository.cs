using Data.Repository.IRepository;
using Entites;

namespace Data
{
    public class UserProfileRepository : Repository<UserProfile>, IUserProfileRepository
    {
        private ApplicationDbContext _db;

        public UserProfileRepository(ApplicationDbContext db) : base(db)
        {
            _db = db;
        }

        public void Save()
        {
            _db.SaveChanges();
        }

        public void Update(UserProfile obj)
        {
            _db.UserProfile.Update(obj);
        }
    }
}

using Data.IRepository;
using Entites;

namespace Data
{
    public class UserRepositery : Repository<User>, IUserRepository
    {
        private ApplicationDbContext _db;

        public UserRepositery(ApplicationDbContext db) : base(db)
        {
            _db = db;
        }

        public void Save()
        {
            _db.SaveChanges();
        }

        public void Update(User obj)
        {
            _db.User.Update(obj);
        }
    }
}

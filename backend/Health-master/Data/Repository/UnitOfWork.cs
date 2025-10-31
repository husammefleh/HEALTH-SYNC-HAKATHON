using Data.IRepository;
using Microsoft.EntityFrameworkCore;

namespace Data
{
    public class UnitOfWork : IUnitOfWork
    {
        private ApplicationDbContext _db;
        public IUserRepository User { get; private set; }

        public UnitOfWork(ApplicationDbContext db)
        {
            _db = db;
            User = new UserRepositery(_db);
        }

        public void Detach(object entity)
        {
            var entry = _db.Entry(entity);
            entry.State = EntityState.Detached;
        }
        public void Save()
        {
            _db.SaveChanges();
        }
    }
}

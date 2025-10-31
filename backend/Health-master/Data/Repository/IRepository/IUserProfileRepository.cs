using Data.IRepository;
using Entites;

namespace Data.Repository.IRepository
{
    public interface IUserProfileRepository : IRepository<UserProfile>
    {
        void Update(UserProfile obj);
        void Save();
    }
}

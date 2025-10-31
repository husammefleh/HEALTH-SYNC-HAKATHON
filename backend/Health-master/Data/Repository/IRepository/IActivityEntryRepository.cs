using Entites;

namespace Data.IRepository
{
    public interface IActivityEntryRepository : IRepository<ActivityEntry>
    {
        void Update(ActivityEntry obj);
        void Save();

    }
}

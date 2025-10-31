using Data.IRepository;
using Entites;

namespace Data.Repository.IRepository
{
    public interface ISleepEntryRepository : IRepository<SleepEntry>
    {
        void Update(SleepEntry obj);
        void Save();
    }
}

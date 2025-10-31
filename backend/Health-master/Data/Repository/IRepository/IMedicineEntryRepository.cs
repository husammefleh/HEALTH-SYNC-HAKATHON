using Data.IRepository;
using Entites;

namespace Data.Repository.IRepository
{
    public interface IMedicineEntryRepository : IRepository<MedicineEntry>
    {
        void Update(MedicineEntry obj);
        void Save();
    }
}

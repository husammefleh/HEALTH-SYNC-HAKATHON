using Data.IRepository;
using Entites;

namespace Data.Repository.IRepository
{
    public interface IHealthReadingRepositery : IRepository<HealthReading>
    {
        void Update(HealthReading obj);
        void Save();
    }
}

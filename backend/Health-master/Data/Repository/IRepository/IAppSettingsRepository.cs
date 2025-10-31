using Entites;

namespace Data.IRepository
{
    public interface IAppSettingsRepository : IRepository<AppSettings>
    {
        void Update(AppSettings obj);
        void Save();

    }
}

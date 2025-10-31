using Entites;

namespace Data.IRepository
{
    public interface IFoodEntryRepository : IRepository<FoodEntry>
    {
        void Update(FoodEntry obj);
        void Save();

    }
}

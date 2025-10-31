namespace Data.IRepository
{
    public interface IUnitOfWork
    {
        IUserRepository User { get; }

        void Detach(object entity);
        void Save();
    }
}

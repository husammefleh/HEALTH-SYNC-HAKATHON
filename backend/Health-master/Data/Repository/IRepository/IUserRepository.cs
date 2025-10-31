using Entites;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Data.IRepository
{
    public interface IUserRepository : IRepository<User>
    {
        void Update(User obj);
        void Save();

    }
}

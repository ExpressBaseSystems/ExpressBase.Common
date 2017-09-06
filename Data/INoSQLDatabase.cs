using System;
using System.Collections.Generic;
using System.Data.Common;
using System.Text;

namespace ExpressBase.Common.Data
{
    interface INoSQLDatabase
    {
        DbConnection GetNewConnection();
    }
}

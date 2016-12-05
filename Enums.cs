using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExpressBase.Common
{
    public enum DatabaseVendors
    {
        PGSQL,
        MYSQL,
        MSSQL,
        ORACLE,
        MONGODB,
    }

    public enum EbDatabases
    {
        EB_OBJECTS,
        EB_DATA,
        EB_LOGS,
        EB_ATTACHMENTS,
    }

    public enum StudioFormTypes
    {
        Desktop,
        Web,
        Mobile,
        UserControl
    }

    class Enums
    {
    }
}


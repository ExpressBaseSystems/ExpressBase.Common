using ExpressBase.Common.Messaging;
using System;
using System.Collections.Generic;
using System.Text;

namespace ExpressBase.Common.Data
{
    public interface IEbConnectionFactory
    {
        IDatabase ObjectsDB { get; }

        IDatabase DataDB { get; }

        IDatabase DataDBRO { get; }

        INoSQLDatabase FilesDB { get; }

        IDatabase LogsDB { get; }

        ISMSConnection SMSConnection { get; }
    }
}

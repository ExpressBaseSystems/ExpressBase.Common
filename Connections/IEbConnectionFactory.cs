using ExpressBase.Common.Connections;
using ExpressBase.Common.Messaging;
using System;
using System.Collections.Generic;
using System.Text;

namespace ExpressBase.Common.Data
{
    public interface IEbConnectionFactory
    {
        IDatabase DataDB { get; }

        IDatabase DataDBRO { get; }

        IDatabase DataDBRW { get; }

        IDatabase ObjectsDB { get; }

        IDatabase ObjectsDBRO { get; }

        IDatabase ObjectsDBRW { get; }

        List<INoSQLDatabase> FilesDB { get; }

        IDatabase LogsDB { get; }

        EbSmsConCollection SMSConnection { get; }

        List<IImageManipulate> ImageManipulate { get; }

        EbMailConCollection EmailConnection { get; }
    }
}

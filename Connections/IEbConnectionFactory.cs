using ExpressBase.Common.Connections;
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

        EbSmsConCollection SMSConnection { get; }

        IImageManipulate ImageManipulate { get; }

        EbSmtp Smtp { get; }
    }
}

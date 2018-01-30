using ExpressBase.Common.Messaging;
using System;
using System.Collections.Generic;
using System.Text;

namespace ExpressBase.Common.Data
{
    public interface IEbDbFactory
    {

    }

    public interface IEbInfraDbFactory : IEbDbFactory
    {
        IDatabase ObjectsDB { get; }

        IDatabase DataDB { get; }

        IDatabase DataDBRO { get; }

        INoSQLDatabase FilesDB { get; }

        IDatabase LogsDB { get; }

        ISMSService SMSService { get; }
    }

    public interface IEbTenantDbFactory : IEbDbFactory
    {
        IDatabase ObjectsDB { get; }

        IDatabase DataDB { get; }

        IDatabase DataDBRO { get; }

        INoSQLDatabase FilesDB { get; }

        ISMSService SMSService { get; }
    }
}

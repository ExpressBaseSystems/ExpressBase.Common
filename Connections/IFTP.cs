using System;
using System.Collections.Generic;
using System.Text;

namespace ExpressBase.Common.Connections
{
    public interface IFTP
    {
        byte[] Download(string Url);
    }
}

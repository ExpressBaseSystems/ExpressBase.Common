using Funq;
using ServiceStack;
using System;
using System.Collections.Generic;
using System.Text;

namespace ExpressBase.Common.ServiceClients
{
    public interface IEbStaticFileClient : IServiceClient { }

    public class EbStaticFileClient : JsonServiceClient, IEbStaticFileClient
    {
        public EbStaticFileClient()
        {
            this.BaseUri = Environment.GetEnvironmentVariable(EnvironmentConstants.EB_STATICFILESERVER_INT_URL);
        }

        public EbStaticFileClient(Container c)
        {
            this.BaseUri = Environment.GetEnvironmentVariable(EnvironmentConstants.EB_STATICFILESERVER_INT_URL);
            var req = HostContext.TryGetCurrentRequest();
            this.BearerToken = (req != null) ? req.Headers[HttpHeaders.Authorization].Replace("Bearer", string.Empty).Trim() : null;
        }
    }
}

using ServiceStack;
using Funq;
using System;

namespace ExpressBase.Common.ServiceClients
{

    public interface IEbServerEventClient : IServiceClient
    {
    }

    public class EbServerEventClient : JsonServiceClient, IEbServerEventClient
    {
        public EbServerEventClient(Container c)
        {
            this.BaseUri = Environment.GetEnvironmentVariable(EnvironmentConstants.EB_SERVEREVENTS_INT_URL);
            var req = HostContext.TryGetCurrentRequest();
            this.BearerToken = (req != null) ? req.Headers[HttpHeaders.Authorization] : null;
        }
    }
}
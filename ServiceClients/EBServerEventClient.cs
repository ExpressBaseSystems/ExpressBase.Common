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
            this.RefreshTokenUri = Environment.GetEnvironmentVariable(EnvironmentConstants.EB_GET_ACCESS_TOKEN_URL);
            var req = HostContext.TryGetCurrentRequest();

            if(req != null)
            {
                this.RefreshToken = (req.Headers["rToken"] != null) ?req.Headers["rToken"]: null;
                this.BearerToken = (req.Authorization != null) ? req.Authorization.Replace("Bearer", string.Empty).Trim() : null;
                this.Headers.Add("rToken", this.RefreshToken);
            }
        }
    }
}
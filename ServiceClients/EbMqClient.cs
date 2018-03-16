using ExpressBase.Common.EbServiceStack.ReqNRes;
using Funq;
using ServiceStack;
using System;
using System.Collections.Generic;
using System.Text;

namespace ExpressBase.Common.ServiceClients
{
    public interface IEbMqClient : IServiceClient
    {

    }

    public class EbMqClient : JsonServiceClient, IEbMqClient
    {
        public EbMqClient()
        {
            this.BaseUri = Environment.GetEnvironmentVariable(EnvironmentConstants.EB_MQ_URL);
            this.RefreshTokenUri = Environment.GetEnvironmentVariable(EnvironmentConstants.EB_GET_ACCESS_TOKEN_URL);
        }

        public EbMqClient(Container c)
        {

            this.BaseUri = Environment.GetEnvironmentVariable(EnvironmentConstants.EB_MQ_URL);
            this.RefreshTokenUri = Environment.GetEnvironmentVariable(EnvironmentConstants.EB_GET_ACCESS_TOKEN_URL);

            var req = HostContext.TryGetCurrentRequest();
            if (req != null)
            {
                this.RefreshToken = (req.Headers["rToken"] != null) ? req.Headers["rToken"] : null;
                this.BearerToken = (req.Authorization != null) ? req.Authorization.Replace("Bearer", string.Empty).Trim() : null;
                this.Headers.Add("rToken", this.RefreshToken);
            }
        }
    }
}
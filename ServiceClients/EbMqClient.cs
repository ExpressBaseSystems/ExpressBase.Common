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
        }

        public EbMqClient(Container c)
        {
            this.BaseUri = Environment.GetEnvironmentVariable(EnvironmentConstants.EB_MQ_URL);
            var req = HostContext.TryGetCurrentRequest();
            if(req != null )
            {
                this.BearerToken = req.Authorization.Replace("Bearer", string.Empty).Trim();
            }
            
        }
    }
}
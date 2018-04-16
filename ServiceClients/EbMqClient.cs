using ExpressBase.Common.Constants;
using ServiceStack;
using ServiceStack.Web;
using System;

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

            //this.BaseUri = "http://localhost:41700";
            //this.RefreshTokenUri = "http://localhost:41600/access-token";
        }

        //public EbMqClient(Container c)
        //{
        //    Console.WriteLine("Inside Mq Client Constructor");
        //    this.BaseUri = Environment.GetEnvironmentVariable(EnvironmentConstants.EB_MQ_URL);
        //    this.RefreshTokenUri = Environment.GetEnvironmentVariable(EnvironmentConstants.EB_GET_ACCESS_TOKEN_URL);
        //    try
        //    {
        //        var req = HostContext.GetCurrentRequest();
        //        if (req != null)
        //        {
        //            Console.WriteLine("Request Not Null");
        //            this.RefreshToken = (req.Headers["rToken"] != null) ? req.Headers["rToken"] : null;
        //            this.BearerToken = (req.Headers[HttpHeaders.Authorization] != null) ? req.Headers[HttpHeaders.Authorization].Replace("Bearer", string.Empty).Trim() : null;
        //            if (!(String.IsNullOrEmpty(this.RefreshToken)))
        //                this.Headers.Add("rToken", this.RefreshToken);
        //        }
        //        Console.WriteLine(String.Format("MQClient: \nBaseUri: {0}\nBearer Token: {1}\n RefreshToken: {2}\n Headers: {3}", this.BaseUri, this.BearerToken ,this.RefreshToken, this.Headers.ToJson()));
        //    }catch(Exception e)
        //    {
        //        Console.WriteLine("Exception: " + e.Message.ToString());
        //    }
            
        //}

        public void AddAuthentication(IRequest req)
        {
            try
            {
                if (req != null)
                {
                    this.RefreshToken = (req.Headers[CacheConstants.RTOKEN] != null) ? req.Headers[CacheConstants.RTOKEN] : null;
                    this.BearerToken = (req.Headers[HttpHeaders.Authorization] != null) ? req.Headers[HttpHeaders.Authorization].Replace(CacheConstants.BEARER, string.Empty).Trim() : null;
                    if (!(String.IsNullOrEmpty(this.RefreshToken)))
                        this.Headers.Add(CacheConstants.RTOKEN, this.RefreshToken);
                }
            }
            catch (Exception e)
            {
                Console.WriteLine("Exception: " + e.Message.ToString());
            }
        }
    }
}
using ServiceStack;
using Funq;
using System;
using ServiceStack.Web;

namespace ExpressBase.Common.ServiceClients
{

    public interface IEbServerEventClient : IServiceClient
    {
    }

    public class EbServerEventClient : JsonServiceClient, IEbServerEventClient
    {
        //public EbServerEventClient(Container c)
        //{
        //    Console.WriteLine("Inside Server Client Constructor");

        //    this.BaseUri = Environment.GetEnvironmentVariable(EnvironmentConstants.EB_SERVEREVENTS_INT_URL);
        //    this.RefreshTokenUri = Environment.GetEnvironmentVariable(EnvironmentConstants.EB_GET_ACCESS_TOKEN_URL);
        //    try
        //    {
        //        var req = HostContext.GetCurrentRequest();
        //        if (req != null)
        //        {
        //            Console.WriteLine("Request Not Null");
        //            this.RefreshToken = (req.Headers["rToken"] != null) ? req.Headers["rToken"] : null;
        //            this.BearerToken = (req.Headers[HttpHeaders.Authorization] != null) ? req.Headers[HttpHeaders.Authorization].Replace("Bearer", string.Empty).Trim() : null;
        //            if (!String.IsNullOrEmpty(this.RefreshToken))
        //                this.Headers.Add("rToken", this.RefreshToken);
        //        }
        //        Console.WriteLine(String.Format("ServerEventClient: \nBaseUri: {0}\nBearer Token: {1}\n RefreshToken: {2}\n Headers: {3}", this.BaseUri, this.BearerToken, this.RefreshToken, this.Headers.ToJson()));
        //    }
        //    catch (Exception e)
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
                    Console.WriteLine("Request Not Null");
                    this.RefreshToken = (req.Headers["rToken"] != null) ? req.Headers["rToken"] : null;
                    this.BearerToken = (req.Headers[HttpHeaders.Authorization] != null) ? req.Headers[HttpHeaders.Authorization].Replace("Bearer", string.Empty).Trim() : null;
                    if (!(String.IsNullOrEmpty(this.RefreshToken)))
                        this.Headers.Add("rToken", this.RefreshToken);
                }
                Console.WriteLine(String.Format("ServerEvent Client: \nBaseUri: {0}\nBearer Token: {1}\n RefreshToken: {2}\n Headers: {3}", this.BaseUri, this.BearerToken, this.RefreshToken, this.Headers.ToJson()));
            }
            catch (Exception e)
            {
                Console.WriteLine("Exception: " + e.Message.ToString());
            }
        }
    }
}
﻿using ExpressBase.Common.Constants;
using ServiceStack;
using ServiceStack.Web;
using System;
using System.Collections.Generic;
using System.Text;

namespace ExpressBase.Common.ServiceClients
{
    public interface IEbAuthClient :IServiceClient
    {
        void AddAuthentication(IRequest req);
    }
    public class EbAuthClient : JsonServiceClient, IEbAuthClient
    {
        public EbAuthClient()
        {
            this.BaseUri = Environment.GetEnvironmentVariable(EnvironmentConstants.EB_AUTH_EXT_URL);
            this.RefreshTokenUri = Environment.GetEnvironmentVariable(EnvironmentConstants.EB_GET_ACCESS_TOKEN_URL);

            //this.BaseUri = "http://localhost:41000";
            //this.RefreshTokenUri = "http://localhost:41000/access-token";
        }

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
					if (!(String.IsNullOrEmpty(req.Headers[TokenConstants.SSE_SUBSCRIP_ID])))
						this.Headers.Add(TokenConstants.SSE_SUBSCRIP_ID, req.Headers[TokenConstants.SSE_SUBSCRIP_ID]);
				}
            }
            catch (Exception e)
            {
                Console.WriteLine("Exception: " + e.Message.ToString());
            }
        }
    }
}

using ExpressBase.Common.Connections;
using ServiceStack.Configuration;
using System;
using System.Collections.Generic;
using System.Text;

namespace ExpressBase.Common.Data
{
    public class MobileAppConnection
    {
        public string AzureNFHubName { get; set; }
        public string AzureNFConnection { get; set; }
        public string AndroidAppSignInKey { get; set; }
        public string AndroidAppURL { get; set; }
        public MobileAppConnection(MobileConfig Config) 
        {
            this.AzureNFConnection = Config.AzureNFConnection;
            this.AzureNFHubName = Config.AzureNFHubName;
            this.AndroidAppSignInKey = Config.AndroidAppSignInKey;
            this.AndroidAppURL = Config.AndroidAppURL;
        }
    }
}

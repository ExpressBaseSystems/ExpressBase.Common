using ExpressBase.Common.Connections;
using System;
using System.Collections.Generic;
using System.Text;

namespace ExpressBase.Common.Data
{
    public class EbMaps
    {
        public int ConId { get; set; }
        public string Apikey { get; set; }
        public virtual MapVendors Vendor { get; set; }
        public virtual MapType Type { get; set; }
    }


    public class EbGoogleMap : EbMaps
    {
        public override MapType Type { get { return MapType.COMMON; } }

        public override  MapVendors Vendor { get { return MapVendors.GOOGLEMAP; } }

        public EbGoogleMap(EbIntegrationConf conf)
        {
            this.Apikey = (conf as EbGoogleMapConfig).ApiKey;
            this.ConId = (conf as EbGoogleMapConfig).Id;
        }
    }

   
}

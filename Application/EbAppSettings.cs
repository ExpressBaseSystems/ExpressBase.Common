using System;
using System.Collections.Generic;
using System.Runtime.Serialization;
using System.Text;

namespace ExpressBase.Common.Application
{
    public class EbAppSettings
    {

    }

    [DataContract]
    public class EbBotSettings : EbAppSettings
    {
        [DataMember(Order = 1)]
        public string WelcomeMessage { get; set; }

        [DataMember(Order = 2)]
        public string ThemeColor { get; set; }

        [DataMember(Order = 3)]
        public string DpUrl { get; set; }

        [DataMember(Order = 4)]
        public string Name { get; set; }


		[DataMember(Order = 5)]
		public  Dictionary<string, string> CssContent { get; set; }

		public EbBotSettings() {Dictionary<string, string> CssContent = new Dictionary<string, string>();}
    }

    public class DataImportMobile
    {
        public string TableName { set; get; }

        public string RefId { set; get; }
    }

    
    public class EbMobileSettings : EbAppSettings
    {
        public List<DataImportMobile> DataImport { set; get; }

        public EbMobileSettings()
        {
            this.DataImport = new List<DataImportMobile>();
        }
    }

    [DataContract]
    public class EbWebSettings : EbAppSettings
    {

    }
}

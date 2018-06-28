using System;
using System.Collections.Generic;
using System.Runtime.Serialization;
using System.Text;

namespace ExpressBase.Objects.ObjectContainers
{
	[DataContract]
	public class EbBotSettings
	{
		[DataMember(Order = 1)]
		public string WelcomeMessage { get; set; }

		[DataMember(Order = 2)]
		public string ThemeColor { get; set; }

		[DataMember(Order = 3)]
		public string DpUrl { get; set; }

		public EbBotSettings(){}
    }
}

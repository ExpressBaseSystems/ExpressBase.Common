using ExpressBase.Common;
using System;
using System.Collections.Generic;
using System.Text;

namespace ExpressBase.Security.Core
{
    public class EbRole
    {
        public int Id { get; set; }
        public string Name { get; set; }
		public string Description { get; set; }
	}

	public class EbUserGroups
	{
		public int Id { get; set; }
		public string Name { get; set; }
		public string Description { get; set; }
	}
}

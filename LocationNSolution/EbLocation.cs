﻿using System;
using System.Collections.Generic;
using System.Text;

namespace ExpressBase.Common.LocationNSolution
{
    public class EbLocation
    {
        public int LocId { get; set; }

        public string LongName { get; set; }

        public string ShortName { get; set; }

        public Dictionary<string, string> Meta { get; set; }

        public string Img { get; set; }
    }

    public class Eb_Solution
    {
        public string InternalSolutionID { get; set; }

        public string ExternalSolutionID { get; set; }

        public string SolutionName { get; set; }

        public int NumberOfUsers { get; set; }

        public string Description { get; set; }

        public string DateCreated { get; set; }

        public Dictionary<string, EbLocation> LocationCollection { get; set; }
    }

    public class EbLocationConfig
    {
        public string KeyId { get; set; }

        public string Name { get; set; }

        public string Isrequired { get; set; }
    }
}
using System;
using System.Collections.Generic;
using System.Text;

namespace ExpressBase.Common.LocationNSolution
{
    public class Eb_Location
    {
        public int LocId { get; set; }

        public string LongName { get; set; }

        public string ShortName { get; set; }

        public string Meta { get; set; }

        public string Img { get; set; }
    }

    public class Eb_Solution
    {
        public string InternalSolutionID { get; set; }

        public string ExternalSolutionID { get; set; }

        public string SolutionName { get; set; }

        public int NumberOfUsers { get; set; }

        public List<Eb_Location> LocationCollection { get; set; }
    }

    public class Eb_LocationConfig
    {
        public string KeyId { get; set; }

        public string Name { get; set; }

        public string Isrequired { get; set; }
    }
}

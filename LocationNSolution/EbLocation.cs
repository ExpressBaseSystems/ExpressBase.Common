using System;
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
        public string SolutionID { get; set; }

        public string SolutionName { get; set; }

        public int NumberOfUsers { get; set; }

        public string Description { get; set; }

        public string DateCreated { get; set; }

        public Dictionary<int, EbLocation> Locations { get; set; }

        public List<EbLocationCustomField> LocationConfig { get; set; }
    }

    public class EbLocationCustomField
    {
        public string Id { get; set; }

        public string Name { get; set; }

        public bool IsRequired { get; set; }

        public string Type { get; set; }
    }
}

using System;
using System.Collections.Generic;
using System.Text;

namespace ExpressBase.Common.LocationNSolution
{
    public class EbLocation
    {
        public int LocId { get; set; }

        public int TypeId { get; set; }

        public string TypeName { get; set; }

        public bool IsGroup { get; set; }

        public int ParentId { get; set; }

        public string LongName { get; set; }

        public string ShortName { get; set; }

        public string Logo { get; set; }

        public string WeekHoliday1 { get; set; }

        public string WeekHoliday2 { get; set; }

        public Dictionary<int, EbLocation> Children { get; set; }

        public Dictionary<string, string> Meta { get; set; }

        public string this[string title]
        {
            get
            {
                if (title == "LongName")
                    return LongName;
                else if (title == "ShortName")
                    return ShortName;
                else if (title == "Logo")
                    return Logo;
                else
                {
                    if (Meta.ContainsKey(title))
                        return Meta[title];
                    else
                        return string.Empty;
                }
            }
        }
    }

    public class Eb_Solution
    {
        public string SolutionID { get; set; }

        public string ExtSolutionID { get; set; }

        public string SolutionName { get; set; }

        public int NumberOfUsers { get; set; }

        public string Description { get; set; }

        public string DateCreated { get; set; }

        public Dictionary<int, EbLocation> Locations { get; set; }

        public Dictionary<int, EbLocation> LocationTree { get; set; }

        public List<EbLocationCustomField> LocationConfig { get; set; }

        public PricingTiers PricingTier { get; set; }

        public bool IsVersioningEnabled { get; set; }

        public Dictionary<int, string> Users { get; set; }

        public int PlanUserCount { get; set; }

        public SolutionSettings SolutionSettings { get; set; }


        public Eb_Solution()
        {
            Locations = new Dictionary<int, EbLocation>();
        }
    }

    public class SolutionSettings
    {
        public String SignupFormRefid { get; set; }

        public List<EbProfileUserType> UserTypeForms { get; set; }
    }


    public class EbLocationCustomField
    {
        public string Id { get; set; }

        public string Name { get; set; }

        public string DisplayName { get; set; }

        public bool IsRequired { get; set; }

        public string Type { get; set; }
    }

    public class EbProfileUserType
    {
        public int Id { get; set; }

        public String Name { get; set; }

        public string RefId { get; set; }
    }

    public class EbLocationType
    {
        public int Id { get; set; }

        public String Type { get; set; }
    }
}

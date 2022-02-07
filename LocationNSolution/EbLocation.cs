using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using ExpressBase.Security;

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

        public EbFinancialYears FinancialYears { get; set; }

        public PricingTiers PricingTier { get; set; }

        public bool IsVersioningEnabled { get; set; }

        public bool Is2faEnabled { get; set; }

        public Dictionary<int, string> Users { get; set; }

        public int PlanUserCount { get; set; }

        public string OtpDelivery2fa { get; set; }

        public bool IsOtpSigninEnabled { get; set; }

        public string OtpDeliverySignin { get; set; }

        public SolutionSettings SolutionSettings { get; set; }

        public SolutionType SolutionType { get; set; }

        public string PrimarySolution { get; set; }

        public bool IsEmailIntegrated { get; set; }

        public bool IsSmsIntegrated { get; set; }

        public Eb_Solution()
        {
            Locations = new Dictionary<int, EbLocation>();
        }

        public bool GetMobileSettings(out MobileAppSettings settings)
        {
            settings = null;

            if (SolutionSettings != null && SolutionSettings.MobileAppSettings != null)
            {
                settings = SolutionSettings.MobileAppSettings;
                return true;
            }
            return false;
        }

        public List<EbLocation> GetLocationsByUser(User user)
        {
            List<EbLocation> locations = new List<EbLocation>();

            if (this.Locations == null || this.Locations.Count <= 0)
                return locations;

            List<EbLocation> allLocations = this.Locations.Select(kvp => kvp.Value).ToList();

            try
            {
                if (user.IsAdmin())
                {
                    locations.AddRange(allLocations);
                }
                else if (user.LocationIds == null || user.LocationIds.Count > 0)
                {
                    if (user.LocationIds.Contains(-1))
                        locations.AddRange(allLocations);
                    else
                    {
                        foreach (int locid in user.LocationIds)
                        {
                            if (this.Locations.TryGetValue(locid, out EbLocation value))
                            {
                                locations.Add(value);
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("Unknown error occured while getting locations by user");
                Console.WriteLine(ex.Message + ", STACKTRACE : " + ex.StackTrace);
            }
            return locations;
        }
    }

    public class SolutionSettings
    {
        public string SignupFormRefid { get; set; }

        public List<EbProfileUserType> UserTypeForms { get; set; }

        public MobileAppSettings MobileAppSettings { get; set; }

        public EbWebFormSettings WebSettings { get; set; }

        public EbSystemColumns SystemColumns { get; set; }

        [OnDeserialized]
        public void OnDeserialized(StreamingContext context)
        {
            if (SystemColumns == null || SystemColumns.Count == 0)
                SystemColumns = new EbSystemColumns(EbSysCols.Values);
            else
                SystemColumns = new EbSystemColumns(EbSysCols.GetFixed(SystemColumns));
        }
    }

    public class EbFinancialYears
    {
        public EbFinancialYears()
        {
            this.List = new List<EbFinancialYear>();
        }

        public List<EbFinancialYear> List { get; set; }

        public int Current { get; set; }
        public bool SysUser { get; set; }
    }

    public class EbFinancialYear
    {
        public int Id { get; set; }
        public DateTime FyStart { get; set; }
        public DateTime FyEnd { get; set; }
        public DateTime ActStart { get; set; }
        public DateTime ActEnd { get; set; }
        public bool Locked { get; set; }
        public List<int> LocIds { get; set; }

        public string FyStart_s { get; set; }
        public string FyEnd_s { get; set; }
        public string ActStart_s { get; set; }
        public string ActEnd_s { get; set; }
        public string FyStart_sl { get; set; }
        public string FyEnd_sl { get; set; }
        public string ActStart_sl { get; set; }
        public string ActEnd_sl { get; set; }
    }

    public class MobileAppSettings
    {
        public string SignUpPageRefId { set; get; }

        public List<EbProfileUserType> UserTypeForms { get; set; }

        public bool MaintenanceMode { get; set; }

        public MobileAppSettings()
        {
            UserTypeForms = new List<EbProfileUserType>();
        }

        public bool IsSignupEnabled()
        {
            return !string.IsNullOrEmpty(SignUpPageRefId);
        }

        public string GetProfileFormIdByUserType(int id)
        {
            return UserTypeForms.Find(x => x.Id == id)?.RefId;
        }

        public string IsMaintenanceMode()
        {
            return MaintenanceMode ? "checked" : "";
        }
    }

    public class EbWebFormSettings
    {

        public List<WebformStyleCont> CssContent { get; set; } = new List<WebformStyleCont>();
        public EbWebFormSettings(bool status)
        {
            if (status)
            {
                //Common styles
                List<WebformStyles> CommonStyles = new List<WebformStyles>();
                CommonStyles.Add(new WebformStyles() { Heading = "Form Container", Selector = ".form-buider-form", Css = CommonWebformStyleConst.Form_Buider_Form });
                CommonStyles.Add(new WebformStyles() { Heading = "Common Controls", Selector = ".ctrl-cover", Css = CommonWebformStyleConst.Ctrl_Cover });
                CommonStyles.Add(new WebformStyles() { Heading = "Label", Selector = ".eb-label-editable", Css = CommonWebformStyleConst.Eb_Label_Editable });
                CssContent.Add(new WebformStyleCont() { Heading = "Common", Selector = "", CssObj = CommonStyles });
                CommonStyles = new List<WebformStyles>();
                CommonStyles.Add(new WebformStyles() { Heading = "Label", Selector = ".eb-label-editable", Css = string.Empty });
                CommonStyles.Add(new WebformStyles() { Heading = "Input", Selector = "input", Css = string.Empty });
                CommonStyles.Add(new WebformStyles() { Heading = "Icon", Selector = ".input-group-addon", Css = string.Empty });
                CommonStyles.Add(new WebformStyles() { Heading = "Container", Selector = ".ctrl-cover", Css = string.Empty });
                CommonStyles.Add(new WebformStyles() { Heading = "Focus", Selector = ".Eb-ctrlContainer[ctype='TextBox'] .ctrl-cover:focus-within", Css = string.Empty });
                CssContent.Add(new WebformStyleCont() { Heading = "TextBox", Selector = "[ctype='TextBox']", CssObj = CommonStyles });
            }
        }
    }
    public class WebformStyleCont
    {
        public string Heading { get; set; }
        public string Selector { get; set; }
        public List<WebformStyles> CssObj { get; set; }
    }
    public class WebformStyles
    {
        public string Heading { get; set; }
        public string Selector { get; set; }
        public string Css { get; set; }
    }

    public class CommonWebformStyleConst
    {
        public const string Ctrl_Cover = @"
border: 1px solid var(--eb-bluishgray);
display: flex;
flex-flow: column;
position: relative;";

        public const string Form_Buider_Form = @"
 background:white;";
        public const string Eb_Label_Editable = @"
 background-color: transparent;";
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

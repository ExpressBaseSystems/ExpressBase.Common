﻿using System;
using System.Collections.Generic;
using System.Runtime.Serialization;
using System.Text;
using ExpressBase.Common.Constants;

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

        [DataMember(Order = 3)]
        public string Description { get; set; }

        [DataMember(Order = 5)]
        public string Name { get; set; }

        [DataMember(Order = 6)]
        public string AppIcon { get; set; }

        [DataMember(Order = 7)]
        public Dictionary<string, string> CssContent { get; set; } = new Dictionary<string, string>();

        [DataMember(Order = 8)]
        public AnonymousAuth Authoptions = new AnonymousAuth();

        [DataMember(Order = 9)]
        public BotProperty BotProp = new BotProperty();

        [DataMember(Order = 10)]
        public bool UserType_Internal { get; set; } = false;

        public EbBotSettings()
        {
            //////change CssContent.Count in bote and dev controller if any css Constant is added or removed
            CssContent.Add("BOT_HEADER_PART", BotConstants.BOT_HEADER_PART);
            CssContent.Add("BOT_HEADER_ICON_CONT", BotConstants.BOT_HEADER_ICON_CONT);
            CssContent.Add("BOT_HEADER_IMAGE", BotConstants.BOT_HEADER_IMAGE);
            CssContent.Add("BOT_HEADERSUBTEXT", BotConstants.BOT_HEADERSUBTEXT);
            CssContent.Add("BOT_APP_NAME", BotConstants.BOT_APP_NAME);
            CssContent.Add("BOT_IFRAME_CSS", BotConstants.BOT_IFRAME_CSS);
            CssContent.Add("BOT_CHAT_BUTTON", BotConstants.BOT_CHAT_BUTTON);
            CssContent.Add("BOT_IMAGE_CONT", BotConstants.BOT_IMAGE_CONT);
            CssContent.Add("BOT_BUTTON_IMAGE", BotConstants.BOT_BUTTON_IMAGE);
            CssContent.Add("BOT_CLOSE_BUTTON", BotConstants.BOT_CLOSE_BUTTON);
            CssContent.Add("BOT_MAXIMIZE_BUTTON", BotConstants.BOT_MAXIMIZE_BUTTON);
        }
    }

    public class DataImportMobile
    {
        public string TableName { set; get; }

        public string RefId { set; get; }

        public string DisplayName { set; get; }
    }

    public class EbApiMeta
    {
        public string RefId { set; get; }

        public string Name { set; get; }

        public string DisplayName { set; get; }

        public string Version { set; get; }
    }

    public class EbMobileSettings : EbAppSettings
    {
        public EbApiMeta MenuApi { set; get; }

        public List<DataImportMobile> DataImport { set; get; }

        public string DashBoardRefId { set; get; }

        public EbMobileSettings()
        {
            this.DataImport = new List<DataImportMobile>();
        }
    }

    [DataContract]
    public class EbWebSettings : EbAppSettings
    {

    }

    public class EbPosSettings : EbAppSettings
    {
        public List<DataImportMobile> DataImport { set; get; }

        public EbPosSettings()
        {
            this.DataImport = new List<DataImportMobile>();
        }
    }

    public class AnonymousAuth
    {
        public bool Fblogin { get; set; }
        public bool EmailAuth { get; set; }
        public bool PhoneAuth { get; set; }
        public bool UserName { get; set; }
        public string FbAppID { get; set; }
        public string FbAppVer { get; set; }
        public int LoginOpnCount { get; set; }
        public bool OTP_based { get; set; }
        public bool Password_based { get; set; }

        public AnonymousAuth()
        {
            Fblogin = false;
            EmailAuth = true;
            PhoneAuth = false;
            UserName = false;
            OTP_based = false;
            Password_based = false;
            FbAppID = "";
            FbAppVer = "";
            LoginOpnCount = 1;
        }
    }

    public class BotProperty
    {
        public bool EbTag { get; set; }
        public bool HeaderIcon { get; set; }
        public bool HeaderSubtxt { get; set; }
        public string Bg_value { get; set; }
        public string Bg_type { get; set; }
        public string AppFont { get; set; }
        public string AppFontSize { get; set; }
        public bool Use_Sol_logo { get; set; }
        public BotProperty()
        {
            EbTag = true;
            HeaderIcon = true;
            HeaderSubtxt = true;
            Use_Sol_logo = false;

        }
    }
}

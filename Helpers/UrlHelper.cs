using System;
using System.Collections.Generic;
using System.Text;

namespace ExpressBase.Common.Helpers
{
    public static class UrlHelper
    {
        public static string GetLogoPath(string Host)
        {
            if (Host?.Contains("safenetin") == true)
                return "/images/logo-safe.png";
            return "/images/EB_Logo-png.png";
        }

        public static string GetSmallLogoPath(string Host)
        {
            if (Host?.Contains("safenetin") == true)
                return "/images/logo-safe.png";
            return "/images/EB_Logo.png";
        }

        public static bool IsLogoVisible(string Host)
        {
            return !Host?.ToLower()?.Contains("oloi") == true;
        }

        public static string GetIconUrl(string Host)
        {
            if (Host?.ToLower()?.Contains("oloi") == true)
                return "/images/favicon_kdisc.ico";
            return "/images/favicon.ico";
        }

        public static string GetLoginPageDescription(string Host)
        {
            if (Host?.ToLower()?.Contains("oloi") == true)
                return "Kerala Development and Innovation Strategic Council (K-DISC)";
            return null;
        }

        public static string GetUserNameLabel(string Host)
        {
            if (Host?.ToLower()?.Contains("oloi") == true)
                return "Email";
            return "Email or Mobile";
        }

        public static string GetLiActiveClass(string Host, bool WithPwd)
        {
            if (Host?.ToLower()?.Contains("oloi") == true)
                return WithPwd ? string.Empty : "active";
            return WithPwd ? "active" : string.Empty;
        }

        public static string GetTabPaneActiveClass(string Host, bool WithPwd)
        {
            if (Host?.ToLower()?.Contains("oloi") == true)
                return WithPwd ? string.Empty : "active in";
            return WithPwd ? "active in" : string.Empty;
        }
    }
}

﻿using System;
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
            return !ContainsOloi(Host);
        }

        public static string GetIconUrl(string Host)
        {
            if (ContainsOloi(Host))
                return "/images/favicon_kdisc.ico";
            return "/images/favicon.ico";
        }

        public static string GetLoginPageDescription(string Host)
        {
            if (ContainsOloi(Host))
                return "Kerala Development and Innovation Strategic Council (K-DISC)";
            return null;
        }

        public static string GetUserNameLabel(string Host)
        {
            if (ContainsOloi(Host))
                return "Email";
            return "Email or Mobile";
        }

        public static string GetLiActiveClass(string Host, bool WithPwd)
        {
            if (ContainsOloi(Host))
                return WithPwd ? string.Empty : "active";
            return WithPwd ? "active" : string.Empty;
        }

        public static string GetTabPaneActiveClass(string Host, bool WithPwd)
        {
            if (ContainsOloi(Host))
                return WithPwd ? string.Empty : "active in";
            return WithPwd ? "active in" : string.Empty;
        }

        public static bool IsSupportButtonVisible(string Host)
        {
            return !ContainsOloi(Host);
        }

        public static bool ContainsOloi(string Host)
        {
            return Host?.ToLower()?.Contains("oloi") == true;
        }
    }
}

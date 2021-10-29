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
    }
}

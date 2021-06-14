using System;

namespace ExpressBase.Common.Singletons
{
    public sealed class BuildInfo
    {
        public static readonly string Version = DateTime.UtcNow.ToString("yMdHms");
    }
}

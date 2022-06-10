using ExpressBase.Common.Extensions;
using System.Reflection;

namespace ExpressBase.Common.Singletons
{
    public sealed class BuildInfo
    {
        public static readonly string Md5Version = Assembly.GetExecutingAssembly().GetName().Version.ToString().ToMD5Hash();
    }
}

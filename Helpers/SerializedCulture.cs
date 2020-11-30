using ExpressBase.Common.Application;
using ExpressBase.Objects;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Runtime.Serialization.Formatters.Binary;
using System.Text;

namespace ExpressBase.Common.Helpers
{
    public class SerializedCulture
    {
        public SerializedNumberFormatInfo NumberFormatInfo { get; set; }
        public SerializedDateTimeFormatInfo DateTimeFormatInfo { get; set; }

        public SerializedCulture Clone<SerializedCulture>()
        {
            using (var ms = new MemoryStream())
            {
                var formatter = new BinaryFormatter();
                formatter.Serialize(ms, this);
                ms.Position = 0;

                return (SerializedCulture)formatter.Deserialize(ms);
            }
        }
        public CultureInfo GetCultureInfo()
        {
            CultureInfo c = new CultureInfo("es-ES", false);
            this.NumberFormatInfo.PopulateIntoCultureInfo(c);
            this.DateTimeFormatInfo.PopulateIntoCultureInfo(c);
            return c;
        }
    }
}


namespace ExpressBase.Common
{

    public class AppWrapper
    {
        public int Id { set; get; }

        public string Name { set; get; }

        public int AppType { set; get; }

        public string Icon { set; get; }

        public string Description { set; get; }

        public string AppSettings { set; get; }

        public List<EbObject> ObjCollection { get; set; }

        //public string Title { get; set; }

        //public bool IsPublic { get; set; }
    }

    public class ExportPackage
    { 
        public ExportPackage()
        {
            Apps = new List<AppWrapper>();
        }
        public List<AppWrapper> Apps { get; set; }

        public PackageDataSets DataSet { get; set; }
    }

    public class PackageDataSets 
    {
        public EbDataSet FullExportTables { get; set; }
        public EbDataSet ConditionalExportTables { get; set; }
    }

    public class ExportPackageCollection
    {
        public string packName { get; set; }
        public string packDesc { get; set; }
        public string packIcon { get; set; }
        public string MasterSoln { get; set; }
        public Dictionary<int, List<string>> appColl { get; set; }
    }
}

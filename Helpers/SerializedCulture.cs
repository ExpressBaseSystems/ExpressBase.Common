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

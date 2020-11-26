using ExpressBase.Common.Objects;
using ExpressBase.Common.Structures;
using System;
using System.Collections.Generic;
using System.Text;

namespace ExpressBase.Common.Excel 
{
   //public class ExcelColumns
   // {
   //     public string Name { get; set; }

   //     //public string Label { get; set; }

   //     //public EbDbTypes DbType { get; set; }

   //     public string TableName { get; set; }
   // }
    public class ColumnsInfo
    {
        public string Name { get; set; }

        public string Label { get; set; }

        public EbDbTypes DbType { get; set; }

        public string TableName { get; set; }

        public string ControlType { get; set; }
    }
}

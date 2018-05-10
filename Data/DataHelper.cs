using ExpressBase.Common.Structures;
using System;
using System.Collections.Generic;
using System.Data.Common;
using System.Runtime.Serialization;
using System.Text;

namespace ExpressBase.Common.Data
{
    public class DataHelper
    {
       // public DbDataReader GetDataReader()
           //  {
            //var myDataSourceservice = base.ResolveService<DataSourceService>();
            //if (Report.DataSourceRefId != string.Empty)
            //{
            //    cresp = this.Redis.Get<DataSourceColumnsResponse>(string.Format("{0}_columns", Report.DataSourceRefId));
            //    if (cresp.IsNull)
            //        cresp = myDataSourceservice.Any(new DataSourceColumnsRequest { RefId = Report.DataSourceRefId });
            //    Report.DataColumns = (cresp.Columns.Count > 1) ? cresp.Columns[1] : cresp.Columns[0];
            //    dresp = myDataSourceservice.Any(new DataSourceDataRequest { RefId = Report.DataSourceRefId, Draw = 1, Start = 0, Length = 100 });
            //    Report.DataRow = dresp.Data;
            //}

      //  }

        public static IEnumerable<System.Data.Common.DbParameter> GetParams(EbConnectionFactory factory, bool isPaged, List<Param> reqParams, int iLimit, int iOffset)
        {
            if (isPaged)
            {
                if (reqParams == null)
                    reqParams = new List<Param>();

                var _dicLimit = new Param { Name = "limit" , Type = ((int)EbDbTypes.Int32).ToString(), Value = ((iLimit != -1) ? iLimit : 0).ToString()};
                var _dicOffset = new Param { Name = "offset", Type = ((int)EbDbTypes.Int32).ToString(), Value = iOffset.ToString() };

                reqParams.AddRange(new Param[] { _dicLimit, _dicOffset });
            }

            if (reqParams != null && reqParams.Count > 0)
            {
                foreach (Param param in reqParams)
                {
                    if(factory.ObjectsDB.Vendor == DatabaseVendors.PGSQL)
                        yield return factory.ObjectsDB.GetNewParameter(string.Format(":{0}", param.Name), (EbDbTypes)Convert.ToInt32(param.Type), param.Value);
                    else
                        yield return factory.ObjectsDB.GetNewParameter(string.Format("{0}", param.Name), (EbDbTypes)Convert.ToInt32(param.Type), param.Value);                      
                }
            }
        }
    }

    [DataContract]
    public class Param
    {
        public Param() { }

        [DataMember(Order = 1)]
        public string Name { get; set; }

        [DataMember(Order = 2)]
        public string Type { get; set; }

        [DataMember(Order = 3)]
        public string Value { get; set; }
    }
}

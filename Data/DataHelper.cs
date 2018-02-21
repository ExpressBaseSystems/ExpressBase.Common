﻿using ExpressBase.Common.Structures;
using System;
using System.Collections.Generic;
using System.Data.Common;
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

        public static IEnumerable<System.Data.Common.DbParameter> GetParams(EbConnectionFactory factory, bool isPaged, List<Dictionary<string, object>> reqParams, int iLimit, int iOffset)
        {
            if (isPaged)
            {
                var _dicLimit = new Dictionary<string, object>();
                _dicLimit.Add("name", "limit");
                _dicLimit.Add("type", ((int)EbDbTypes.Int32).ToString());
                if (iLimit != -1)
                    _dicLimit.Add("value", iLimit);
                else
                    _dicLimit.Add("value", DBNull.Value);

                var _dicOffset = new Dictionary<string, object>();
                _dicOffset.Add("name", "offset");
                _dicOffset.Add("type", ((int)EbDbTypes.Int32).ToString());
                _dicOffset.Add("value", iOffset.ToString());

                if (reqParams == null)
                    reqParams = new List<Dictionary<string, object>>();

                reqParams.AddRange(new Dictionary<string, object>[] { _dicLimit, _dicOffset });
            }

            if (reqParams != null)
            {
                foreach (Dictionary<string, object> param in reqParams)
                    yield return factory.ObjectsDB.GetNewParameter(string.Format("@{0}", param["name"]), (EbDbType)Convert.ToInt32(param["type"]), param["value"]);
            }
        }
    }
}

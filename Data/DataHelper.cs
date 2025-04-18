﻿using ExpressBase.Common.Objects;
using ExpressBase.Common.Objects.Attributes;
using ExpressBase.Common.Structures;
using Newtonsoft.Json;
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

        public static IEnumerable<DbParameter> GetParams(IDatabase db, bool isPaged, List<Param> reqParams, int iLimit, int iOffset)
        {
            if (isPaged)
            {
                if (reqParams == null)
                    reqParams = new List<Param>();

                var _dicLimit = new Param { Name = "limit", Type = ((int)EbDbTypes.Int32).ToString(), Value = ((iLimit != -1) ? iLimit.ToString() : 0.ToString()) };
                var _dicOffset = new Param { Name = "offset", Type = ((int)EbDbTypes.Int32).ToString(), Value = iOffset.ToString() };

                reqParams.RemoveAll(e => e.Name == "limit");
                reqParams.RemoveAll(e => e.Name == "offset");

                reqParams.AddRange(new Param[] { _dicLimit, _dicOffset });
            }

            if (reqParams != null && reqParams.Count > 0)
            {
                foreach (Param param in reqParams)
                {
                    if (param.ValueTo != null)
                    {
                        if (db.Vendor == DatabaseVendors.PGSQL)
                            yield return db.GetNewParameter(string.Format(":{0}", param.Name), (EbDbTypes)Convert.ToInt32(param.Type), param.ValueTo);
                        else
                            yield return db.GetNewParameter(string.Format("{0}", param.Name), (EbDbTypes)Convert.ToInt32(param.Type), param.ValueTo);
                    }
                }
            }
        }
    }

    public class Param
    {
        public Param() { }

        [DataMember(Order = 1)]
        public string Name { get; set; }

        [DataMember(Order = 2)]
        public string Type { get; set; }

        [DataMember(Order = 3)]
        public string Value { get; set; }

        [DataMember(Order = 4)]
        public dynamic ValueTo
        {
            get
            {
                if (Type == ((int)EbDbTypes.Decimal).ToString())
                    return Convert.ToDecimal(Value);
                else if (Type == ((int)EbDbTypes.Int16).ToString())
                    return Convert.ToInt16(Value);
                else if (Type == ((int)EbDbTypes.Int32).ToString())
                    return Convert.ToInt32(Value);
                else if (Type == ((int)EbDbTypes.Int64).ToString())
                    return Convert.ToInt64(Value);
                else if (Type == ((int)EbDbTypes.Date).ToString())
                    return Convert.ToDateTime(Value);
                else if (Type == ((int)EbDbTypes.DateTime).ToString())
                    return Convert.ToDateTime(Value);
                else if (Type == ((int)EbDbTypes.Boolean).ToString())
                    return Convert.ToBoolean(Value);
                else if (Type == ((int)EbDbTypes.String).ToString())
                    return (Value == null) ? string.Empty : Value;
                else if (Type == ((int)EbDbTypes.Time).ToString())
                    return TimeSpan.Parse(Value ?? "0");
                else
                    return Value;
            }
        }

        [DataMember(Order = 5)]
        public bool Required { set; get; } = true;

        [DataMember(Order = 6)]
        public string NameF { set; get; } //formatted name

        [DataMember(Order = 7)]
        public string ValueF { set; get; } //formatted value
    }

}

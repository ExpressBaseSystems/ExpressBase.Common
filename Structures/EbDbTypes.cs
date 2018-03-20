using ProtoBuf;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.OracleClient;
using System.Runtime.Serialization;
using System.Text;

namespace ExpressBase.Common.Structures
{
    [ProtoContract]
    public struct EbDbType
    {
        [ProtoMember(1)]
        public readonly int IntCode;

        public int VendorSpecificIntCode(DatabaseVendors vendor)
        {
            if ((DbType)this.IntCode == DbType.String)
            {
                if (vendor == DatabaseVendors.PGSQL)
                    return (int)NpgsqlTypes.NpgsqlDbType.Text;
                if (vendor == DatabaseVendors.ORACLE)
                    return (int)OracleType.VarChar;
            }
            else if ((DbType)this.IntCode == DbType.Decimal)
            {
                if (vendor == DatabaseVendors.PGSQL)
                    return (int)NpgsqlTypes.NpgsqlDbType.Double;
                if (vendor == DatabaseVendors.ORACLE)
                    return (int)OracleType.Double;
            }
            else if ((DbType)this.IntCode == DbType.Int32)
            {
                if (vendor == DatabaseVendors.PGSQL)
                    return (int)NpgsqlTypes.NpgsqlDbType.Integer;
                if (vendor == DatabaseVendors.ORACLE)
                    return (int)OracleType.Int32;
            }
            else if ((DbType)this.IntCode == DbType.Object)
            {
                if (vendor == DatabaseVendors.PGSQL)
                    return (int)NpgsqlTypes.NpgsqlDbType.Json;
                if (vendor == DatabaseVendors.ORACLE)
                    return (int)OracleType.Clob;
            }
            else if ((DbType)this.IntCode == DbType.Boolean)
            {
                if (vendor == DatabaseVendors.PGSQL)
                    return (int)NpgsqlTypes.NpgsqlDbType.Boolean;
                if (vendor == DatabaseVendors.ORACLE)
                    return (int)OracleType.VarChar;
            }
            else if ((DbType)this.IntCode == DbType.DateTime)
            {
                if (vendor == DatabaseVendors.PGSQL)
                    return (int)NpgsqlTypes.NpgsqlDbType.Date;
                if (vendor == DatabaseVendors.ORACLE)
                    return (int)OracleType.DateTime;
            }
            else if ((DbType)this.IntCode == DbType.Date)
            {
                if (vendor == DatabaseVendors.PGSQL)
                    return (int)NpgsqlTypes.NpgsqlDbType.Timestamp;
                if (vendor == DatabaseVendors.ORACLE)
                    return (int)OracleType.Timestamp;
            }
            else if ((DbType)this.IntCode == DbType.Time)
            {
                if (vendor == DatabaseVendors.PGSQL)
                    return (int)NpgsqlTypes.NpgsqlDbType.Time;
                if (vendor == DatabaseVendors.ORACLE)
                    return (int)OracleType.TimestampWithTZ;
            }
            else if ((DbType)this.IntCode == DbType.Int64)
            {
                if (vendor == DatabaseVendors.PGSQL)
                    return (int)NpgsqlTypes.NpgsqlDbType.Bigint;
                if (vendor == DatabaseVendors.ORACLE)
                    return (int)OracleType.Number;
            }
            else if ((DbType)this.IntCode == DbType.Int16)
            {
                if (vendor == DatabaseVendors.PGSQL)
                    return (int)NpgsqlTypes.NpgsqlDbType.Smallint;
                if (vendor == DatabaseVendors.ORACLE)
                    return (int)OracleType.Int16;
            }
            else if ((DbType)this.IntCode == DbType.Double)
            {
                if (vendor == DatabaseVendors.PGSQL)
                    return (int)NpgsqlTypes.NpgsqlDbType.Double;
                if (vendor == DatabaseVendors.ORACLE)
                    return (int)OracleType.Double;
            }
            else if ((DbType)this.IntCode == DbType.VarNumeric)
            {
                if (vendor == DatabaseVendors.PGSQL)
                    return (int)NpgsqlTypes.NpgsqlDbType.Numeric;
                if (vendor == DatabaseVendors.ORACLE)
                    return (int)OracleType.Number;
            }


            return this.IntCode;
        }

        public string VendorSpecificStringCode(DatabaseVendors vendor)
        {
            if ((DbType)this.IntCode == DbType.String)
            {
                if (vendor == DatabaseVendors.PGSQL)
                    return (NpgsqlTypes.NpgsqlDbType.Text).ToString();
                if (vendor == DatabaseVendors.ORACLE)
                    return (OracleType.Clob).ToString();
            }
            else if ((DbType)this.IntCode == DbType.Decimal)
            {
                if (vendor == DatabaseVendors.PGSQL)
                    return (NpgsqlTypes.NpgsqlDbType.Double).ToString();
                if (vendor == DatabaseVendors.ORACLE)
                    return (OracleType.Double).ToString();
            }
            else if ((DbType)this.IntCode == DbType.Int32)
            {
                if (vendor == DatabaseVendors.PGSQL)
                    return (NpgsqlTypes.NpgsqlDbType.Integer).ToString();
                if (vendor == DatabaseVendors.ORACLE)
                    return (OracleType.Number).ToString();
            }
            else if ((DbType)this.IntCode == DbType.Object)
            {
                if (vendor == DatabaseVendors.PGSQL)
                    return (NpgsqlTypes.NpgsqlDbType.Json).ToString();
                if (vendor == DatabaseVendors.ORACLE)
                    return (OracleType.Clob).ToString();
            }
            else if ((DbType)this.IntCode == DbType.Boolean)
            {
                if (vendor == DatabaseVendors.PGSQL)
                    return (NpgsqlTypes.NpgsqlDbType.Boolean).ToString();
                if (vendor == DatabaseVendors.ORACLE)
                    return (OracleType.VarChar).ToString();
            }
            else if ((DbType)this.IntCode == DbType.DateTime)
            {
                if (vendor == DatabaseVendors.PGSQL)
                    return (NpgsqlTypes.NpgsqlDbType.Date).ToString();
                if (vendor == DatabaseVendors.ORACLE)
                    return (OracleType.Timestamp).ToString();
            }
            else if ((DbType)this.IntCode == DbType.Date)
            {
                if (vendor == DatabaseVendors.PGSQL)
                    return (NpgsqlTypes.NpgsqlDbType.Timestamp).ToString();
                if (vendor == DatabaseVendors.ORACLE)
                    return (OracleType.Timestamp).ToString();
            }
            else if ((DbType)this.IntCode == DbType.Time)
            {
                if (vendor == DatabaseVendors.PGSQL)
                    return (NpgsqlTypes.NpgsqlDbType.Time).ToString();
                if (vendor == DatabaseVendors.ORACLE)
                    return (OracleType.TimestampLocal).ToString();
            }
            else if ((DbType)this.IntCode == DbType.Int64)
            {
                if (vendor == DatabaseVendors.PGSQL)
                    return (NpgsqlTypes.NpgsqlDbType.Bigint).ToString();
                if (vendor == DatabaseVendors.ORACLE)
                    return (OracleType.Number).ToString();
            }
            else if ((DbType)this.IntCode == DbType.Int16)
            {
                if (vendor == DatabaseVendors.PGSQL)
                    return (NpgsqlTypes.NpgsqlDbType.Smallint).ToString();
                if (vendor == DatabaseVendors.ORACLE)
                    return (OracleType.Number).ToString();
            }
            else if ((DbType)this.IntCode == DbType.Double)
            {
                if (vendor == DatabaseVendors.PGSQL)
                    return (NpgsqlTypes.NpgsqlDbType.Double).ToString();
                if (vendor == DatabaseVendors.ORACLE)
                    return (OracleType.Double).ToString();
            }
            else if ((DbType)this.IntCode == DbType.VarNumeric)
            {
                if (vendor == DatabaseVendors.PGSQL)
                    return (NpgsqlTypes.NpgsqlDbType.Numeric).ToString();
                if (vendor == DatabaseVendors.ORACLE)
                    return (OracleType.Number).ToString();
            }


            return this.IntCode.ToString();
        }

        public static explicit operator EbDbType(DbType v)
        {
            throw new NotImplementedException();
        }

        internal EbDbType(int i)
        {
            IntCode = i;    // 38 bytes max
        }

        public static explicit operator EbDbType(int i)
        {
            return EbDbTypes.Get(i);
        }

        public static explicit operator EbDbType(Int64 i)
        {
            return EbDbTypes.Get(Convert.ToInt32(i));
        }

        //int i = (int)o;
        public static explicit operator int(EbDbType o)
        {
            return o.IntCode;
        }

        public static bool operator ==(int i, EbDbType b)
        {
            return (i == b.IntCode);
        }

        public static bool operator !=(int i, EbDbType b)
        {
            return (i != b.IntCode);
        }

        public override string ToString()
        {
            return ((DbType)this.IntCode).ToString();
        }
    }

    public class EbDbTypes
    {
        public static EbDbType String;
        public static EbDbType Decimal;
        public static EbDbType Double;
        public static EbDbType Int16;
        public static EbDbType Int32;
        public static EbDbType Int64;
        public static EbDbType Json;
        public static EbDbType Boolean;
        public static EbDbType Date;
        public static EbDbType DateTime;
        public static EbDbType VarNumeric;
        public static EbDbType Time;

        public EbDbTypes()
        {

        }

        public EbDbTypes(DatabaseVendors vendor)
        {
            if(vendor == DatabaseVendors.PGSQL)
            {
                String = new EbDbType((int)NpgsqlTypes.NpgsqlDbType.Text);
                Decimal = new EbDbType((int)NpgsqlTypes.NpgsqlDbType.Double);
                Double = new EbDbType((int)NpgsqlTypes.NpgsqlDbType.Double);
                Int16 = new EbDbType((int)NpgsqlTypes.NpgsqlDbType.Integer);
                Int32 = new EbDbType((int)NpgsqlTypes.NpgsqlDbType.Integer);
                Int64 = new EbDbType((int)NpgsqlTypes.NpgsqlDbType.Integer);
                Json = new EbDbType((int)NpgsqlTypes.NpgsqlDbType.Json);
                Boolean = new EbDbType((int)NpgsqlTypes.NpgsqlDbType.Boolean);
                Date = new EbDbType((int)NpgsqlTypes.NpgsqlDbType.Date);
                DateTime = new EbDbType((int)NpgsqlTypes.NpgsqlDbType.Timestamp);
                VarNumeric = new EbDbType((int)NpgsqlTypes.NpgsqlDbType.Numeric);
                Time = new EbDbType((int)NpgsqlTypes.NpgsqlDbType.Time);
            }
            if(vendor == DatabaseVendors.ORACLE)
            {
                String = new EbDbType((int)OracleType.VarChar);
                Decimal = new EbDbType((int)OracleType.Double);
                Double = new EbDbType((int)OracleType.Double);
                Int16 = new EbDbType((int)OracleType.Int16);
                Int32 = new EbDbType((int)OracleType.Int32);
                Int64 = new EbDbType((int)OracleType.Number);
                Json = new EbDbType((int)OracleType.Clob);
                Boolean = new EbDbType((int)OracleType.VarChar);
                Date = new EbDbType((int)OracleType.Timestamp);
                DateTime = new EbDbType((int)OracleType.DateTime);
                VarNumeric = new EbDbType((int)OracleType.Number);
                Time = new EbDbType((int)OracleType.TimestampWithTZ);
            }
        }

        public static EbDbType Get(int intcode)
        {
            foreach (EbDbType o in Enumerator)
            {
                if (o.IntCode == intcode)
                    return o;
            }

            return String;
        }

        public static IEnumerable<EbDbType> Enumerator
        {
            get
            {
                return new[] {
                    String, Decimal, Double, Int32, Int64, Int16, Json, Boolean, Date, DateTime, Time
                };
            }
        }
    }
}

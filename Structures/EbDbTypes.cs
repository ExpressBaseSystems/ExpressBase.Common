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

    public struct EbDbTypes
    {
        public static readonly EbDbType String = new EbDbType((int)DbType.String);
        public static readonly EbDbType Decimal = new EbDbType((int)DbType.Decimal);
        public static readonly EbDbType Double = new EbDbType((int)DbType.Double);
        public static readonly EbDbType Int16 = new EbDbType((int)DbType.Int16);
        public static readonly EbDbType Int32 = new EbDbType((int)DbType.Int32);
        public static readonly EbDbType Int64 = new EbDbType((int)DbType.Int64);
        public static readonly EbDbType Json = new EbDbType((int)DbType.Object);
        public static readonly EbDbType Boolean = new EbDbType((int)DbType.Boolean);
        public static readonly EbDbType Date = new EbDbType((int)DbType.Date);
        public static readonly EbDbType DateTime = new EbDbType((int)DbType.DateTime);
        public static readonly EbDbType VarNumeric = new EbDbType((int)DbType.VarNumeric);
        public static readonly EbDbType Time = new EbDbType((int)DbType.Time);

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

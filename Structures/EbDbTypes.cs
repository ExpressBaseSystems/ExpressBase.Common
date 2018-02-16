using System;
using System.Collections.Generic;
using System.Data;
using System.Data.OracleClient;
using System.Text;

namespace ExpressBase.Common.Structures
{
    public struct EbDbType
    {
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
            else if ((DbType)this.IntCode == DbType.Int64)
            {
                if (vendor == DatabaseVendors.PGSQL)
                    return (int)NpgsqlTypes.NpgsqlDbType.Bigint;
                if (vendor == DatabaseVendors.ORACLE)
                    return (int)OracleType.Number;
            }


            return this.IntCode;
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
        public static readonly EbDbType Int32 = new EbDbType((int)DbType.Int32);
        public static readonly EbDbType Int64 = new EbDbType((int)DbType.Int64);
        public static readonly EbDbType Json = new EbDbType((int)DbType.Object);
        public static readonly EbDbType Boolean = new EbDbType((int)DbType.Boolean);
        public static readonly EbDbType Date = new EbDbType((int)DbType.DateTime);

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
                    String,Decimal,Int32,Int64,Json,Boolean,Date
                };
            }
        }
    }
}

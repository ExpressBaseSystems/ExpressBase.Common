using ExpressBase.Common.Constants;
using ExpressBase.Common.Structures;
using System;
using System.Collections.Generic;
using System.Text;

namespace ExpressBase.Common.LocationNSolution
{
    public class EbSystemColumn
    {
        public string Name { get; set; }
        public string Value { get; set; }
        public string Default { get; private set; }
        public int Type { get; set; }//EbDbTypes
        public Dictionary<int, string> PossibleTypes { get; private set; }//<EbDbTypes, Title>

        public EbSystemColumn() { }

        public EbSystemColumn(string name, string value, string def, int preset)
        {
            this.Name = name;
            this.Value = value;
            this.Default = def;

            if (preset == 1)//Integer
            {
                this.Type = (int)EbDbTypes.Int32;
                this.PossibleTypes = new Dictionary<int, string>()
                {
                    { (int)EbDbTypes.Int32, "Integer" }
                };
            }
            else if (preset == 2)//DateTime
            {
                this.Type = (int)EbDbTypes.DateTime;
                this.PossibleTypes = new Dictionary<int, string>()
                {
                    { (int)EbDbTypes.DateTime, "DateTime" }
                };
            }
            else if (preset == 3)//Bool
            {
                this.Type = (int)EbDbTypes.Boolean;
                this.PossibleTypes = new Dictionary<int, string>()
                {
                    { (int)EbDbTypes.Boolean, "Char(1)" },
                    { (int)EbDbTypes.BooleanOriginal, "Boolean" }
                };
            }
        }

        public EbSystemColumn(string name, string value, string def, int typ, Dictionary<int, string> possibleTyp)
        {
            this.Name = name;
            this.Value = value;
            this.Default = def;
            this.Type = typ;
            this.PossibleTypes = possibleTyp;
        }
    }

    public class EbSystemColumns: List<EbSystemColumn>
    {
        public EbSystemColumns() { }
        
        public EbSystemColumns(List<EbSystemColumn> ebs) : base()
        {
            base.AddRange(ebs);
        }

        public string this[string key]
        {
            get
            {
                return this.GetItem(key).Value;
            }
        }

        public EbDbTypes GetDbType(string key)
        {
            return (EbDbTypes)this.GetItem(key).Type;
        }

        public string GetBoolFalse(string key, bool quoted = true)
        {
            return this.GetItem(key).Type == (int)EbDbTypes.Boolean ? (quoted ? "'F'" : "F") : "false";
        }

        public string GetBoolTrue(string key)
        {
            return this.GetItem(key).Type == (int)EbDbTypes.Boolean ? "'T'" : "true";
        }

        public bool GetBooleanValue(string key, object val)
        {
            return this.GetItem(key).Type == (int)EbDbTypes.Boolean ? Convert.ToString(val).Equals("T") : Convert.ToBoolean(val);
        }

        private EbSystemColumn GetItem(string key) 
        {
            EbSystemColumn temp = this.Find(e => e.Default == key);
            if (temp != null) return temp;
            temp = EbSysCols.Values.Find(e => e.Default == key);
            if (temp != null) return temp;
            throw new KeyNotFoundException("KeyNotFoundException [EbSystemColumns]: Key = " + key);
        }
    }

    public static class EbSysCols
    {
        private static List<EbSystemColumn> _Values = new List<EbSystemColumn>() 
        { 
            new EbSystemColumn("Created By", SystemColumns.eb_created_by, SystemColumns.eb_created_by, 1),
            new EbSystemColumn("Created At", SystemColumns.eb_created_at, SystemColumns.eb_created_at, 2),
            new EbSystemColumn("Created From", SystemColumns.eb_loc_id, SystemColumns.eb_loc_id, 1),
            new EbSystemColumn("Last Modified By", SystemColumns.eb_lastmodified_by, SystemColumns.eb_lastmodified_by, 1),
            new EbSystemColumn("Last Modified At", SystemColumns.eb_lastmodified_at, SystemColumns.eb_lastmodified_at, 2),
            new EbSystemColumn("Cancel", SystemColumns.eb_void, SystemColumns.eb_void, 3),
            new EbSystemColumn("Delete", SystemColumns.eb_del, SystemColumns.eb_del, 3),
            new EbSystemColumn("Lock", SystemColumns.eb_lock, SystemColumns.eb_lock, 3),
            new EbSystemColumn("SignIn Id", SystemColumns.eb_signin_log_id, SystemColumns.eb_signin_log_id, 1),
            new EbSystemColumn("Form Version Id", SystemColumns.eb_ver_id, SystemColumns.eb_ver_id, 1),
            new EbSystemColumn("Data Push Id", SystemColumns.eb_push_id, SystemColumns.eb_push_id, 1),
            new EbSystemColumn("Source Data Id", SystemColumns.eb_src_id, SystemColumns.eb_src_id, 1),
            new EbSystemColumn("Row Order", SystemColumns.eb_row_num, SystemColumns.eb_row_num, 1),
            new EbSystemColumn("Source Version Id", SystemColumns.eb_src_ver_id, SystemColumns.eb_src_ver_id, 1),
            new EbSystemColumn("Read Only", SystemColumns.eb_ro, SystemColumns.eb_ro, 3)
        };

        public static List<EbSystemColumn> Values
        {
            get
            {
                return _Values;
            }
        }

        public static List<EbSystemColumn> GetFixed(List<EbSystemColumn> _value)
        {
            if (_value == null)
                return Values;
            List<EbSystemColumn> _temp = new List<EbSystemColumn>();

            foreach (EbSystemColumn item in Values)
            {
                EbSystemColumn in_item = _value.Find(e => e.Name == item.Name);
                if (in_item?.Value != null && in_item.Value.Trim() != string.Empty)
                    _temp.Add(new EbSystemColumn(item.Name, in_item.Value, item.Default, (in_item.Type > 0 ? in_item.Type : item.Type), item.PossibleTypes));
                else
                    _temp.Add(item);
            }
            return _temp;
        }
    }
}

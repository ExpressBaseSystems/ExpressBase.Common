using ExpressBase.Common;
using ServiceStack;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;

namespace ExpressBase.Security
{
    //to support all types of constraints
    public class EbConstraints
    {
        public Dictionary<int, EbConstraint> Constraints { get; set; }//key - constraints master table id

        public EbConstraints()
        {
            this.Constraints = new Dictionary<int, EbConstraint>();
        }

        public EbConstraints(EbDataTable dt)
        {
            this.Constraints = new Dictionary<int, EbConstraint>();

            for (int i = 0; i < dt.Rows.Count; i++)
            {
                int id = Convert.ToInt32(dt.Rows[i]["id"]);

                if (!this.Constraints.ContainsKey(id))
                {
                    this.Constraints.Add(id, new EbConstraint()
                    {
                        KeyId = Convert.ToInt32(dt.Rows[i]["key_id"]),
                        KeyType = (EbConstraintKeyTypes)Convert.ToInt32(dt.Rows[i]["key_type"]),
                        Description = Convert.ToString(dt.Rows[i]["description"])
                    });
                }
                this.Constraints[id].Values.Add(Convert.ToInt32(dt.Rows[i]["lid"]), new EbConstraintOTV()
                {
                    Type = (EbConstraintTypes)Convert.ToInt32(dt.Rows[i]["c_type"]),
                    Operation = (EbConstraintOperators)Convert.ToInt32(dt.Rows[i]["c_operation"]),
                    Value = Convert.ToString(dt.Rows[i]["c_value"])
                });
            }
        }
        public EbConstraints(string[] add_ids, EbConstraintKeyTypes key_typ, EbConstraintTypes cons_typ)
        {
            this.Constraints = new Dictionary<int, EbConstraint>();

            for (int i = 0; i < add_ids.Length; i++)
            {
                add_ids[i].ReplaceAll(";", string.Empty).ReplaceAll("$", string.Empty);
                this.Constraints.Add(i, new EbConstraint()
                {
                    KeyType = key_typ,
                    Description = "no description"
                });
                this.Constraints[i].Values.Add(0, new EbConstraintOTV()
                {
                    Operation = EbConstraintOperators.EqualTo,
                    Type = cons_typ,
                    Value = add_ids[i]
                });
            }
        }
        public EbConstraints(string cons_all)
        {
            //Hint - STRING_AGG(m.id || ';' || m.key_id || ';' || m.key_type || ';' || l.id || ';' || l.c_operation || ';' || l.c_type || ';' || l.c_value, '$')
            this.Constraints = new Dictionary<int, EbConstraint>();
            string[] _cons = cons_all.Split("$");

            for (int i = 0; i < _cons.Length; i++)
            {
                string[] _consline = _cons[i].Split(";");
                int mid = Convert.ToInt32(_consline[0]);
                if (!this.Constraints.ContainsKey(mid))
                {
                    this.Constraints.Add(mid, new EbConstraint()
                    {
                        KeyId = Convert.ToInt32(_consline[1]),
                        KeyType = (EbConstraintKeyTypes)Convert.ToInt32(_consline[2])
                    });
                }
                this.Constraints[mid].Values.Add(Convert.ToInt32(_consline[3]), new EbConstraintOTV()
                {
                    Operation = (EbConstraintOperators)Convert.ToInt32(_consline[4]),
                    Type = (EbConstraintTypes)Convert.ToInt32(_consline[5]),
                    Value = Convert.ToString(_consline[6])
                });
            }
        }

        public void SetConstraintObject(List<IpConstraint> IpConstr)
        {
            for (int i = 0; i < IpConstr.Count; i++)
            {
                this.Constraints.Add(i, new EbConstraint()
                {
                    KeyType = EbConstraintKeyTypes.UserGroup,
                    Description = IpConstr[i].Description
                });
                this.Constraints[i].Values.Add(0, new EbConstraintOTV
                {
                    Operation = EbConstraintOperators.EqualTo,
                    Type = EbConstraintTypes.UserGroup_Ip,
                    Value = IpConstr[i].Ip
                });
            }
        }

        public string GetDataAsString()
        {
            //Expected format: [{KeyType, Desciption, Constaints[{operation, type, value},{}...]}, {}, {}...]
            if (this.Constraints.Count == 0)
                return string.Empty;
            List<string> _conStr = new List<string>();
            foreach (KeyValuePair<int, EbConstraint> cons in this.Constraints)
            {
                List<string> _conlineStr = new List<string>();
                foreach (KeyValuePair<int, EbConstraintOTV> consline in cons.Value.Values)
                {
                    _conlineStr.Add((int)consline.Value.Operation + ";" + (int)consline.Value.Type + ";" + consline.Value.Value);
                }
                _conStr.Add((int)cons.Value.KeyType + "$" + cons.Value.Description + "$" + _conlineStr.Join(";;"));
            }
            return _conStr.Join("$$");
        }

        public IEnumerable<KeyValuePair<int, EbConstraint>> UConstraints
        {
            get
            {
                return this.Constraints.Where(e => e.Value.KeyType == EbConstraintKeyTypes.User);
            }
        }
        public IEnumerable<KeyValuePair<int, EbConstraint>> UgConstraints
        {
            get
            {
                return this.Constraints.Where(e => e.Value.KeyType == EbConstraintKeyTypes.UserGroup);
            }
        }
        public IEnumerable<KeyValuePair<int, EbConstraint>> RConstraints
        {
            get
            {
                return this.Constraints.Where(e => e.Value.KeyType == EbConstraintKeyTypes.Role);
            }
        }

        public static string GetSelectQuery(EbConstraintKeyTypes _keyTyp, IDatabase DataDB, string _keyIdParam = "id")
        {
            return string.Format(DataDB.EB_GET_SELECT_CONSTRAINTS, (int)_keyTyp, _keyIdParam);
        }

        public bool Validate(string ip, string device, User user)
        {
            Dictionary<EbConstraintTypes, bool> _status = new Dictionary<EbConstraintTypes, bool>();
            List<int> _locs = new List<int>();
            foreach (KeyValuePair<int, EbConstraint> _cons in this.Constraints)
            {
                foreach (KeyValuePair<int, EbConstraintOTV> _c in _cons.Value.Values)
                {
                    if (_c.Value.Type == EbConstraintTypes.User_Location)
                        _locs.Add(_c.Value.GetValue());
                    else
                    {
                        if (!_status.ContainsKey(_c.Value.Type))
                            _status.Add(_c.Value.Type, false);
                    }

                    if (_c.Value.Type == EbConstraintTypes.UserGroup_Ip || _c.Value.Type == EbConstraintTypes.User_DeviceId)
                    {
                        if ((!string.IsNullOrEmpty(ip) && _c.Value.Value.Equals(ip)) || (!string.IsNullOrEmpty(device) && _c.Value.Value.Equals(device)))
                            _status[_c.Value.Type] = true;
                    }
                    else if (_c.Value.Type == EbConstraintTypes.UserGroup_Days)
                    {
                        int t1 = _c.Value.GetValue();
                        int t2 = (int)DateTime.UtcNow.DayOfWeek + 1;
                        if ((t1 & t2) > 0)
                            _status[_c.Value.Type] = true;
                    }
                    else if (_c.Value.Type == EbConstraintTypes.UserGroup_Date)
                    {
                        if (_c.Value.Operation == EbConstraintOperators.EqualTo)
                        {
                            if (_c.Value.GetValue().Date == DateTime.UtcNow.Date)
                                _status[_c.Value.Type] = true;
                        }
                        else if (_c.Value.Operation == EbConstraintOperators.GreaterThan)
                        {
                            if (_c.Value.GetValue().Date > DateTime.UtcNow.Date)
                                _status[_c.Value.Type] = true;
                        }
                        else if (_c.Value.Operation == EbConstraintOperators.LessThan)
                        {
                            if (_c.Value.GetValue().Date < DateTime.UtcNow.Date)
                                _status[_c.Value.Type] = true;
                        }
                    }
                    else if (_c.Value.Type == EbConstraintTypes.UserGroup_Time)
                    {
                        if (_c.Value.Operation == EbConstraintOperators.EqualTo)
                        {
                            if (_c.Value.GetValue().TimeOfDay == DateTime.UtcNow.TimeOfDay)
                                _status[_c.Value.Type] = true;
                        }
                        else if (_c.Value.Operation == EbConstraintOperators.GreaterThan)
                        {
                            if (_c.Value.GetValue().TimeOfDay > DateTime.UtcNow.TimeOfDay)
                                _status[_c.Value.Type] = true;
                        }
                        else if (_c.Value.Operation == EbConstraintOperators.LessThan)
                        {
                            if (_c.Value.GetValue().TimeOfDay < DateTime.UtcNow.TimeOfDay)
                                _status[_c.Value.Type] = true;
                        }
                    }
                }
            }
            foreach (KeyValuePair<EbConstraintTypes, bool> _s in _status)
                if (!_s.Value)
                    return false;
            if (_locs.Count > 0)
            {
                List<string> global = new List<string>();
                for (int i = 0; i < user.Permissions.Count; i++)
                {
                    string[] s = user.Permissions[i].Split(":");
                    if (s[1].Equals("-1"))
                        global.Add(s[0]);
                }
                user.Permissions.RemoveAll(p => !_locs.Contains(Convert.ToInt32(p.Split(":")[1].Trim())));
                if (global.Count > 0)
                    for (int i = 0; i < global.Count; i++)
                        for (int j = 0; j < _locs.Count; j++)
                            user.Permissions.Add(global[i] + ":" + _locs[j]);
            }
            return true;
        }

        public bool IsIpConstraintPresent()
        {
            foreach (KeyValuePair<int, EbConstraint> _cons in this.Constraints)
            {
                foreach (KeyValuePair<int, EbConstraintOTV> _c in _cons.Value.Values)
                {
                    if (_c.Value.Type == EbConstraintTypes.UserGroup_Ip)
                        return true;
                }
            }
            return false;
        }

    }

    public class EbConstraint
    {
        public EbConstraint()
        {
            this.Values = new Dictionary<int, EbConstraintOTV>();
        }
        public int KeyId { get; set; }//UserId or UsergroupId or RoleId
        public EbConstraintKeyTypes KeyType { get; set; }
        public string Description { get; set; }
        public Dictionary<int, EbConstraintOTV> Values { get; set; }//key - lines table id
    }

    public class EbConstraintOTV
    {
        public EbConstraintTypes Type { get; set; }
        public string Value { get; set; }
        public EbConstraintOperators Operation { get; set; }

        public dynamic GetValue()
        {
            dynamic _v = null;
            if (this.Type == EbConstraintTypes.User_Location || this.Type == EbConstraintTypes.UserGroup_Days)
                _v = Convert.ToInt32(this.Value);
            else if (this.Type == EbConstraintTypes.UserGroup_Date)
                _v = DateTime.ParseExact(this.Value, "yyyy-MM-dd", CultureInfo.InvariantCulture);
            else if (this.Type == EbConstraintTypes.UserGroup_Time)
                _v = DateTime.ParseExact(this.Value, "HH:mm:ss", CultureInfo.InvariantCulture);
            else
                _v = this.Value;
            return _v;
        }
    }


    public class IpConstraint
    {
        public string Ip { get; set; }
        public string Description { get; set; }
    }

    public class DateTimeConstraint
    {
        public string Title { get; set; }
        public string Description { get; set; }
        public int Type { get; set; }
        public string Start { get; set; }
        public string End { get; set; }
        public int DaysCoded { get; set; }
    }
}

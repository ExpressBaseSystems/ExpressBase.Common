using ExpressBase.Common;
using ExpressBase.Common.Constants;
using ExpressBase.Common.Extensions;
using ExpressBase.Common.Helpers;
using ExpressBase.Common.Singletons;
using ExpressBase.Common.Structures;
using Newtonsoft.Json;
using ServiceStack;
using ServiceStack.Auth;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Globalization;
using System.Linq;
using System.Runtime.Serialization;
using System.Text.RegularExpressions;

namespace ExpressBase.Security
{
    [DataContract]
    public class User : UserAuth
    {
        [DataMember(Order = 1)]
        public int UserId { get; set; }

        [DataMember(Order = 2)]
        public string CId { get; set; }

        [DataMember(Order = 3)]
        public string wc { get; set; }

        [DataMember(Order = 4)]
        public override List<string> Roles { get; set; }

        [DataMember(Order = 5)]
        public List<int> RoleIds { get; set; }

        [DataMember(Order = 6)]
        public List<int> UserGroupIds { get; set; }

        [DataMember(Order = 7)]
        public override List<string> Permissions { get; set; }

        [DataMember(Order = 8)]
        public string AuthId { get; set; }

        [DataMember(Order = 9)]
        public Preferences Preference { get; set; }

        [DataMember(Order = 10)]
        public override string Email { get; set; }

        [DataMember(Order = 11)]
        public override string FullName { get; set; }

        [DataMember(Order = 12)]
        public int SignInLogId { get; set; }

        [DataMember(Order = 13)]
        public string SourceIp { get; set; }


        [DataMember(Order = 14)]
        public int UserType { get; set; }

        [DataMember(Order = 15)]
        [JsonIgnore]
        public string RefreshToken { get; set; }

        [DataMember(Order = 16)]
        [JsonIgnore]
        public string BearerToken { get; set; }

        [DataMember(Order = 17)]
        [JsonIgnore]
        public string EmailVerifCode { get; set; }

        [DataMember(Order = 18)]
        [JsonIgnore]
        public string MobileVerifCode { get; set; }

        [DataMember(Order = 19)]
        [JsonIgnore]
        public string Otp { get; set; }

        [DataMember(Order = 20)]
        public override string PhoneNumber { get; set; }

        [DataMember(Order = 21)]
        public bool IsForcePWReset { get; set; }

        private List<string> _ebObjectIds = null;

        [DataMember(Order = 22)]
        public List<string> EbObjectIds
        {
            get
            {
                if (_ebObjectIds == null && wc != "tc")
                {
                    _ebObjectIds = new List<string>();
                    this.PopulateEbObjectIds();
                }

                return _ebObjectIds;
            }
        }

        private void PopulateEbObjectIds()
        {
            foreach (string p in this.Permissions)
            {
                if (p.Contains("-"))
                {
                    string oId = p.Split("-")[2].Trim();
                    if (!this.EbObjectIds.Contains(oId))
                        this.EbObjectIds.Add(oId);
                }
            }
        }

        public List<int> GetDashBoardIds()
        {
            List<int> DashBoardIds = new List<int>();
            foreach (string p in this.Permissions)
            {
                if (p.Contains("-"))
                {
                    string[] parts = p.Split("-");
                    if (Convert.ToInt32(parts[1]) == EbObjectTypes.DashBoard.IntCode)
                    {
                        DashBoardIds.Add(Convert.ToInt32(parts[2]));
                    }
                }
            }
            return DashBoardIds;
        }

        private List<int> _locationIds = null;

        public List<int> LocationIds
        {
            get
            {
                if (_locationIds == null)
                {
                    _locationIds = new List<int>();
                    if (this.Roles.Contains(SystemRoles.SolutionOwner.ToString()))
                        this._locationIds.Add(-1);
                    else
                        foreach (string p in this.Permissions)
                            if (p.Contains(":"))
                            {
                                int lid = Convert.ToInt32(p.Split(":")[1].Trim());
                                if (lid == -1)
                                {
                                    this._locationIds.Clear();
                                    this._locationIds.Add(lid);
                                    return _locationIds;
                                }
                                if (!this._locationIds.Contains(lid))
                                    this._locationIds.Add(lid);
                            }

                }
                return _locationIds;
            }
        }

        public List<int> GetLocationsByObject(string RefId)
        {
            //Sample refid - Only for reference
            //sourc == dest == type == dest objid == dest verid == source objid == source verid
            //ebdbllz23nkqd620180220120030-ebdbllz23nkqd620180220120030-0-2257-2976-2257-2976
            if (this.Roles.Contains(SystemRoles.SolutionOwner.ToString()))
                return new List<int> { -1 };
            List<int> _locs = new List<int>();

            int _objid = Convert.ToInt32(RefId.Split("-")[3].Trim());
            Console.WriteLine("GetLocationsByObject => ObjectId: " + _objid);

            foreach (string p in this.Permissions)
            {
                if (p.Contains(":") && _objid == Convert.ToInt32(p.Split("-")[2]))
                {
                    int lid = Convert.ToInt32(p.Split(":")[1].Trim());
                    if (lid == -1)
                        return new List<int> { -1 };
                    else if (!_locs.Contains(lid))
                        _locs.Add(lid);
                }
            }
            Console.WriteLine(" => LocationsIds: " + _locs.Join(","));
            return _locs;
        }

        public User() { }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="emailaddress"></param>
        /// <returns>bool</returns> 
        public static bool IsValidmail(string emailaddress)
        {
            return (Regex.IsMatch(emailaddress, @"\A(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?)\Z", RegexOptions.IgnoreCase));
        }

        public static bool Isvalidpassword(string password)
        {
            var input = password;

            var hasPassword = new Regex(@"^(?=.*[0-9])^(?=.*[a-zA-Z])^(?=.*[!#$%&'()*+,-./:;<=>?@[\]^_`{|}~]).{8,}");
            var isValidated = hasPassword.IsMatch(input);
            return isValidated;
        }

        public bool HasEbSystemRole()
        {
            foreach (var role in Enum.GetValues(typeof(EbSystemRoles)))
            {
                if (this.Roles.Contains(role.ToString()))
                    return true;
            }

            return false;
        }

        public bool HasSystemRole()
        {
            foreach (var role in Enum.GetValues(typeof(SystemRoles)))
            {
                if (this.Roles.Contains(role.ToString()))
                    return true;
            }

            return false;
        }

        public bool HasRole(string role)
        {
            return this.Roles.Contains(role);
        }

        public bool HasPermission(string permission)
        {
            return this.Permissions.Contains(permission);
        }

        //Signup_tok 
        public static User GetInfraVerifiedUser(IDatabase db, string uname, string u_token)
        {
            User _user = null;
            string sql = "UPDATE eb_tenants SET is_verified = 'T' WHERE cname = @cname AND u_token = @u_token;";
            sql += "SELECT id, firstname,profileimg FROM eb_tenants WHERE cname = @cname AND u_token = @u_token";

            DbParameter[] parameters = {
                db.GetNewParameter("cname", EbDbTypes.String, uname),
                db.GetNewParameter("u_token", EbDbTypes.String, u_token)
            };

            EbDataTable dt = db.DoQuery(sql, parameters);

            if (dt.Rows.Count != 0)
            {
                _user = new User
                {
                    UserId = Convert.ToInt32(dt.Rows[0][0]),
                    Email = uname,
                    FirstName = dt.Rows[0][1].ToString()
                };
            }

            return _user;
        }

        public static User GetDetailsTenant(IDatabase df, string uname, string pass, string ipAddress)
        {
            try
            {
                string Qry = "SELECT * FROM eb_authenticate_tenants(in_uname := @uname, in_pwd := @pass);";
                var ds = df.DoQuery(Qry, new DbParameter[] { df.GetNewParameter("uname", EbDbTypes.String, uname), df.GetNewParameter("pass", EbDbTypes.String, pass) });

                User _user = null;
                if (ds.Rows.Count > 0)
                {
                    int userid = Convert.ToInt32(ds.Rows[0][0]);
                    if (userid > 0)
                    {
                        //roles
                        string[] role_ids = ds.Rows[0][3].ToString().Split(',');
                        List<string> rolesname = new List<string>();
                        foreach (string roleid in role_ids)
                        {
                            if (!roleid.IsNullOrEmpty())
                                rolesname.Add(Enum.GetName(typeof(SystemRoles), Convert.ToInt32(roleid)) ?? "NULL");
                        }

                        _user = new User
                        {
                            UserId = userid,
                            Email = ds.Rows[0][1].ToString(),
                            FullName = ds.Rows[0][2].ToString(),
                            Roles = rolesname,
                            Permissions = ds.Rows[0][4].ToString().IsNullOrEmpty() ? new List<string>() : ds.Rows[0][4].ToString().Split(',').ToList(),
                            Preference = !string.IsNullOrEmpty(ds.Rows[0][5].ToString()) ? JsonConvert.DeserializeObject<Preferences>(ds.Rows[0][5].ToString()) : new Preferences { Locale = "en-IN", TimeZone = "(UTC+05:30) Chennai, Kolkata, Mumbai, New Delhi" },
                            //SourceIp = ipAddress //ip change leads to logout, hence commented
                        };
                    }
                }
                return _user;
            }
            catch (Exception e)
            {
                Console.WriteLine("Exception in GetDetailsTenant: " + e.ToString());
                return new User();
            }
        }

        public static User GetDetailsNormal(IDatabase df, string uname, string pwd, string context, string ipAddress, string deviceId, string userAgent)
        {
            try
            {
                string deviceInfo = JsonConvert.SerializeObject(new DeviceInfo { UserAgent = userAgent, WC = context, DeviceId = deviceId });
                EbDataTable dt;
                if (df.Vendor == DatabaseVendors.MYSQL)
                {
                    dt = df.DoProcedure(df.EB_AUTHETICATE_USER_NORMAL,
                        new DbParameter[] { df.GetNewParameter("uname", EbDbTypes.String, uname),
                            df.GetNewParameter("pwd", EbDbTypes.String, pwd),
                            df.GetNewParameter("social", EbDbTypes.String),
                            df.GetNewParameter(RoutingConstants.WC, EbDbTypes.String, context),
                            df.GetNewParameter("ipaddress", EbDbTypes.String, ipAddress),
                            df.GetNewParameter("deviceinfo", EbDbTypes.String, deviceInfo),
                            df.GetNewOutParameter("tmp_userid", EbDbTypes.Int32),
                            df.GetNewOutParameter("tmp_status_id", EbDbTypes.Int32),
                            df.GetNewOutParameter("tmp_email", EbDbTypes.String),
                            df.GetNewOutParameter("tmp_fullname", EbDbTypes.String),
                            df.GetNewOutParameter("tmp_roles_a", EbDbTypes.String),
                            df.GetNewOutParameter("tmp_rolename_a", EbDbTypes.String),
                            df.GetNewOutParameter("tmp_permissions", EbDbTypes.String),
                            df.GetNewOutParameter("tmp_preferencesjson", EbDbTypes.String),
                            df.GetNewOutParameter("tmp_constraints_a", EbDbTypes.String),
                            df.GetNewOutParameter("tmp_signin_id", EbDbTypes.Int32),
                            df.GetNewOutParameter("tmp_usergroup_a", EbDbTypes.String),
                            df.GetNewOutParameter("tmp_public_ids", EbDbTypes.String),
                            df.GetNewOutParameter("tmp_user_type", EbDbTypes.Int32)
                        });
                }
                else
                {
                    dt = df.DoQuery(df.EB_AUTHETICATE_USER_NORMAL, new DbParameter[] {
                        df.GetNewParameter("uname", EbDbTypes.String, uname),
                        df.GetNewParameter("pass", EbDbTypes.String, pwd),
                        df.GetNewParameter(RoutingConstants.WC, EbDbTypes.String, context),
                        df.GetNewParameter("ipaddress", EbDbTypes.String, ipAddress),
                        df.GetNewParameter("deviceinfo", EbDbTypes.String, deviceInfo)
                    });
                }
                return InitUserObject(dt, context, ipAddress, deviceId, true);
            }
            catch (Exception e)
            {
                Console.WriteLine("Exception in GetDetailsNormal: " + e.ToString());
                return new User();
            }

        }

        public static User GetDetailsSocial(IDatabase df, string socialId, string context, string ipAddress, string deviceId, string userAgent)
        {
            try
            {
                string deviceInfo = JsonConvert.SerializeObject(new DeviceInfo { UserAgent = userAgent, WC = context, DeviceId = deviceId });
                EbDataTable dt;
                if (df.Vendor == DatabaseVendors.MYSQL)
                {
                    dt = df.DoProcedure(df.EB_AUTHENTICATEUSER_SOCIAL,
                        new DbParameter[] {  df.GetNewParameter("uname", EbDbTypes.String),
                            df.GetNewParameter("pwd", EbDbTypes.String),
                            df.GetNewParameter("social", EbDbTypes.String, socialId),
                            df.GetNewParameter(RoutingConstants.WC, EbDbTypes.String, context),
                            df.GetNewParameter("ipaddress", EbDbTypes.String, ipAddress),
                            df.GetNewParameter("deviceinfo", EbDbTypes.String, deviceInfo),
                            df.GetNewOutParameter("tmp_userid", EbDbTypes.Int32),
                            df.GetNewOutParameter("tmp_status_id", EbDbTypes.Int32),
                            df.GetNewOutParameter("tmp_email", EbDbTypes.String),
                            df.GetNewOutParameter("tmp_fullname", EbDbTypes.String),
                            df.GetNewOutParameter("tmp_roles_a", EbDbTypes.String),
                            df.GetNewOutParameter("tmp_rolename_a", EbDbTypes.String),
                            df.GetNewOutParameter("tmp_permissions", EbDbTypes.String),
                            df.GetNewOutParameter("tmp_preferencesjson", EbDbTypes.String),
                            df.GetNewOutParameter("tmp_constraints_a", EbDbTypes.String),
                            df.GetNewOutParameter("tmp_signin_id", EbDbTypes.Int32),
                            df.GetNewOutParameter("tmp_usergroup_a", EbDbTypes.String),
                            df.GetNewOutParameter("tmp_public_ids", EbDbTypes.String),
                            df.GetNewOutParameter("tmp_user_type", EbDbTypes.Int32)
                        });
                }
                else
                {
                    dt = df.DoQuery(df.EB_AUTHENTICATEUSER_SOCIAL, new DbParameter[] {
                        df.GetNewParameter("social", EbDbTypes.String, socialId),
                        df.GetNewParameter("wc", EbDbTypes.String, context),
                        df.GetNewParameter("ipaddress", EbDbTypes.String, ipAddress),
                        df.GetNewParameter("deviceinfo", EbDbTypes.String, deviceInfo)
                    });
                }
                return InitUserObject(dt, context, ipAddress, deviceId, true);
            }
            catch (Exception e)
            {
                Console.WriteLine("Exception in GetDetailsSocial: " + e.ToString());
                return new User();
            }
        }

        public static User GetDetailsSSO(IDatabase df, string uname, string context, string ipAddress, string deviceId, string userAgent)
        {
            try
            {
                string deviceInfo = JsonConvert.SerializeObject(new DeviceInfo { UserAgent = userAgent, WC = context, DeviceId = deviceId });
                EbDataTable dt;
                if (df.Vendor == DatabaseVendors.MYSQL)
                {
                    dt = df.DoProcedure(df.EB_AUTHENTICATEUSER_SSO,
                        new DbParameter[] {
                            df.GetNewParameter("uname", EbDbTypes.String, uname),
                            df.GetNewParameter("pwd", EbDbTypes.String),
                            df.GetNewParameter("social", EbDbTypes.String),
                            df.GetNewParameter(RoutingConstants.WC, EbDbTypes.String, context),
                            df.GetNewParameter("ipaddress", EbDbTypes.String, ipAddress),
                            df.GetNewParameter("deviceinfo", EbDbTypes.String, deviceInfo),
                            df.GetNewOutParameter("tmp_userid", EbDbTypes.Int32),
                            df.GetNewOutParameter("tmp_status_id", EbDbTypes.Int32),
                            df.GetNewOutParameter("tmp_email", EbDbTypes.String),
                            df.GetNewOutParameter("tmp_fullname", EbDbTypes.String),
                            df.GetNewOutParameter("tmp_roles_a", EbDbTypes.String),
                            df.GetNewOutParameter("tmp_rolename_a", EbDbTypes.String),
                            df.GetNewOutParameter("tmp_permissions", EbDbTypes.String),
                            df.GetNewOutParameter("tmp_preferencesjson", EbDbTypes.String),
                            df.GetNewOutParameter("tmp_constraints_a", EbDbTypes.String),
                            df.GetNewOutParameter("tmp_signin_id", EbDbTypes.Int32),
                            df.GetNewOutParameter("tmp_usergroup_a", EbDbTypes.String),
                            df.GetNewOutParameter("tmp_public_ids", EbDbTypes.String),
                            df.GetNewOutParameter("tmp_user_type", EbDbTypes.Int32)
                        });
                }
                else
                {
                    dt = df.DoQuery(df.EB_AUTHENTICATEUSER_SSO, new DbParameter[] {
                        df.GetNewParameter("uname", EbDbTypes.String, uname),
                        df.GetNewParameter("wc", EbDbTypes.String, context),
                        df.GetNewParameter("ipaddress", EbDbTypes.String, ipAddress),
                        df.GetNewParameter("deviceinfo", EbDbTypes.String, deviceInfo)
                    });
                }
                return InitUserObject(dt, context, ipAddress, deviceId, true);
            }
            catch (Exception e)
            {
                Console.WriteLine("Exception in GetDetailsSSO: " + e.ToString());
                return new User();
            }
        }

        public static User GetDetailsAnonymous(IDatabase df, string socialId, string emailId, string phone, int appid, string context, string user_ip, string user_name, string user_browser, string city, string region, string country, string latitude, string longitude, string timezone, string iplocationjson)
        {
            EbDataTable dt;
            if (df.Vendor == DatabaseVendors.MYSQL)
            {
                dt = df.DoProcedure(df.EB_AUTHENTICATE_ANONYMOUS,
                    new DbParameter[] {
                        df.GetNewParameter("in_socialid", EbDbTypes.String, socialId),
                        df.GetNewParameter("in_fullname", EbDbTypes.String, user_name),
                        df.GetNewParameter("in_emailid", EbDbTypes.String, emailId),
                        df.GetNewParameter("in_phone", EbDbTypes.String, phone),
                        df.GetNewParameter("in_user_ip", EbDbTypes.String, user_ip),
                        df.GetNewParameter("in_user_browser", EbDbTypes.String, user_browser),
                        df.GetNewParameter("in_city", EbDbTypes.String, city),
                        df.GetNewParameter("in_region", EbDbTypes.String, region),
                        df.GetNewParameter("in_country", EbDbTypes.String, country),
                        df.GetNewParameter("in_latitude", EbDbTypes.String, latitude),
                        df.GetNewParameter("in_longitude", EbDbTypes.String, longitude),
                        df.GetNewParameter("in_timezone", EbDbTypes.String, timezone),
                        df.GetNewParameter("in_iplocationjson", EbDbTypes.String, iplocationjson),
                        df.GetNewParameter("in_appid", EbDbTypes.String, appid),
                        df.GetNewParameter(RoutingConstants.WC, EbDbTypes.String, context ),
                        df.GetNewOutParameter("out_userid", EbDbTypes.Int32),
                        df.GetNewOutParameter("out_status_id", EbDbTypes.Int32),
                        df.GetNewOutParameter("out_email", EbDbTypes.String),
                        df.GetNewOutParameter("out_fullname", EbDbTypes.String),
                        df.GetNewOutParameter("out_roles_a", EbDbTypes.String),
                        df.GetNewOutParameter("out_rolename_a", EbDbTypes.String),
                        df.GetNewOutParameter("out_permissions", EbDbTypes.String),
                        df.GetNewOutParameter("out_preferencesjson", EbDbTypes.String),
                        df.GetNewOutParameter("out_constraints_a", EbDbTypes.String),
                        df.GetNewOutParameter("out_signin_id", EbDbTypes.Int32),
                        df.GetNewOutParameter("out_usergroup_a", EbDbTypes.String),
                        df.GetNewOutParameter("out_public_ids", EbDbTypes.String),
                        df.GetNewOutParameter("out_user_type", EbDbTypes.Int32)
                    });
            }
            else
            {
                List<DbParameter> paramlist = new List<DbParameter>();
                string parameters = "";
                if (!string.IsNullOrEmpty(socialId))
                {
                    parameters += "in_socialid => :socialId, ";
                    paramlist.Add(df.GetNewParameter("socialId", EbDbTypes.String, socialId));
                }
                if (!string.IsNullOrEmpty(emailId))
                {
                    parameters += "in_emailid => :emailId, ";
                    paramlist.Add(df.GetNewParameter("emailId", EbDbTypes.String, emailId));
                }
                if (!string.IsNullOrEmpty(phone))
                {
                    parameters += "in_phone => :phone, ";
                    paramlist.Add(df.GetNewParameter("phone", EbDbTypes.String, phone));
                }
                if (!string.IsNullOrEmpty(user_ip))
                {
                    parameters += "in_user_ip => :user_ip, ";
                    paramlist.Add(df.GetNewParameter("user_ip", EbDbTypes.String, user_ip));

                }
                if (!string.IsNullOrEmpty(user_name))
                {
                    parameters += "in_fullname => :user_name, ";
                    paramlist.Add(df.GetNewParameter("user_name", EbDbTypes.String, user_name));
                }
                if (!string.IsNullOrEmpty(user_browser))
                {
                    parameters += "in_user_browser => :user_browser, ";
                    paramlist.Add(df.GetNewParameter("user_browser", EbDbTypes.String, user_browser));
                }
                if (!string.IsNullOrEmpty(city))
                {
                    parameters += "in_city => :city, ";
                    paramlist.Add(df.GetNewParameter("city", EbDbTypes.String, city));
                }
                if (!string.IsNullOrEmpty(region))
                {
                    parameters += "in_region => :region, ";
                    paramlist.Add(df.GetNewParameter("region", EbDbTypes.String, region));
                }
                if (!string.IsNullOrEmpty(country))
                {
                    parameters += "in_country => :country, ";
                    paramlist.Add(df.GetNewParameter("country", EbDbTypes.String, country));
                }
                if (!string.IsNullOrEmpty(latitude))
                {
                    parameters += "in_latitude => :latitude, ";
                    paramlist.Add(df.GetNewParameter("latitude", EbDbTypes.String, latitude));
                }
                if (!string.IsNullOrEmpty(longitude))
                {
                    parameters += "in_longitude => :longitude, ";
                    paramlist.Add(df.GetNewParameter("longitude", EbDbTypes.String, longitude));
                }
                if (!string.IsNullOrEmpty(timezone))
                {
                    parameters += "in_timezone => :timezone, ";
                    paramlist.Add(df.GetNewParameter("timezone", EbDbTypes.String, timezone));

                }
                if (!string.IsNullOrEmpty(iplocationjson))
                {
                    parameters += "in_iplocationjson => :iplocationjson, ";
                    paramlist.Add(df.GetNewParameter("iplocationjson", EbDbTypes.String, iplocationjson));
                }
                paramlist.Add(df.GetNewParameter("appid", EbDbTypes.Int32, appid));
                paramlist.Add(df.GetNewParameter(RoutingConstants.WC, EbDbTypes.String, context));

                string sql = df.EB_AUTHENTICATE_ANONYMOUS.Replace("@params", (df.Vendor == DatabaseVendors.PGSQL) ? parameters.Replace("=>", ":=") : parameters);

                dt = df.DoQuery(sql, paramlist.ToArray());
            }
            return InitUserObject(dt, context, user_ip, string.Empty, true);
        }

        public static void UpdateVerificationStatus(IDatabase DataDB, int UserId, bool IsEmailVerified, bool IsPhoneVerified)
        {
            string Qry = string.Empty;

            if (IsEmailVerified)
            {
                Qry = $"is_email_verified = 'T', email_verified_at = {DataDB.EB_CURRENT_TIMESTAMP}";
            }
            if (IsPhoneVerified)
            {
                if (Qry != string.Empty)
                    Qry += ", ";
                Qry += $"is_phone_verified = 'T', phone_verified_at = {DataDB.EB_CURRENT_TIMESTAMP}";
            }
            if (Qry != string.Empty && UserId > 0)
            {
                Qry = $"UPDATE eb_users SET {Qry} WHERE id = @uid;";
                int s = DataDB.DoNonQuery(Qry, new DbParameter[] {
                    DataDB.GetNewParameter("uid", EbDbTypes.Int32, UserId)
                });
            }
        }

        public static User GetUserObject(IDatabase df, int userId, string whichConsole, string userIp, string deviceId)
        {
            string query = "SELECT * FROM eb_getuserobject(:uid, :wc);";
            DbParameter[] p = new DbParameter[] {
                df.GetNewParameter("uid", EbDbTypes.Int32,userId),
                df.GetNewParameter("wc", EbDbTypes.String, whichConsole)
            };
            EbDataTable dt = df.DoQuery(query, p);
            User _user = InitUserObject(dt, whichConsole, userIp, deviceId, false);
            return _user.UserId == userId ? _user : null;
        }

        private static User InitUserObject(EbDataTable ds, string context, string ipAddress, string deviceId, bool loginInit)
        {
            //Columns : _userid, _status_id, _email, _fullname, _roles_a, _rolename_a, _permissions, _preferencesjson, _constraints_a, _signin_id, _usergroup_a, _public_ids, _user_type, phnoprimary, forcepwreset
            //              0         1         2        3         4           5            6                7               8              9           10             11           12          13        14
            User _user = null;
            int userid = Convert.ToInt32(ds.Rows[0][0]);
            if (userid > 0)
            {
                bool devRoleExists = false;
                string[] sRoleIds = ds.Rows[0][4].ToString().Split(',');//role id array
                List<int> iRoleIds = new List<int>();
                List<string> rolesname = ds.Rows[0][5].ToString().Split(',').ToList();
                if (!sRoleIds[0].IsNullOrEmpty())
                {
                    iRoleIds = Array.ConvertAll(sRoleIds, int.Parse).ToList();
                    for (var i = 0; i < iRoleIds.Count; i++)
                    {
                        int id = iRoleIds[i];
                        if (id < 100 && Enum.GetName(typeof(SystemRoles), id) != null)
                        {
                            rolesname[i] = Enum.GetName(typeof(SystemRoles), id);
                            if (id == (int)SystemRoles.SolutionDeveloper)
                                devRoleExists = true;
                        }
                    }
                }
                if (context.Equals(RoutingConstants.DC) && !devRoleExists)
                    return null;

                List<int> userGroupIds = new List<int>();
                string sUgIds = ds.Rows[0][10].ToString();
                if (!sUgIds.IsNullOrEmpty())
                    userGroupIds = Array.ConvertAll(sUgIds.Split(','), int.Parse).ToList();
                List<string> _permissions = ds.Rows[0][6].ToString().IsNullOrEmpty() ? new List<string>() : ds.Rows[0][6].ToString().Split(',').ToList();

                string email = ds.Rows[0][2].ToString();
                if (email.Equals(TokenConstants.ANONYM_EMAIL))//public object: permission only for anonymous user
                {
                    foreach (string objid in ds.Rows[0][11].ToString().Split(','))
                    {
                        if (_permissions == null)
                            _permissions = new List<string>();
                        string _permsn = "000" /*appid*/ + "-" + "00"/*type*/ + "-" + objid.PadLeft(5, '0') + "-" + "00" /*operation*/ + ":-1";
                        _permissions.Add(_permsn);
                    }
                }
                _user = new User
                {
                    UserId = userid,
                    Email = email,
                    FullName = ds.Rows[0][3].ToString(),
                    Roles = rolesname,
                    RoleIds = iRoleIds,
                    Permissions = _permissions,
                    Preference = !string.IsNullOrEmpty(ds.Rows[0][7].ToString()) ? JsonConvert.DeserializeObject<Preferences>(ds.Rows[0][7].ToString()) : new Preferences { Locale = "en-IN", TimeZone = "(UTC+05:30) Chennai, Kolkata, Mumbai, New Delhi", DefaultLocation = -1 },
                    SignInLogId = Convert.ToInt32(ds.Rows[0][9]),
                    SourceIp = ipAddress,
                    UserGroupIds = userGroupIds,
                    UserType = Convert.ToInt32(ds.Rows[0][12]),
                    PhoneNumber = ds.Rows[0][13].ToString(),
                    IsForcePWReset = (ds.Rows[0][14].ToString() == string.Empty || ds.Rows[0][14].ToString() == "T") ? true : false
                };
                if (!ds.Rows[0].IsDBNull(8) && !_user.Roles.Contains(SystemRoles.SolutionOwner.ToString()) && !_user.Roles.Contains(SystemRoles.SolutionAdmin.ToString()))
                {
                    EbConstraints constraints = new EbConstraints(ds.Rows[0][8].ToString());
                    if (!constraints.Validate(ipAddress, deviceId, _user, loginInit))
                        _user.UserId = -1;
                    if (!constraints.IsIpConstraintPresent())
                        _user.SourceIp = string.Empty;
                }
                else
                    _user.SourceIp = string.Empty;
                if (_user.Preference.DefaultLocation < 1 && _user.LocationIds.Count > 0)
                {
                    _user.Preference.DefaultLocation = _user.LocationIds[0] == -1 ? 1 : _user.LocationIds[0];
                }
            }
            return _user;
        }

        public void Logout(IDatabase DataDB)
        {
            try
            {
                string Qry = "UPDATE eb_signin_log SET signout_at = " + DataDB.EB_CURRENT_TIMESTAMP + " WHERE id = :id AND signout_at IS null;";
                DataDB.DoNonQuery(Qry, new DbParameter[] { DataDB.GetNewParameter("id", EbDbTypes.Int32, this.SignInLogId) });
            }
            catch (Exception ex)
            {
                Console.WriteLine("Exception in logout : " + ex.Message + "\nSignInLogId : " + this.SignInLogId);
            }
        }

        public bool IsAdmin()
        {
            return this.Roles.Contains(SystemRoles.SolutionOwner.ToString()) || this.Roles.Contains(SystemRoles.SolutionAdmin.ToString());
        }
    }
    public class Preferences
    {
        [DataMember(Order = 1)]
        public string Locale { get; set; }

        [DataMember(Order = 2)]
        public string TimeZone { get; set; }

        [DataMember(Order = 3)]
        public int DefaultLocation { get; set; }

        [DataMember(Order = 4)]
        public string DefaultDashBoard { get; set; }

        [JsonIgnore]
        public int CurrrentLocation { get; set; }

        public string GetShortDatePattern()
        {
            return CultureHelper.GetSerializedCultureInfo(this.Locale).DateTimeFormatInfo.ShortDatePattern;
        }

        public string GetLongDatePattern()
        {
            return CultureHelper.GetSerializedCultureInfo(this.Locale).DateTimeFormatInfo.LongDatePattern;
        }

        public string GetShortTimePattern()
        {
            return CultureHelper.GetSerializedCultureInfo(this.Locale).DateTimeFormatInfo.ShortTimePattern;
        }

        public string GetLongTimePattern()
        {
            return CultureHelper.GetSerializedCultureInfo(this.Locale).DateTimeFormatInfo.LongTimePattern;
        }

        //----------------------------------Cultures json Test-----------------------------------
        [DataMember(Order = 6)]
        public string ShortDatePattern
        {
            get
            {
                try
                {
                    SerializedCulture _cult = CultureHelper.GetSerializedCultureInfo(this.Locale);
                    return MomentJSHelpers.GenerateMomentJSFormatString(_cult.DateTimeFormatInfo.ShortDatePattern, _cult).Replace("[", "").Replace("]", "");
                }
                catch (Exception ex)
                {
                    Console.WriteLine("Exception thrown when tried to get short date PATTERN .............. : " + ex.Message);
                    return "YYYY-MM-DD";
                }
            }
        }
        [DataMember(Order = 7)]
        public string ShortDate
        {
            get
            {
                try
                {
                    //return DateTime.UtcNow.ConvertFromUtc(this.TimeZone).ToString("yyyy-MM-dd", CultureInfo.InvariantCulture);
                    return DateTime.UtcNow.ConvertFromUtc(this.TimeZone).ToString(CultureHelper.GetSerializedCultureInfo(this.Locale).DateTimeFormatInfo.ShortDatePattern, CultureInfo.InvariantCulture);
                }
                catch (Exception ex)
                {
                    Console.WriteLine("Exception thrown when tried to get short DATE ................. : " + ex.Message);
                    return DateTime.UtcNow.ToString("yyyy-MM-dd", CultureInfo.InvariantCulture);
                }
            }
        }

        [DataMember(Order = 8)]
        public string ShortTimePattern
        {
            get
            {
                try
                {
                    SerializedCulture _cult = CultureHelper.GetSerializedCultureInfo(this.Locale);
                    return MomentJSHelpers.GenerateMomentJSFormatString(_cult.DateTimeFormatInfo.ShortTimePattern, _cult).Replace("[", "").Replace("]", "");
                }
                catch (Exception ex)
                {
                    Console.WriteLine("Exception thrown when tried to get short time PATTERN .............. : " + ex.Message);
                    return "HH mm";
                }
            }
        }
        [DataMember(Order = 9)]
        public string ShortTime
        {
            get
            {
                try
                {
                    return DateTime.UtcNow.ConvertFromUtc(this.TimeZone).ToString(CultureHelper.GetSerializedCultureInfo(this.Locale).DateTimeFormatInfo.ShortTimePattern, CultureInfo.InvariantCulture);
                }
                catch (Exception ex)
                {
                    Console.WriteLine("Exception thrown when tried to get short TIME ................. : " + ex.Message);
                    return DateTime.UtcNow.ToString("hh:mm tt", CultureInfo.InvariantCulture);
                }
            }
        }
        public string CurrencyPattern
        {
            get
            {
                try
                {
                    var NumInfo = CultureHelper.GetSerializedCultureInfo(this.Locale).NumberFormatInfo;
                    int[] gp = NumInfo.CurrencyGroupSizes;
                    string st = string.Empty;
                    for (int i = 0; i < gp.Length - 1; i++)
                        st = $"({NumInfo.CurrencyGroupSeparator}{new String('9', gp[i])}){{1|1}}" + st;
                    st = $"({NumInfo.CurrencyGroupSeparator}{new String('9', gp[gp.Length - 1])}){{*|1}}" + st;
                    return st;
                }
                catch (Exception ex)
                {
                    Console.WriteLine("Exception in Json_Serialize ................. : " + ex.Message);
                    return "(,99){*|1}(,999){1|1}.(9){2}";
                }
            }
        }
        public string CurrencyGroupSeperator
        {
            get
            {
                try
                {
                    return CultureHelper.GetSerializedCultureInfo(this.Locale).NumberFormatInfo.CurrencyGroupSeparator;
                }
                catch (Exception ex)
                {
                    Console.WriteLine("Exception in CurrencyGroupSeparator ................. : " + ex.Message);
                    return ",";
                }
            }
        }
        public string CurrencyDecimalSeperator
        {
            get
            {
                try
                {
                    return CultureHelper.GetSerializedCultureInfo(this.Locale).NumberFormatInfo.CurrencyDecimalSeparator;
                }
                catch (Exception ex)
                {
                    Console.WriteLine("Exception in CurrencyDecimalSeparator ................. : " + ex.Message);
                    return ".";
                }
            }
        }
        public int CurrencyDecimalDigits
        {
            get
            {
                try
                {
                    return CultureHelper.GetSerializedCultureInfo(this.Locale).NumberFormatInfo.CurrencyDecimalDigits;
                }
                catch (Exception ex)
                {
                    Console.WriteLine("Exception in CurrencyDecimalSeparator ................. : " + ex.Message);
                    return 2;
                }
            }
        }
        //------------------------------------------------------------------------------------------

    }

    public class DeviceInfo
    {
        [DataMember(Order = 1)]
        public string DeviceId { get; set; }

        [DataMember(Order = 2)]
        public string UserAgent { get; set; }

        [DataMember(Order = 3)]
        public string WC { get; set; }
    }
}


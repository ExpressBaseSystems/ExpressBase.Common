using ExpressBase.Common;
using ExpressBase.Common.Structures;
using Newtonsoft.Json;
using ServiceStack;
using ServiceStack.Auth;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
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
        public override List<string> Permissions { get; set; }

        [DataMember(Order = 6)]
        public string AuthId { get; set; }

		[DataMember(Order = 7)]
		public Preferences Preference { get; set; }

        [DataMember(Order = 8)]
        public override string Email { get; set; }

        [DataMember(Order = 9)]
        public override string FullName { get; set; }
		
		private List<string> _ebObjectIds = null;
        public List<string> EbObjectIds
        {
            get
            {
                if (_ebObjectIds == null)
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
								if(lid == -1)
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
            string sql = "UPDATE eb_tenants SET isverified = TRUE WHERE cname = @cname AND u_token = @u_token;";
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

		public static User GetDetailsTenant(IDatabase df, string uname, string pass)
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
							if(!roleid.IsNullOrEmpty())
								rolesname.Add(Enum.GetName(typeof(SystemRoles), Convert.ToInt32(roleid)) ?? "NULL");
						}

						_user = new User
						{
							UserId = userid,
							Email = ds.Rows[0][1].ToString(),
							FullName = ds.Rows[0][2].ToString(),
							Roles = rolesname,
							Permissions = ds.Rows[0][4].ToString().IsNullOrEmpty()? new List<string>(): ds.Rows[0][4].ToString().Split(',').ToList(),
							Preference = JsonConvert.DeserializeObject<Preferences>(ds.Rows[0][5].ToString())
						};
					}
				}
				return _user;
			}
			catch (Exception e)
			{
				return new User();
			}
		}

		public static User GetDetailsNormal(IDatabase df, string uname, string pass, string context)
        {

            try {
                var ds = df.DoQuery(df.EB_AUTHETICATE_USER_NORMAL, new DbParameter[] { df.GetNewParameter("uname", EbDbTypes.String, uname), df.GetNewParameter("pass", EbDbTypes.String, pass), df.GetNewParameter(RoutingConstants.WC, EbDbTypes.String, context) });
                return InitUserObject(ds, context);
            }
            catch(Exception e)
            {
                return new User();
            }
           
        }

        public static User GetDetailsSocial(IDatabase df, string socialId, string context)
        {
            var ds = df.DoQuery(df.EB_AUTHENTICATEUSER_SOCIAL, new DbParameter[] { df.GetNewParameter("social", EbDbTypes.String, socialId), df.GetNewParameter("wc", EbDbTypes.String, context) });
            return InitUserObject(ds, context);
        }

        public static User GetDetailsSSO(IDatabase df, string uname, string context)
        {
            var ds = df.DoQuery(df.EB_AUTHENTICATEUSER_SSO, new DbParameter[] { df.GetNewParameter("uname", EbDbTypes.String, uname), df.GetNewParameter("wc", EbDbTypes.String, context) });
            return InitUserObject(ds, context);
        }

        public static User GetDetailsAnonymous(IDatabase df, string socialId, string emailId, string phone, int appid, string context, string user_ip, string user_name, string user_browser, string city, string region, string country, string latitude, string longitude, string timezone, string iplocationjson)
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

            var ds = df.DoQuery(sql, paramlist.ToArray());
            return InitUserObject(ds, context);
        }

        private static User InitUserObject(EbDataTable ds, string context)
        {
            User _user = null;
            if (ds.Rows.Count > 0)
            {
				int userid = Convert.ToInt32(ds.Rows[0][0]);
                if (userid > 0)
                {
					bool sysRoleExists = false;
                    string[] rids = ds.Rows[0][3].ToString().Split(',');//role id array
                    List<string> rolesname = ds.Rows[0][4].ToString().Split(',').ToList();
					if (!rids[0].IsNullOrEmpty())
					{
						List<int> rolesid = Array.ConvertAll(rids, int.Parse).ToList();
						for (var i = 0; i < rolesid.Count; i++)
						{
							int id = rolesid[i];
							if (id < 100 && Enum.GetName(typeof(SystemRoles), id) != null)
							{
								rolesname[i] = Enum.GetName(typeof(SystemRoles), id);
								sysRoleExists = true;
							}								
						}
					}
					if (context.Equals(RoutingConstants.DC) && !sysRoleExists)
						return null;

                    _user = new User
                    {
                        UserId = userid,
                        Email = ds.Rows[0][1].ToString(),
                        FullName = ds.Rows[0][2].ToString(),
                        Roles = rolesname,
                        Permissions = ds.Rows[0][5].ToString().IsNullOrEmpty()? new List<string>(): ds.Rows[0][5].ToString().Split(',').ToList(),
						Preference = !string.IsNullOrEmpty((string)ds.Rows[0][6])? JsonConvert.DeserializeObject<Preferences>(ds.Rows[0][6].ToString()): new Preferences { Locale= "en-US", TimeZone = ""}
					};
                }
            }

            return _user;
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
	}
}


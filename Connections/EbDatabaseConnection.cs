using Amazon;
using ExpressBase.Common.Data;
using ExpressBase.Common.Structures;
using MongoDB.Driver;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data.Common;
using System.Text;

namespace ExpressBase.Common.Connections
{

    //public interface IEbConnection
    //{
    //    int Id { get; set; }

    //    bool IsDefault { get; set; }

    //    string NickName { get; set; }

    //    EbConnectionTypes EbConnectionType { get; }
    //}

    //public abstract class EbBaseDbConnection : IEbConnection
    //{

    //    public string DatabaseName { get; set; }

    //    public string Server { get; set; }

    //    public int Port { get; set; }

    //    public string UserName { get; set; }

    //    public string Password { get; set; }

    //    public string ReadWriteUserName { get; set; }

    //    public string ReadWritePassword { get; set; }

    //    public string ReadOnlyUserName { get; set; }

    //    public string ReadOnlyPassword { get; set; }

    //    public int Timeout { get; set; }

    //    public abstract EbConnectionTypes EbConnectionType { get; }

    //    public int Id { get; set; }

    //    public bool IsDefault { get; set; }

    //    public string NickName { get; set; }

    //    public bool IsSSL { get; set; }

    //}

    //public class EbObjectsDbConnection : EbBaseDbConnection
    //{
    //    public DatabaseVendors DatabaseVendor { get; set; }

    //    public override EbConnectionTypes EbConnectionType { get { return EbConnectionTypes.EbOBJECTS; } }
    //}

    //// For Infra T-Data, Tenant T-Data
    //public class EbDataDbConnection : EbBaseDbConnection
    //{
    //    public DatabaseVendors DatabaseVendor { get; set; }

    //    public override EbConnectionTypes EbConnectionType { get { return EbConnectionTypes.EbDATA; } }

    //}

    //// For Infra Files, Tenant Files
    //public class EbFilesDbConnection : EbBaseDbConnection
    //{
    //    public FilesDbVendors FilesDbVendor { set; get; }

    //    [JsonConverter(typeof(CustomBase64Converter))]
    //    public string FilesDB_url { get; set; }

    //    public override EbConnectionTypes EbConnectionType { get { return EbConnectionTypes.EbFILES; } }
    //}

    //public class EbLogsDbConnection : EbBaseDbConnection
    //{
    //    public DatabaseVendors DatabaseVendor { get; set; }

    //    public override EbConnectionTypes EbConnectionType { get { return EbConnectionTypes.EbLOGS; } }
    //}

    //internal class CustomBase64Converter : JsonConverter
    //{
    //    public override bool CanConvert(Type objectType)
    //    {
    //        return true;
    //    }

    //    public override object ReadJson(JsonReader reader, Type objectType, object existingValue, JsonSerializer serializer)
    //    {
    //        return System.Text.Encoding.UTF8.GetString((Convert.FromBase64String((string)reader.Value)));
    //    }

    //    public override void WriteJson(JsonWriter writer, object value, JsonSerializer serializer)
    //    {
    //        writer.WriteValue(Convert.ToBase64String(System.Text.Encoding.UTF8.GetBytes((string)value)));
    //    }
    //}

    //public class Base64Serializer : JsonConverter
    //{
    //    public override bool CanConvert(Type objectType)
    //    {
    //        return (objectType == typeof(string));
    //    }

    //    public override object ReadJson(JsonReader reader, Type objectType, object existingValue, JsonSerializer serializer)
    //    {
    //        return Convert.FromBase64String(reader.Value.ToString());
    //    }

    //    public override void WriteJson(JsonWriter writer, object value, JsonSerializer serializer)
    //    {
    //        string valueAsString = Convert.ToBase64String(Encoding.ASCII.GetBytes(value.ToString()));

    //        if (!string.IsNullOrWhiteSpace(valueAsString))
    //            writer.WriteValue(valueAsString);
    //    }
    //}


    //--------------------------------------------------------- integrations-----------------------------------


    public class EbIntegrationConf
    {
        public int Id { get; set; }

        public string NickName { get; set; }

        public virtual EbIntegrations Type { get; set; }

        public bool IsDefault { get; set; }

        public int PersistIntegrationConf(string Sol_Id, EbConnectionFactory infra, int UserId)
        {
            int nid = 0;
            string query = string.Empty;
            string json = EbSerializers.Json_Serialize(this);// JsonConvert.SerializeObject(this);
            DbParameter[] parameters = {
                                        infra.DataDB.GetNewParameter("solution_id", EbDbTypes.String, Sol_Id),
                                        infra.DataDB.GetNewParameter("nick_name", EbDbTypes.String, !(string.IsNullOrEmpty(this.NickName))?this.NickName:string.Empty),
                                        infra.DataDB.GetNewParameter("type", EbDbTypes.String, this.Type.ToString()),
                                        infra.DataDB.GetNewParameter("con_obj", EbDbTypes.Json,json),
                                        infra.DataDB.GetNewParameter("uid", EbDbTypes.Int32, UserId ),
                                        infra.DataDB.GetNewParameter("id", EbDbTypes.Int32, this.Id)
                                     };
            if (this.Id <= 0)
            {
                query = @"
                            INSERT INTO 
                                eb_integration_configs (solution_id, nickname, type, con_obj, created_by, created_at, eb_del) 
                            VALUES 
                                (@solution_id, @nick_name, @type, @con_obj, @uid, NOW() , 'F')
                            RETURNING 
                                id;";
                EbDataSet ds = infra.DataDB.DoQueries(query, parameters);
                nid = Convert.ToInt32(ds.Tables[0].Rows[0][0]);
            }
            else
            {
                query = @"
                            UPDATE 
                                eb_integration_configs 
                            SET 
                                modified_at = NOW(), 
                                modified_by = @uid, 
                                eb_del = 'T' 
                            WHERE 
                                id = @id;
                            INSERT INTO 
                                eb_integration_configs (solution_id, nickname, type, con_obj, created_by, created_at, eb_del) 
                            VALUES 
                                (@solution_id, @nick_name, @type, @con_obj, @uid, NOW() , 'F') 
                            RETURNING 
                                id;";
                EbDataSet ds = infra.DataDB.DoQueries(query, parameters);
                nid = Convert.ToInt32(ds.Tables[0].Rows[0][0]);
                if (this.Id != 0)
                {
                    query = @"UPDATE eb_integrations 
                            SET
                                eb_integration_conf_id = @nid
                            WHERE
                                eb_integration_conf_id = @oid; ";
                    DbParameter[] parameter = {
                                                infra.DataDB.GetNewParameter("nid", EbDbTypes.Int32, nid),
                                                infra.DataDB.GetNewParameter("oid", EbDbTypes.Int32, this.Id)
                                           };
                    infra.DataDB.DoNonQuery(query, parameter);
                }
            }
            return nid;
        }

        public int PersistConfDeleteIntegration(string Sol_Id, EbConnectionFactory infra, int UserId)
        {
            DbParameter[] parameters = {
                                        infra.DataDB.GetNewParameter("uid", EbDbTypes.Int32, UserId ),
                                        infra.DataDB.GetNewParameter("id", EbDbTypes.Int32, this.Id)
                                     };

            string query = @"
                            UPDATE 
                                eb_integration_configs 
                            SET 
                                modified_at = NOW(), 
                                modified_by = @uid, 
                                eb_del = 'T' 
                            WHERE 
                                id = @id;";
            int ds = infra.DataDB.DoNonQuery(query, parameters);
            return ds;
        }
    }

    public class EbDbConfig : EbIntegrationConf
    {
        public string DatabaseName { get; set; }

        public string Server { get; set; }

        public int Port { get; set; }

        public string UserName { get; set; }

        public string Password { get; set; }

        public int Timeout { get; set; }

        public bool IsSSL { get; set; }

        public string ReadWriteUserName { get; set; }

        public string ReadWritePassword { get; set; }

        public string ReadOnlyUserName { get; set; }

        public string ReadOnlyPassword { get; set; }

        public DatabaseVendors DatabaseVendor { get { return (DatabaseVendors)this.Type; } set { this.Type = (EbIntegrations)value; } }
    }

    public class PostgresConfig : EbDbConfig
    {
        public override EbIntegrations Type { get { return EbIntegrations.PGSQL; } }
    }

    public class OracleConfig : EbDbConfig
    {
        public override EbIntegrations Type { get { return EbIntegrations.ORACLE; } }
    }

    public class MySqlConfig : EbDbConfig
    {
        public override EbIntegrations Type { get { return EbIntegrations.MYSQL; } }
    }

    public class EbSmsConfig : EbIntegrationConf
    {
        public string UserName { get; set; }

        public string Password { get; set; }

        public string From { get; set; }
    }

    public class EbTwilioConfig : EbSmsConfig
    {
        public override EbIntegrations Type { get { return EbIntegrations.Twilio; } }
    }

    public class EbExpertTextingConfig : EbSmsConfig
    {
        public string ApiKey { get; set; }

        public override EbIntegrations Type { get { return EbIntegrations.ExpertTexting; } }
    }

    public class EbMongoConfig : EbIntegrationConf
    {
        public string UserName { get; set; }

        public string Password { get; set; }

        public string Host { get; set; }

        public int Port { get; set; }

        public override EbIntegrations Type { get { return EbIntegrations.MongoDB; } }
    }

    public class EbEmailConfig : EbIntegrationConf
    {
        public string EmailAddress { get; set; }
    }

    public class EbSmtpConfig : EbEmailConfig
    {
        public SmtpProviders ProviderName { get; set; }

        public string Host { get; set; }

        public int Port { get; set; }

        public string Password { get; set; }

        public bool EnableSsl { get; set; }

        public override EbIntegrations Type { get { return EbIntegrations.SMTP; } }
    }

    public class EbSendGridConfig : EbEmailConfig
    {
        public string ApiKey { get; set; }

        public string Name { get; set; }

        public override EbIntegrations Type { get; set; }
    }

    public class EbCloudinaryConfig : EbIntegrationConf
    {
        public string Cloud { get; set; }

        public string ApiKey { get; set; }

        public string ApiSecret { get; set; }

        public override EbIntegrations Type { get { return EbIntegrations.Cloudinary; } }
    }

    public class EbMapConfig : EbIntegrationConf
    {
        public string ApiKey { get; set; }

        public MapVendors Vendor { get; set; }

        public MapType MapType { get; set; }
    }
    public class EbDropBoxConfig : EbIntegrationConf
    {
        public string AccessToken { get; set; }

        public override EbIntegrations Type { get { return EbIntegrations.DropBox; } }
    }

    public class EbAWSS3Config : EbIntegrationConf
    {
        public string BucketName { get; set; }

        public string BucketRegion { get; set; }

        public string AccessKeyID { get; set; }

        public string SecretAccessKey { get; set; }

        public override EbIntegrations Type { get { return EbIntegrations.AWSS3; } }
    }

    public class EbGoogleDriveConfig : EbIntegrationConf
    {
        public string SolutionId { get; set; }

        public string ClientID { get; set; }

        public string Clientsecret { get; set; }

        public string RefreshToken { get; set; }

        public string ApplicationName { get; set; }

        public override EbIntegrations Type { get { return EbIntegrations.GoogleDrive; } }
    }

    public class EbSlackConfig : EbIntegrationConf
    {
        public string OAuthAccessToken { get; set; }

        public string Channel { get; set; }

        public override EbIntegrations Type { get { return EbIntegrations.Slack; } }
    }

    public class EbfacebbokConfig : EbIntegrationConf{

        public string AppId { get; set; }
        public string AppVersion { get; set; }
        public override EbIntegrations Type { get { return EbIntegrations.Facebook; } }
    }


    public class EbGoogleMapConfig : EbMapConfig
    {
        public override EbIntegrations Type { get { return EbIntegrations.GoogleMap; } }
    }


    public class EbIntegration
    {
        public int Id { get; set; }

        public int ConfigId { get; set; }

        public EbConnectionTypes Type { get; set; }

        public ConPreferences Preference { get; set; }

        public int PersistIntegration(string Sol_Id, EbConnectionFactory infra, int UserId)
        {
            int nid = 0;
            string query = @"INSERT INTO eb_integrations (solution_id, type, preference, eb_integration_conf_id, created_at, created_by, eb_del) 
                               VALUES (@solution_id, @type, @preference, @conf_id, NOW(), @uid, 'F') RETURNING id;";

            if (Id > 0)
                query += @"UPDATE eb_integrations SET eb_del = 'T', modified_at = NOW(), modified_by = @uid WHERE id = @id;";

            DbParameter[] parameters = {
                                                infra.DataDB.GetNewParameter("solution_id", EbDbTypes.String, Sol_Id),
                                                infra.DataDB.GetNewParameter("type", EbDbTypes.String, this.Type.ToString()),
                                                infra.DataDB.GetNewParameter("preference", EbDbTypes.Int32,(int)Preference),
                                                infra.DataDB.GetNewParameter("conf_id", EbDbTypes.Int32, this.ConfigId),
                                                infra.DataDB.GetNewParameter("uid", EbDbTypes.Int32, UserId),
                                                infra.DataDB.GetNewParameter("id", EbDbTypes.Int32, this.Id)
                                           };
            EbDataSet ds = infra.DataDB.DoQueries(query, parameters);
            nid = Convert.ToInt32(ds.Tables[0].Rows[0][0]);
            return nid;
        }

        public int PersistDeleteIntegration(string Sol_Id, EbConnectionFactory infra, int UserId)
        {
            string query = @"UPDATE eb_integrations SET eb_del = 'T', modified_at = NOW(), modified_by = @uid WHERE id = @id;";

            DbParameter[] parameters = {
                                                infra.DataDB.GetNewParameter("uid", EbDbTypes.Int32, UserId),
                                                infra.DataDB.GetNewParameter("id", EbDbTypes.Int32, this.Id)
                                           };
            int ds = infra.DataDB.DoNonQuery(query, parameters);
            return ds;
        }

    }
}

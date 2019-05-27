using System;
using System.Collections.Generic;
using System.Text;

namespace ExpressBase.Common
{
    public static class EnvironmentConstants
    {
        public const string ASPNETCORE_ENVIRONMENT = "ASPNETCORE_ENVIRONMENT";

        public const string EB_INFRASTRUCTURE = "EB_INFRASTRUCTURE";

        public const string EB_SERVICESTACK_EXT_URL = "EB_SERVICESTACK_EXT_URL";
        public const string EB_SERVICESTACK_INT_URL = "EB_SERVICESTACK_INT_URL";

        public const string EB_SERVEREVENTS_EXT_URL = "EB_SERVEREVENTS_EXT_URL";
        public const string EB_SERVEREVENTS_INT_URL = "EB_SERVEREVENTS_INT_URL";

        public const string EB_STATICFILESERVER_EXT_URL = "EB_STATICFILESERVER_EXT_URL";
        public const string EB_STATICFILESERVER_INT_URL = "EB_STATICFILESERVER_INT_URL";

        public const string EB_MQ_URL = "EB_MQ_URL";

        public const string EB_GET_ACCESS_TOKEN_URL = "EB_GET_ACCESS_TOKEN_URL";

        public const string EB_REDIS_SERVER = "EB_REDIS_SERVER";
        public const string EB_REDIS_PORT = "EB_REDIS_PORT";
        public const string EB_REDIS_PASSWORD = "EB_REDIS_PASSWORD";

        public const string EB_INFRA_DB_SERVER = "EB_INFRA_DB_SERVER";
        public const string EB_INFRA_DB_PORT = "EB_INFRA_DB_PORT";
        public const string EB_INFRA_DB_TIMEOUT = "EB_INFRA_DB_TIMEOUT";

        public const string EB_INFRA_DBNAME = "EB_INFRA_DBNAME";

        public const string EB_INFRA_DB_RO_USER = "EB_INFRA_DB_RO_USER";
        public const string EB_INFRA_DB_RO_PASSWORD = "EB_INFRA_DB_RO_PASSWORD";
        public const string EB_INFRA_DB_RW_USER = "EB_INFRA_DB_RW_USER";
        public const string EB_INFRA_DB_RW_PASSWORD = "EB_INFRA_DB_RW_PASSWORD";

        public const string EB_DATACENTRE_SERVER = "EB_DATACENTRE_SERVER";
        public const string EB_DATACENTRE_PORT = "EB_DATACENTRE_PORT";
        public const string EB_DATACENTRE_TIMEOUT = "EB_DATACENTRE_TIMEOUT";

        public const string EB_DATACENTRE_ADMIN_USER = "EB_DATACENTRE_ADMIN_USER";
        public const string EB_DATACENTRE_ADMIN_PASSWORD = "EB_DATACENTRE_ADMIN_PASSWORD";

        public const string EB_INFRA_FILES_DB_URL = "EB_INFRA_FILES_DB_URL";

        public const string EB_JWT_PRIVATE_KEY_XML = "EB_JWT_PRIVATE_KEY_XML";
        public const string EB_JWT_PUBLIC_KEY_XML = "EB_JWT_PUBLIC_KEY_XML";

        public const string EB_RABBIT_HOST = "EB_RABBIT_HOST";
        public const string EB_RABBIT_PORT = "EB_RABBIT_PORT";
        public const string EB_RABBIT_USER = "EB_RABBIT_USER";
        public const string EB_RABBIT_PASSWORD = "EB_RABBIT_PASSWORD";
        public const string EB_RABBIT_VHOST = "EB_RABBIT_VHOST";

        public const string EB_PAYPAL_USERID = "EB_PAYPAL_USERID";
        public const string EB_PAYPAL_USERSECRET = "EB_PAYPAL_USERSECRET";

        public const string EB_RECAPTCHA_KEY = "EB_RECAPTCHA_KEY";
        public const string EB_RECAPTCHA_SECRET = "EB_RECAPTCHA_SECRET";

        public const string EB_EMAIL_ADDRESS = "EB_EMAIL_ADDRESS";
        public const string EB_EMAIL_HOST = "EB_EMAIL_HOST";
        public const string EB_EMAIL_PASSWORD = "EB_EMAIL_PASSWORD";
        public const string EB_EMAIL_PORT = "EB_EMAIL_PORT";

        //For HOC Only
        public const string EB_FTP_HOST = "EB_FTP_HOST";
        public const string EB_FTP_USER = "EB_FTP_USER";
        public const string EB_FTP_PASSWORD = "EB_FTP_PASSWORD";
    }
}

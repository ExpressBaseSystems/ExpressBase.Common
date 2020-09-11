using System;
using System.Collections.Generic;
using System.Text;

namespace ExpressBase.Common
{
    public static class RoutingConstants
    {
        public const string LIVEHOSTADDRESS = "expressbase.com";
        public const string STAGEHOSTADDRESS = "eb-test.cloud";

        public const string LOCALHOST = "localhost";
        public const string WWWDOT = "www.";

        //DashBoard Routes
        public const string MYSOLUTIONS = "/MySolutions";
        public const string SOLUTIONSETTINGS = "/SolutionSettings";
        public const string MYAPPLICATIONS = "/MyApplications";
        public const string USERDASHBOARD = "/UserDashboard";


        //Controllers
        public const string CONTROLLER = "controller";
        public const string EXTCONTROLLER = "Ext";
        public const string EB_PRODUCTS = "EbProducts";

        //Actions
        public const string ACTION = "action";
        public const string INDEX = "Index";
        public const string USERSIGNIN2UC = "UsrSignIn";
        public const string TENANTSIGNIN = "TenantSignIn";

        public const string BEARER_TOKEN = "bToken";
        public const string REFRESH_TOKEN = "rToken";
        public const string PAYNOW = "/PayNow";
        public const string TWOFATOKEN = "Token";
        public const string RPWToken = "rpwToken";

		public const string BOT_BEARER_TOKEN = "bot_bToken";
		public const string BOT_REFRESH_TOKEN = "bot_rToken";

		//Console
		public const string WC = "wc";
        public const string TC = "tc";
        public const string UC = "uc";
        public const string DC = "dc";
        public const string MC = "mc";

        public const string USER_AGENT = "useragent";

        public const string MYACCOUNT = "myaccount";
        public const string DASHBOT = "-bot";
        public const string DASHMOB = "-mob";
        //public const string WEB = "-web";
        public const string DASHDEV = "-dev";


        public const int HOSTPARTSLEN_IS_3 = 3;
        public const int HOSTPARTSLEN_IS_2 = 2;

        //error url
        public const string EXTERROR = "/Ext/Error";

        //Reset PW
        public const string RESET_PASSWORD_PAGE = "/ResetPasswordIn";
    }
}

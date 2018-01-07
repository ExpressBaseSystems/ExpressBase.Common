using System;
using System.Collections.Generic;
using System.Text;

namespace ExpressBase.Common
{
    public class RoutingConstants
    {
        public const char DOT = '.';
        public const char BACKSLASH = '/';

        public const string LOCALHOST = "localhost";
        public const string WWWDOT = "www.";
        public const string EXPRESSBASEDOTCOM = "expressbase.com";
        public const string EBTESTINFO = "eb-test.info";

        //Controllers
        public const string CONTROLLER = "controller";
        public const string EXTCONTROLLER = "Ext";
        public const string EB_PRODUCTS = "EbProducts";

        //Actions
        public const string ACTION = "action";
        public const string INDEX = "Index";
        public const string USERSIGNIN2UC = "UsrSignIn";

        public const string BEARER_TOKEN = "bToken";
        public const string REFRESH_TOKEN = "rToken";

        public const int HOSTPARTSLEN_IS_3 = 3;
        public const int HOSTPARTSLEN_IS_2 = 2;

    }
}

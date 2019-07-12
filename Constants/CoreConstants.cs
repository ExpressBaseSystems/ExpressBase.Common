using System;
using System.Collections.Generic;
using System.Text;

namespace ExpressBase.Common.Constants
{
    public static class CoreConstants
    {
        public const string SOLUTION_ID = "TenantAccountId";
        public const string USER_ID = "UserId";
        public const string EXPRESSBASE = "expressbase";
        public const string ADMIN = "admin";


        public const string SOLUTION_CONNECTION_REDIS_KEY = "EbSolutionConnections_{0}";
        public const string SOLUTION_INTEGRATION_REDIS_KEY = "EbSolutionIntegrations_{0}";

        public const string STAGING = "Staging";
        public const string PRODUCTION = "Production";
        public const string DEVELOPMENT = "Development";

        //tenant type
        public const string DEVELOPER = "developer";
        public const string BUSINESS = "business";
    }
}

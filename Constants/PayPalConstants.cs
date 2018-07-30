using System;
using System.Collections.Generic;
using System.Text;

namespace ExpressBase.Common.Constants
{
    public class PayPalConstants
    {
        public const int Charge = 5;
        public const string UriString = "https://api.sandbox.paypal.com/";
        public const string OAuthTokenPath = UriString + "v1/oauth2/token";
        public const string AgreementUrl = UriString + "v1/payments/billing-agreements/";
        public const string BillingPlanPath = UriString + "v1/payments/billing-plans/";
    }
}

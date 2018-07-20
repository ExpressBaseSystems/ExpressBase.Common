using System;
using System.Collections.Generic;
using System.Text;

namespace ExpressBase.Common.Enums
{
    public enum PlanType
    {
        FIXED,
        INFINITE
    };

    public enum PlanState
    {
        CREATED,
        ACTIVE,
        INACTIVE
    };

    public enum TermType
    {
        MONTHLY,
        WEEKLY,
        YEARLY
    };

    public enum PaymentMethod
    {
        bank,
        paypal
    };

    public enum CardState
    {
        expired,
        ok
    };
}

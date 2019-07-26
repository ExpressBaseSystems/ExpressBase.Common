using System;
using System.Collections.Generic;
using System.Text;
using ServiceStack.Stripe.Types;

namespace ExpressBase.Common.Stripe
{
    public class Eb_StripeUpcomingInvoiceList
    {
        public DateTime Date { get; set; }

        public int Total { get; set; }

        public int? PercentOff { get; set; }

        public StripeCouponDuration Duration { get; set; }

        public string Currency { get; set; }

        public string CouponId { get; set; }

        public List<Eb_StripeUpcomingInvoice> Data { get; set; }
    }

    public class Eb_StripeUpcomingInvoice
    {
        public int Amount { get; set; }

        public string Type { get; set; }

        public string Description { get; set; }

        public DateTime PeriodEnd { get; set; }

        public DateTime PeriodStart { get; set; }

        public string PlanId { get; set; }

        public int? Quantity { get; set; }
        
    }

    public class Eb_StripeInvoice
    {
        public string Id { get; set; }

        public string PlanId { get; set; }

        public int Amount { get; set; }

        public DateTime Date { get; set; }

        public int SubTotal { get; set; }

        public int Total { get; set; }

        public string Type { get; set; }

        public string Description { get; set; }

        public string Currency { get; set; }

        public int? Quantity { get; set; }

        public string Url { get; set; }

        public string InvNumber { get; set; }

        public bool Status { get; set; }

        public DateTime PeriodStart { get; set; }

        public DateTime PeriodEnd { get; set; }

        public StripeCouponDuration Duration { get; set; }

        public int? PercentOff { get; set; }
    }

    public class Eb_StripeInvoiceList
    {
        public List<Eb_StripeInvoice> List { get; set; }
    }

    public class Eb_StripePlans
    {
        public int Amount { get; set; }

        public string Currency { get; set; }

        public string Id { get; set; }

        public StripePlanInterval Interval { get; set; }

        public int? Interval_count { get; set; }
    }

    public class Eb_StripePlansList
    {
        public List<Eb_StripePlans> Plans { get; set; }
    }

    public class Eb_StripeCards
    {
        public string CardId { get; set; }

        public string Last4 { get; set; }

        public long ExpMonth { get; set; }
        
        public long ExpYear { get; set; }
    }

    public class Eb_StripeCardsList
    {
        public List<Eb_StripeCards> Card { get; set; }
    }

   
}

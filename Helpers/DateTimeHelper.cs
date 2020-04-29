using ExpressBase.Common.Extensions;
using System;
using System.Collections.Generic;
using System.Text;

namespace ExpressBase.Common.Helpers
{
    public static class DateTimeHelper
    {
        public static DateTime StartOfDay(this DateTime theDate)
        {
            return theDate.Date;
        }

        public static DateTime EndOfDay(this DateTime theDate)
        {
            return theDate.Date.AddDays(1).AddTicks(-1);
        }

        public static bool IsBewteenTwoDates(this DateTime dateToCheck, DateTime startDate, DateTime endDate)
        {
            return dateToCheck >= startDate && dateToCheck <= endDate;
        }

        public static string DateInNotification(this DateTime DateTime, string TimeZoneName)
        {
            DateTime = DateTime.ConvertFromUtc(TimeZoneName);
            TimeSpan span = (DateTime.Now - DateTime);
            string formatted = string.Empty;
            if ((int)span.TotalMinutes < 5)
                formatted = "Just Now";
            else
                formatted = string.Format("{0}{1}{2}",
                span.Duration().Days > 0 ? string.Format("{0}d ", span.Days) : string.Empty,
                span.Duration().Hours > 0 ? string.Format("{0}h ", span.Hours) : string.Empty,
                span.Duration().Minutes > 0 ? string.Format("{0}m ", span.Minutes) : string.Empty);

            return formatted;
        }
    }
}

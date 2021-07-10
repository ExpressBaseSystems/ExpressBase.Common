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

        public static string TimeAgo(this DateTime dateTime)
        {
            string result;
            var timeSpan = DateTime.UtcNow.Subtract(dateTime);

            if (timeSpan <= TimeSpan.FromSeconds(60))
            {
                result = "Just now";
            }
            else if (timeSpan <= TimeSpan.FromMinutes(60))
            {
                result = timeSpan.Minutes > 2 ?
                    String.Format("{0} minutes ago", timeSpan.Minutes) :
                    "a minute ago";
            }
            else if (timeSpan <= TimeSpan.FromHours(24))
            {
                result = timeSpan.Hours > 2 ?
                    String.Format("{0} hours ago", timeSpan.Hours) :
                    "an hour ago";
            }
            else if (timeSpan <= TimeSpan.FromDays(30))
            {
                result = timeSpan.Days > 2 ?
                    String.Format("{0} days ago", timeSpan.Days) :
                    "yesterday";
            }
            else if (timeSpan <= TimeSpan.FromDays(365))
            {
                result = timeSpan.Days > 60 ?
                    String.Format("{0} months ago", timeSpan.Days / 30) :
                    "a month ago";
            }
            else
            {
                result = timeSpan.Days > 730 ?
                    String.Format("{0} years ago", timeSpan.Days / 365) :
                    "a year ago";
            }

            return result;
        }

    }
}

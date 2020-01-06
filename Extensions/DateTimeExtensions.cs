﻿using ExpressBase.Common.Singletons;
using System;
using System.Collections.Generic;
using System.Text;

namespace ExpressBase.Common.Extensions
{
    public static class DateTimeExtensions
    {
        public static DateTime ConvertToUtc(this DateTime DateTime, string TimeZone)
        {
            return DateTime.Add(GetDifference(TimeZone));
        }

        public static DateTime ConvertFromUtc(this DateTime DateTime, string TimeZone)
        {
            return DateTime.Add(GetDifference(TimeZone, true));
        }

        //return time difference in timespan between utc and given timezone
        //To convert utc to another timezone then pass Negate as true - assumption: Using DateTime.Add()
        //To convert time in given timezone to utc then neglect Negate paremeter - assumption: Using DateTime.Add()
        private static TimeSpan GetDifference(string TimeZoneName, bool Negate = false)
        {
            int _hour = 0, _min = 0;
            int op = Negate ? -1 : 1;
            try
            {
                if (TimeZoneName.Length > 10)
                {
                    if (TimeZoneName.Substring(4, 1).Equals("+"))
                    {
                        op *= -1;
                    }
                    _hour = Convert.ToInt32(TimeZoneName.Substring(5, 2)) * op;
                    _min = Convert.ToInt32(TimeZoneName.Substring(8, 2)) * op;
                }
            }
            catch (Exception ex)
            {
                //Console.WriteLine("From GetTimeSpanDifference - Please set a TimeZone in user preference");
            }

            return new TimeSpan(_hour, _min, 0);
        }
    }
}

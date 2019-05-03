using System;
using System.Collections.Generic;
using System.Globalization;
using System.Text;

namespace ExpressBase.Common.Helpers
{
    public class SerializedDateTimeFormatInfo
    {
        public void PopulateFromCultureInfo(CultureInfo Culture)
        {
            this.AbbreviatedDayNames = Culture.DateTimeFormat.AbbreviatedDayNames;
            this.AbbreviatedMonthGenitiveNames = Culture.DateTimeFormat.AbbreviatedMonthGenitiveNames;
            this.AbbreviatedMonthNames = Culture.DateTimeFormat.AbbreviatedMonthNames;
            this.AMDesignator = Culture.DateTimeFormat.AMDesignator;
            this.CalendarWeekRule = Culture.DateTimeFormat.CalendarWeekRule;
            this.DateSeparator = Culture.DateTimeFormat.DateSeparator;
            this.DayNames = Culture.DateTimeFormat.DayNames;
            this.FirstDayOfWeek = Culture.DateTimeFormat.FirstDayOfWeek;
            this.FullDateTimePattern = Culture.DateTimeFormat.FullDateTimePattern;
            this.LongDatePattern = Culture.DateTimeFormat.LongDatePattern;
            this.LongTimePattern = Culture.DateTimeFormat.LongTimePattern;
            this.MonthDayPattern = Culture.DateTimeFormat.MonthDayPattern;
            this.MonthGenitiveNames = Culture.DateTimeFormat.MonthGenitiveNames;
            this.MonthNames = Culture.DateTimeFormat.MonthNames;
            this.PMDesignator = Culture.DateTimeFormat.PMDesignator;
            this.ShortDatePattern = Culture.DateTimeFormat.ShortDatePattern;
            this.ShortestDayNames = Culture.DateTimeFormat.ShortestDayNames;
            this.ShortTimePattern = Culture.DateTimeFormat.ShortTimePattern;
            this.TimeSeparator = Culture.DateTimeFormat.TimeSeparator;
            this.YearMonthPattern = Culture.DateTimeFormat.YearMonthPattern;
        }
        public void PopulateIntoCultureInfo(CultureInfo Culture)
        {
            Culture.DateTimeFormat.AbbreviatedDayNames = this.AbbreviatedDayNames;
            Culture.DateTimeFormat.AbbreviatedMonthGenitiveNames = this.AbbreviatedMonthGenitiveNames;
            Culture.DateTimeFormat.AbbreviatedMonthNames = this.AbbreviatedMonthNames;
            Culture.DateTimeFormat.AMDesignator = this.AMDesignator;
            Culture.DateTimeFormat.CalendarWeekRule = this.CalendarWeekRule;
            Culture.DateTimeFormat.DateSeparator = this.DateSeparator;
            Culture.DateTimeFormat.DayNames = this.DayNames;
            Culture.DateTimeFormat.FirstDayOfWeek = this.FirstDayOfWeek;
            Culture.DateTimeFormat.FullDateTimePattern = this.FullDateTimePattern;
            Culture.DateTimeFormat.LongDatePattern = this.LongDatePattern;
            Culture.DateTimeFormat.LongTimePattern = this.LongTimePattern;
            Culture.DateTimeFormat.MonthDayPattern = this.MonthDayPattern;
            Culture.DateTimeFormat.MonthGenitiveNames = this.MonthGenitiveNames;
            Culture.DateTimeFormat.MonthNames = this.MonthNames;
            Culture.DateTimeFormat.PMDesignator = this.PMDesignator;
            Culture.DateTimeFormat.ShortDatePattern = this.ShortDatePattern;
            Culture.DateTimeFormat.ShortestDayNames = this.ShortestDayNames;
            Culture.DateTimeFormat.ShortTimePattern = this.ShortTimePattern;
            Culture.DateTimeFormat.TimeSeparator = this.TimeSeparator;
            Culture.DateTimeFormat.YearMonthPattern = this.YearMonthPattern;
        }
        public string ShortTimePattern { get; set; }
        public string[] DayNames { get; set; }
        public DayOfWeek FirstDayOfWeek { get; set; }
        public string FullDateTimePattern { get; set; }
        public string TimeSeparator { get; set; }
        public string LongDatePattern { get; set; }
        public string LongTimePattern { get; set; }
        public string MonthDayPattern { get; set; }
        public string DateSeparator { get; set; }
        public string[] MonthNames { get; set; }
        public string PMDesignator { get; set; }
        public string ShortDatePattern { get; set; }
        public string[] ShortestDayNames { get; set; }
        public string[] MonthGenitiveNames { get; set; }
        public CalendarWeekRule CalendarWeekRule { get; set; }
        public string UniversalSortableDateTimePattern { get; }
        public string[] AbbreviatedDayNames { get; set; }
        public string YearMonthPattern { get; set; }
        public string[] AbbreviatedMonthNames { get; set; }
        public string AMDesignator { get; set; }
        public string[] AbbreviatedMonthGenitiveNames { get; set; }
    }
}

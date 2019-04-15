using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Globalization;
using System.IO;

namespace ExpressBase.Common.Singletons
{
	public class CultureHelper
	{
		private const double myNum = 437164912.56;

		private CultureHelper() { }

		private static Culture[] mycultures = null;
		public static Culture[] Cultures
		{
			get
			{
				if (mycultures == null)
				{
					var cults = CultureInfo.GetCultures(CultureTypes.AllCultures);
					mycultures = new Culture[cults.Length - 1];

					for (var i = 1; i < cults.Length; i++)
					{
						mycultures[i - 1] = new Culture
						{
							Name = cults[i].Name,
							NativeName = cults[i].NativeName,
							EnglishName = cults[i].EnglishName,
							NumberFormat = myNum.ToString("C", cults[i]),
							DateFormat = DateTime.Now.ToString(cults[i])
						};
					}
				}

				return mycultures;
			}
		}

        private static Dictionary<string, SerializedCulture> cultureinfos = new Dictionary<string, SerializedCulture>();

        public static SerializedCulture GetCultureInfo(string CultureName)
        {            
            if (!cultureinfos.ContainsKey(CultureName))
            {
                var Serialized = new JsonSerializer();
                using (var Stream = System.Reflection.Assembly.GetExecutingAssembly().GetManifestResourceStream("ExpressBase.Common.cultures." + CultureName.ToLower() + ".json"))
                {
                    if (Stream == null)
                        return null;
                    using (var StreamReader = new StreamReader(Stream, System.Text.Encoding.UTF32))
                    using (var JsonTextReader = new JsonTextReader(StreamReader))
                    {
                        cultureinfos.Add(CultureName, Serialized.Deserialize<SerializedCulture>(JsonTextReader));
                    }
                }
            }
            return cultureinfos[CultureName];
        }

		public static string __culturesAsJson = null;
		public static string CulturesAsJson
		{
			get
			{
				if (__culturesAsJson == null)
					__culturesAsJson = JsonConvert.SerializeObject(Cultures);

				return __culturesAsJson;
			}
		}

		//Because of detailed timezone name is not available on linux machine, it is hardcoded.
		public static readonly TimeZone[] Timezones =
		{
			new TimeZone { Name = "(UTC-12:00) International Date Line West" },
			new TimeZone { Name = "(UTC-11:00) Coordinated Universal Time-11" },
			new TimeZone { Name = "(UTC-10:00) Aleutian Islands" },
			new TimeZone { Name = "(UTC-10:00) Hawaii" },
			new TimeZone { Name = "(UTC-09:30) Marquesas Islands" },
			new TimeZone { Name = "(UTC-09:00) Alaska" },
			new TimeZone { Name = "(UTC-09:00) Coordinated Universal Time-09" },
			new TimeZone { Name = "(UTC-08:00) Baja California" },
			new TimeZone { Name = "(UTC-08:00) Coordinated Universal Time-08" },
			new TimeZone { Name = "(UTC-08:00) Pacific Time (US & Canada)" },
			new TimeZone { Name = "(UTC-07:00) Arizona" },
			new TimeZone { Name = "(UTC-07:00) Chihuahua, La Paz, Mazatlan" },
			new TimeZone { Name = "(UTC-07:00) Mountain Time (US & Canada)" },
			new TimeZone { Name = "(UTC-06:00) Central America" },
			new TimeZone { Name = "(UTC-06:00) Central Time (US & Canada)" },
			new TimeZone { Name = "(UTC-06:00) Easter Island" },
			new TimeZone { Name = "(UTC-06:00) Guadalajara, Mexico City, Monterrey" },
			new TimeZone { Name = "(UTC-06:00) Saskatchewan" },
			new TimeZone { Name = "(UTC-05:00) Bogota, Lima, Quito, Rio Branco" },
			new TimeZone { Name = "(UTC-05:00) Chetumal" },
			new TimeZone { Name = "(UTC-05:00) Eastern Time (US & Canada)" },
			new TimeZone { Name = "(UTC-05:00) Haiti" },
			new TimeZone { Name = "(UTC-05:00) Havana" },
			new TimeZone { Name = "(UTC-05:00) Indiana (East)" },
			new TimeZone { Name = "(UTC-05:00) Turks and Caicos" },
			new TimeZone { Name = "(UTC-04:00) Asuncion" },
			new TimeZone { Name = "(UTC-04:00) Atlantic Time (Canada)" },
			new TimeZone { Name = "(UTC-04:00) Caracas" },
			new TimeZone { Name = "(UTC-04:00) Cuiaba" },
			new TimeZone { Name = "(UTC-04:00) Georgetown, La Paz, Manaus, San Juan" },
			new TimeZone { Name = "(UTC-04:00) Santiago" },
			new TimeZone { Name = "(UTC-03:30) Newfoundland" },
			new TimeZone { Name = "(UTC-03:00) Araguaina" },
			new TimeZone { Name = "(UTC-03:00) Brasilia" },
			new TimeZone { Name = "(UTC-03:00) Cayenne, Fortaleza" },
			new TimeZone { Name = "(UTC-03:00) City of Buenos Aires" },
			new TimeZone { Name = "(UTC-03:00) Greenland" },
			new TimeZone { Name = "(UTC-03:00) Montevideo" },
			new TimeZone { Name = "(UTC-03:00) Punta Arenas" },
			new TimeZone { Name = "(UTC-03:00) Saint Pierre and Miquelon" },
			new TimeZone { Name = "(UTC-03:00) Salvador" },
			new TimeZone { Name = "(UTC-02:00) Coordinated Universal Time-02" },
			new TimeZone { Name = "(UTC-02:00) Mid-Atlantic - Old" },
			new TimeZone { Name = "(UTC-01:00) Azores" },
			new TimeZone { Name = "(UTC-01:00) Cabo Verde Is." },
			new TimeZone { Name = "(UTC) Coordinated Universal Time" },
			new TimeZone { Name = "(UTC+00:00) Casablanca" },
			new TimeZone { Name = "(UTC+00:00) Dublin, Edinburgh, Lisbon, London" },
			new TimeZone { Name = "(UTC+00:00) Monrovia, Reykjavik" },
			new TimeZone { Name = "(UTC+01:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna" },
			new TimeZone { Name = "(UTC+01:00) Belgrade, Bratislava, Budapest, Ljubljana, Prague" },
			new TimeZone { Name = "(UTC+01:00) Brussels, Copenhagen, Madrid, Paris" },
			new TimeZone { Name = "(UTC+01:00) Sao Tome" },
			new TimeZone { Name = "(UTC+01:00) Sarajevo, Skopje, Warsaw, Zagreb" },
			new TimeZone { Name = "(UTC+01:00) West Central Africa" },
			new TimeZone { Name = "(UTC+02:00) Amman" },
			new TimeZone { Name = "(UTC+02:00) Athens, Bucharest" },
			new TimeZone { Name = "(UTC+02:00) Beirut" },
			new TimeZone { Name = "(UTC+02:00) Cairo" },
			new TimeZone { Name = "(UTC+02:00) Chisinau" },
			new TimeZone { Name = "(UTC+02:00) Damascus" },
			new TimeZone { Name = "(UTC+02:00) Gaza, Hebron" },
			new TimeZone { Name = "(UTC+02:00) Harare, Pretoria" },
			new TimeZone { Name = "(UTC+02:00) Helsinki, Kyiv, Riga, Sofia, Tallinn, Vilnius" },
			new TimeZone { Name = "(UTC+02:00) Jerusalem" },
			new TimeZone { Name = "(UTC+02:00) Kaliningrad" },
			new TimeZone { Name = "(UTC+02:00) Khartoum" },
			new TimeZone { Name = "(UTC+02:00) Tripoli" },
			new TimeZone { Name = "(UTC+02:00) Windhoek" },
			new TimeZone { Name = "(UTC+03:00) Baghdad" },
			new TimeZone { Name = "(UTC+03:00) Istanbul" },
			new TimeZone { Name = "(UTC+03:00) Kuwait, Riyadh" },
			new TimeZone { Name = "(UTC+03:00) Minsk" },
			new TimeZone { Name = "(UTC+03:00) Moscow, St. Petersburg, Volgograd" },
			new TimeZone { Name = "(UTC+03:00) Nairobi" },
			new TimeZone { Name = "(UTC+03:30) Tehran" },
			new TimeZone { Name = "(UTC+04:00) Abu Dhabi, Muscat" },
			new TimeZone { Name = "(UTC+04:00) Astrakhan, Ulyanovsk" },
			new TimeZone { Name = "(UTC+04:00) Baku" },
			new TimeZone { Name = "(UTC+04:00) Izhevsk, Samara" },
			new TimeZone { Name = "(UTC+04:00) Port Louis" },
			new TimeZone { Name = "(UTC+04:00) Saratov" },
			new TimeZone { Name = "(UTC+04:00) Tbilisi" },
			new TimeZone { Name = "(UTC+04:00) Yerevan" },
			new TimeZone { Name = "(UTC+04:30) Kabul" },
			new TimeZone { Name = "(UTC+05:00) Ashgabat, Tashkent" },
			new TimeZone { Name = "(UTC+05:00) Ekaterinburg" },
			new TimeZone { Name = "(UTC+05:00) Islamabad, Karachi" },
			new TimeZone { Name = "(UTC+05:30) Chennai, Kolkata, Mumbai, New Delhi" },
			new TimeZone { Name = "(UTC+05:30) Sri Jayawardenepura" },
			new TimeZone { Name = "(UTC+05:45) Kathmandu" },
			new TimeZone { Name = "(UTC+06:00) Astana" },
			new TimeZone { Name = "(UTC+06:00) Dhaka" },
			new TimeZone { Name = "(UTC+06:00) Omsk" },
			new TimeZone { Name = "(UTC+06:30) Yangon (Rangoon)" },
			new TimeZone { Name = "(UTC+07:00) Bangkok, Hanoi, Jakarta" },
			new TimeZone { Name = "(UTC+07:00) Barnaul, Gorno-Altaysk" },
			new TimeZone { Name = "(UTC+07:00) Hovd" },
			new TimeZone { Name = "(UTC+07:00) Krasnoyarsk" },
			new TimeZone { Name = "(UTC+07:00) Novosibirsk" },
			new TimeZone { Name = "(UTC+07:00) Tomsk" },
			new TimeZone { Name = "(UTC+08:00) Beijing, Chongqing, Hong Kong, Urumqi" },
			new TimeZone { Name = "(UTC+08:00) Irkutsk" },
			new TimeZone { Name = "(UTC+08:00) Kuala Lumpur, Singapore" },
			new TimeZone { Name = "(UTC+08:00) Perth" },
			new TimeZone { Name = "(UTC+08:00) Taipei" },
			new TimeZone { Name = "(UTC+08:00) Ulaanbaatar" },
			new TimeZone { Name = "(UTC+08:45) Eucla" },
			new TimeZone { Name = "(UTC+09:00) Chita" },
			new TimeZone { Name = "(UTC+09:00) Osaka, Sapporo, Tokyo" },
			new TimeZone { Name = "(UTC+09:00) Pyongyang" },
			new TimeZone { Name = "(UTC+09:00) Seoul" },
			new TimeZone { Name = "(UTC+09:00) Yakutsk" },
			new TimeZone { Name = "(UTC+09:30) Adelaide" },
			new TimeZone { Name = "(UTC+09:30) Darwin" },
			new TimeZone { Name = "(UTC+10:00) Brisbane" },
			new TimeZone { Name = "(UTC+10:00) Canberra, Melbourne, Sydney" },
			new TimeZone { Name = "(UTC+10:00) Guam, Port Moresby" },
			new TimeZone { Name = "(UTC+10:00) Hobart" },
			new TimeZone { Name = "(UTC+10:00) Vladivostok" },
			new TimeZone { Name = "(UTC+10:30) Lord Howe Island" },
			new TimeZone { Name = "(UTC+11:00) Bougainville Island" },
			new TimeZone { Name = "(UTC+11:00) Chokurdakh" },
			new TimeZone { Name = "(UTC+11:00) Magadan" },
			new TimeZone { Name = "(UTC+11:00) Norfolk Island" },
			new TimeZone { Name = "(UTC+11:00) Sakhalin" },
			new TimeZone { Name = "(UTC+11:00) Solomon Is., New Caledonia" },
			new TimeZone { Name = "(UTC+12:00) Anadyr, Petropavlovsk-Kamchatsky" },
			new TimeZone { Name = "(UTC+12:00) Auckland, Wellington" },
			new TimeZone { Name = "(UTC+12:00) Coordinated Universal Time+12" },
			new TimeZone { Name = "(UTC+12:00) Fiji" },
			new TimeZone { Name = "(UTC+12:00) Petropavlovsk-Kamchatsky - Old" },
			new TimeZone { Name = "(UTC+12:45) Chatham Islands" },
			new TimeZone { Name = "(UTC+13:00) Coordinated Universal Time+13" },
			new TimeZone { Name = "(UTC+13:00) Nuku'alofa" },
			new TimeZone { Name = "(UTC+13:00) Samoa" },
			new TimeZone { Name = "(UTC+14:00) Kiritimati Island" }
		};

		public static string __timezonesAsJson = null;
		public static string TimezonesAsJson
		{
			get
			{
				if (__timezonesAsJson == null)
					__timezonesAsJson = JsonConvert.SerializeObject(Timezones);

				return __timezonesAsJson;
			}
		}

        //return time difference in timespan between utc and given timezone
        //To convert utc to another timezone then pass Negate as true - assumption: Using DateTime.Add()
        //To convert time in given timezone to utc then neglect Negate paremeter - assumption: Using DateTime.Add()
        public static TimeSpan GetDifference(string TimeZoneName, bool Negate = false)
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
			catch(Exception ex)
			{
				Console.WriteLine("Exception in GetTimeSpanDifference : " + ex.Message); 
			}
			
			return new TimeSpan(_hour, _min, 0);
		}
	}

	public class Culture
	{
		public string Name { get; set; }
		public string NativeName { get; set; }
		public string EnglishName { get; set; }
		public string NumberFormat { get; set; }
		public string DateFormat { get; set; }
	}

	public class TimeZone
	{
		public string Name { get; set; }
	}


    public class SerializedNumberFormatInfo
    {
        public void PopulateFromCultureInfo(System.Globalization.CultureInfo Culture)
        {
            this.CurrencyDecimalDigits = Culture.NumberFormat.CurrencyDecimalDigits;
            this.CurrencyDecimalSeparator = Culture.NumberFormat.CurrencyDecimalSeparator;
            this.CurrencyGroupSeparator = Culture.NumberFormat.CurrencyGroupSeparator;
            this.CurrencyGroupSizes = Culture.NumberFormat.CurrencyGroupSizes;
            this.CurrencyNegativePattern = Culture.NumberFormat.CurrencyNegativePattern;
            this.CurrencyPositivePattern = Culture.NumberFormat.CurrencyPositivePattern;
            this.CurrencySymbol = Culture.NumberFormat.CurrencySymbol;
            this.DigitSubstitution = Culture.NumberFormat.DigitSubstitution;
            this.NaNSymbol = Culture.NumberFormat.NaNSymbol;
            this.NativeDigits = Culture.NumberFormat.NativeDigits;
            this.NegativeInfinitySymbol = Culture.NumberFormat.NegativeInfinitySymbol;
            this.NegativeSign = Culture.NumberFormat.NegativeSign;
            this.NumberDecimalDigits = Culture.NumberFormat.NumberDecimalDigits;
            this.NumberDecimalSeparator = Culture.NumberFormat.NumberDecimalSeparator;
            this.NumberGroupSeparator = Culture.NumberFormat.NumberGroupSeparator;
            this.NumberGroupSizes = Culture.NumberFormat.NumberGroupSizes;
            this.NumberNegativePattern = Culture.NumberFormat.NumberNegativePattern;
            this.PercentDecimalDigits = Culture.NumberFormat.PercentDecimalDigits;
            this.PercentDecimalSeparator = Culture.NumberFormat.PercentDecimalSeparator;
            this.PercentGroupSeparator = Culture.NumberFormat.PercentGroupSeparator;
            this.PercentGroupSizes = Culture.NumberFormat.PercentGroupSizes;
            this.PercentNegativePattern = Culture.NumberFormat.PercentNegativePattern;
            this.PercentPositivePattern = Culture.NumberFormat.PercentPositivePattern;
            this.PercentSymbol = Culture.NumberFormat.PercentSymbol;
            this.PerMilleSymbol = Culture.NumberFormat.PerMilleSymbol;
            this.PositiveInfinitySymbol = Culture.NumberFormat.PositiveInfinitySymbol;
            this.PositiveSign = Culture.NumberFormat.PositiveSign;
        }
        public void PopulateIntoCultureInfo(System.Globalization.CultureInfo Culture)
        {
            Culture.NumberFormat.CurrencyDecimalDigits = this.CurrencyDecimalDigits;
            Culture.NumberFormat.CurrencyDecimalSeparator = this.CurrencyDecimalSeparator;
            Culture.NumberFormat.CurrencyGroupSeparator = this.CurrencyGroupSeparator;
            Culture.NumberFormat.CurrencyGroupSizes = this.CurrencyGroupSizes;
            Culture.NumberFormat.CurrencyNegativePattern = this.CurrencyNegativePattern;
            Culture.NumberFormat.CurrencyPositivePattern = this.CurrencyPositivePattern;
            Culture.NumberFormat.CurrencySymbol = this.CurrencySymbol;
            Culture.NumberFormat.DigitSubstitution = this.DigitSubstitution;
            Culture.NumberFormat.NaNSymbol = this.NaNSymbol;
            Culture.NumberFormat.NativeDigits = this.NativeDigits;
            Culture.NumberFormat.NegativeInfinitySymbol = this.NegativeInfinitySymbol;
            Culture.NumberFormat.NegativeSign = this.NegativeSign;
            Culture.NumberFormat.NumberDecimalDigits = this.NumberDecimalDigits;
            Culture.NumberFormat.NumberDecimalSeparator = this.NumberDecimalSeparator;
            Culture.NumberFormat.NumberGroupSeparator = this.NumberGroupSeparator;
            Culture.NumberFormat.NumberGroupSizes = this.NumberGroupSizes;
            Culture.NumberFormat.NumberNegativePattern = this.NumberNegativePattern;
            Culture.NumberFormat.PercentDecimalDigits = this.PercentDecimalDigits;
            Culture.NumberFormat.PercentDecimalSeparator = this.PercentDecimalSeparator;
            Culture.NumberFormat.PercentGroupSeparator = this.PercentGroupSeparator;
            Culture.NumberFormat.PercentGroupSizes = this.PercentGroupSizes;
            Culture.NumberFormat.PercentNegativePattern = this.PercentNegativePattern;
            Culture.NumberFormat.PercentPositivePattern = this.PercentPositivePattern;
            Culture.NumberFormat.PercentSymbol = this.PercentSymbol;
            Culture.NumberFormat.PerMilleSymbol = this.PerMilleSymbol;
            Culture.NumberFormat.PositiveInfinitySymbol = this.PositiveInfinitySymbol;
            Culture.NumberFormat.PositiveSign = this.PositiveSign;
        }
        public int NumberDecimalDigits { get; set; }
        public string NumberDecimalSeparator { get; set; }
        public string NumberGroupSeparator { get; set; }
        public int[] NumberGroupSizes { get; set; }
        public int NumberNegativePattern { get; set; }
        public int PercentDecimalDigits { get; set; }
        public string PercentDecimalSeparator { get; set; }
        public string PercentGroupSeparator { get; set; }
        public int[] PercentGroupSizes { get; set; }
        public int PercentNegativePattern { get; set; }
        public int PercentPositivePattern { get; set; }
        public string PercentSymbol { get; set; }
        public string PerMilleSymbol { get; set; }
        public string NegativeSign { get; set; }
        public string NegativeInfinitySymbol { get; set; }
        public string[] NativeDigits { get; set; }
        public string NaNSymbol { get; set; }
        public DigitShapes DigitSubstitution { get; set; }
        public string CurrencySymbol { get; set; }
        public int CurrencyPositivePattern { get; set; }
        public int CurrencyNegativePattern { get; set; }
        public int[] CurrencyGroupSizes { get; set; }
        public string CurrencyGroupSeparator { get; set; }
        public string CurrencyDecimalSeparator { get; set; }
        public int CurrencyDecimalDigits { get; set; }
        public string PositiveInfinitySymbol { get; set; }
        public string PositiveSign { get; set; }
    }

    public class SerializedDateTimeFormatInfo
    {
        public void PopulateFromCultureInfo(System.Globalization.CultureInfo Culture)
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
        public void PopulateIntoCultureInfo(System.Globalization.CultureInfo Culture)
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

    public class SerializedCulture
    {
        public SerializedNumberFormatInfo NumberFormatInfo { get; set; }
        public SerializedDateTimeFormatInfo DateTimeFormatInfo { get; set; }
    }

}

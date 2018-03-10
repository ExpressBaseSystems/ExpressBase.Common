using Newtonsoft.Json;
using System;
using System.Collections.ObjectModel;
using System.Globalization;

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

		private static TimeZone[] mytimezones = null;
		public static TimeZone[] Timezones
		{
			get
			{
				if (mytimezones == null)
				{
					ReadOnlyCollection<TimeZoneInfo> tmzs = TimeZoneInfo.GetSystemTimeZones();
					mytimezones = new TimeZone[tmzs.Count];
					for (var i = 0; i < tmzs.Count; i++)
						mytimezones[i] = new TimeZone { Name = tmzs[i].DisplayName };
				}

				return mytimezones;
			}
		}

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
}

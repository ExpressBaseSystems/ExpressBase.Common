using ExpressBase.Common.Helpers;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Text;

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

        public static SerializedCulture GetSerializedCultureInfo(string CultureName)
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


    //public static class CultureJsonBuilder
    //{
    //    public static void ExportCultures()
    //    {
    //        foreach (var Culture in System.Globalization.CultureInfo.GetCultures(System.Globalization.CultureTypes.AllCultures))
    //        {
    //            if (!string.IsNullOrEmpty(Culture.Name))
    //                ExportCulture(Culture);
    //        }
    //    }
    //    static void ExportCulture(System.Globalization.CultureInfo Culture)
    //    {
    //        var Details = new SerializedCulture
    //        {
    //            NumberFormatInfo = new SerializedNumberFormatInfo(),
    //            DateTimeFormatInfo = new SerializedDateTimeFormatInfo()
    //        };
    //        Details.NumberFormatInfo.PopulateFromCultureInfo(Culture);
    //        Details.DateTimeFormatInfo.PopulateFromCultureInfo(Culture);
    //        var JSON = Newtonsoft.Json.JsonConvert.SerializeObject(Details, Newtonsoft.Json.Formatting.None);
    //        System.IO.Directory.CreateDirectory(System.IO.Path.Combine(System.AppContext.BaseDirectory, "culturestest"));
    //        System.IO.File.WriteAllText(System.IO.Path.Combine(System.AppContext.BaseDirectory, "culturestest", Culture.Name.ToLower() + ".json"), JSON, System.Text.Encoding.UTF32);
    //    }
    //}

}

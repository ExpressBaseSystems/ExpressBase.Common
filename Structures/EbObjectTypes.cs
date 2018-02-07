using ExpressBase.Common.Constants;
using System;
using System.Collections.Generic;
using System.Text;

namespace ExpressBase.Common.Structures
{
	public struct EbObjectType
	{
		public readonly string Name;
		public readonly int IntCode;
		public readonly string BMW;
		public readonly bool IsUserFacing;

		public bool IsAvailableInBot { get; private set; }
		public bool IsAvailableInMobile { get; private set; }
		public bool IsAvailableInWeb { get; private set; }

		internal EbObjectType(string name, int code, string bmw, bool isUserFacing)
		{
			Name = name;	// 38 bytes max
			IntCode = code; //4 bytes
			BMW = bmw;		//6 bytes

			IsAvailableInBot = BMW.Contains(ObjectConstants.B_IN_BMW);
			IsAvailableInMobile = BMW.Contains(ObjectConstants.M_IN_BMW);
			IsAvailableInWeb = BMW.Contains(ObjectConstants.W_IN_BMW);
			IsUserFacing = isUserFacing;
		}

		// EbObjectType x = (EbObjectType)i;
		public static explicit operator EbObjectType(int i)
		{
			return EbObjectTypes.Get(i);
		}

		//int i = (int)o;
		public static explicit operator int(EbObjectType o)
		{
			return o.IntCode;
		}

		public static bool operator == (int i, EbObjectType b)
		{
			return (i == b.IntCode);
		}

		public static bool operator != (int i, EbObjectType b)
		{
			return (i != b.IntCode);
		}

		public override string ToString()
		{
			return this.Name;
		}
	}

	public struct EbObjectTypes
	{
		public const int iNull = -1;
		public const int iWebForm = 0;
		public const int iDisplayBlock = 1;
		public const int iDataSource = 2;
		public const int iReport = 3;
		public const int iTable = 4;
		public const int iSqlFunction = 5;
		public const int iSqlValidator = 6;
		public const int iJavascriptFunction = 7;
		public const int iJavascriptValidator = 8;
		public const int iDataVisualization = 11;
		public const int iFilterDialog = 12;
		public const int iMobileForm = 13;
		public const int iUserControl = 14;
		public const int iEmailBuilder = 15;
		public const int iTableVisualization = 16;
		public const int iChartVisualization = 17;
		public const int iBotForm = 18;

		public static readonly EbObjectType Null = new EbObjectType("Null", iNull, ObjectConstants.XXX, false);
		public static readonly EbObjectType WebForm = new EbObjectType(ObjectConstants.WEB_FORM, iWebForm, ObjectConstants.XXW, false);//true
		public static readonly EbObjectType DisplayBlock = new EbObjectType(ObjectConstants.DISPLAY_BLOCK, iDisplayBlock, ObjectConstants.XXX, false);
		public static readonly EbObjectType DataSource = new EbObjectType(ObjectConstants.DATA_SOURCE, iDataSource, ObjectConstants.BMW, false);
		public static readonly EbObjectType Report = new EbObjectType(ObjectConstants.REPORT, iReport, ObjectConstants.XMW, true);
		public static readonly EbObjectType Table = new EbObjectType(ObjectConstants.TABLE, iTable, ObjectConstants.BMW, false);
		public static readonly EbObjectType SqlFunction = new EbObjectType(ObjectConstants.SQL_FUNCTION, iSqlFunction, ObjectConstants.BMW, false);
		public static readonly EbObjectType SqlValidator = new EbObjectType(ObjectConstants.SQL_VALIDATOR, iSqlValidator, ObjectConstants.BMW, false);
		public static readonly EbObjectType JavascriptFunction = new EbObjectType(ObjectConstants.JAVASCRIPT_FUNCTION, iJavascriptFunction, ObjectConstants.BMW, false);
		public static readonly EbObjectType JavascriptValidator = new EbObjectType(ObjectConstants.JAVASCRIPT_VALIDATOR, iJavascriptValidator, ObjectConstants.BMW, false);
		public static readonly EbObjectType DataVisualization = new EbObjectType(ObjectConstants.DATA_VISUALIZATION, iDataVisualization, ObjectConstants.BMW, false);
		public static readonly EbObjectType FilterDialog = new EbObjectType(ObjectConstants.FILTER_DIALOG, iFilterDialog, ObjectConstants.BMW, false);
		public static readonly EbObjectType MobileForm = new EbObjectType(ObjectConstants.MOBILE_FORM, iMobileForm, ObjectConstants.BMW, false);
		public static readonly EbObjectType UserControl = new EbObjectType(ObjectConstants.USER_CONTROL, iUserControl, ObjectConstants.BMW, false);
		public static readonly EbObjectType EmailBuilder = new EbObjectType(ObjectConstants.EMAIL_BUILDER, iEmailBuilder, ObjectConstants.XMW, false);
		public static readonly EbObjectType TableVisualization = new EbObjectType(ObjectConstants.TABLE_VISUALIZATION, iTableVisualization, ObjectConstants.BMW, true);
		public static readonly EbObjectType ChartVisualization = new EbObjectType(ObjectConstants.CHART_VISUALIZATION, iChartVisualization, ObjectConstants.BMW, true);
		public static readonly EbObjectType BotForm = new EbObjectType(ObjectConstants.BOT_FORM, iBotForm, ObjectConstants.BXX, true);

		public static EbObjectType Get(int intcode)
		{
			foreach (EbObjectType o in Enumerator)
			{
				if (o.IntCode == intcode)
					return o;
			}

			return Null;
		}

		public static IEnumerable<EbObjectType> Enumerator
		{
			get
			{
				yield return WebForm;
				yield return DisplayBlock;
				yield return DataSource;
				yield return Report;
				yield return Table;
				yield return SqlFunction;
				yield return SqlValidator;
				yield return JavascriptFunction;
				yield return JavascriptValidator;
				yield return DataVisualization;
				yield return FilterDialog;
				yield return MobileForm;
				yield return UserControl;
				yield return EmailBuilder;
				yield return TableVisualization;
				yield return ChartVisualization;
				yield return BotForm;
			}
		}
	}
}

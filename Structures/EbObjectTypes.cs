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
        public readonly string BMWP;
        public readonly bool IsUserFacing;
        public readonly string Icon;
        public readonly string Alias;

        public bool IsAvailableInBot { get; private set; }
        public bool IsAvailableInMobile { get; private set; }
        public bool IsAvailableInWeb { get; private set; }
        public bool IsAvailableInPos { get; private set; }

        internal EbObjectType(string name, int code, string bmwp, bool isUserFacing, string icon, string alias)
        {
            Name = name;    // 38 bytes max
            IntCode = code; //4 bytes
            BMWP = bmwp;      //6 bytes
            Icon = icon;
            Alias = alias ?? name;

            IsAvailableInBot = BMWP.Contains(ObjectConstants.B_IN_BMWP);
            IsAvailableInMobile = BMWP.Contains(ObjectConstants.M_IN_BMWP);
            IsAvailableInWeb = BMWP.Contains(ObjectConstants.W_IN_BMWP);
            IsAvailableInPos = BMWP.Contains(ObjectConstants.P_IN_BMWP);
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

        public static bool operator ==(int i, EbObjectType b)
        {
            return (i == b.IntCode);
        }

        public static bool operator !=(int i, EbObjectType b)
        {
            return (i != b.IntCode);
        }

        public override string ToString()
        {
            return this.Name;
        }

        public bool IsAvailableIn(EbApplicationTypes applicationType)
        {
            if (applicationType == EbApplicationTypes.Bot)
                return IsAvailableInBot;
            else if (applicationType == EbApplicationTypes.Mobile)
                return IsAvailableInMobile;
            else if (applicationType == EbApplicationTypes.Web)
                return IsAvailableInWeb;
            else if (applicationType == EbApplicationTypes.Pos)
                return IsAvailableInPos;
            else
                return false;
        }
    }

    public struct EbObjectTypes
    {
        public const int iNull = -1;
        public const int iWebForm = 0;
        //public const int iDisplayBlock = 1;
        public const int iDataReader = 2;
        public const int iReport = 3;
        public const int iDataWriter = 4;
        //public const int iTable = 4;
        public const int iSqlFunction = 5;
        //public const int iSqlValidator = 6;
        public const int iJavascriptFunction = 7;
        //public const int iJavascriptValidator = 8;
        //public const int iDataVisualization = 11;
        public const int iFilterDialog = 12;
        public const int iMobilePage = 13;
        public const int iUserControl = 14;
        public const int iEmailBuilder = 15;
        public const int iTableVisualization = 16;
        public const int iChartVisualization = 17;
        public const int iBotForm = 18;
        public const int iSmsBuilder = 19;
        public const int iApi = 20;
        public const int iMapView = 21;
        public const int iDashBoard = 22;
        public const int iKanBan = 23;
        public const int iCalendarView = 24;
        public const int iCsharpFunction = 25;
        public const int iSqlJob = 26;
        public const int iHtmlPage = 27;
        //public const int iSurveyControl = 28;
        public const int iMaterializedView = 29;
        public const int iPosForm = 30;
        public const int iPrintLayout = 31;

        public static readonly EbObjectType Null = new EbObjectType("Null", iNull, ObjectConstants.XXXX, false, "fa-exclamation-triangle", null);
        public static readonly EbObjectType WebForm = new EbObjectType(ObjectConstants.WEB_FORM, iWebForm, ObjectConstants.XMWP, true, "fa-wpforms", "Form");//true
        //public static readonly EbObjectType DisplayBlock = new EbObjectType(ObjectConstants.DISPLAY_BLOCK, iDisplayBlock, ObjectConstants.XXXX, false);
        public static readonly EbObjectType DataReader = new EbObjectType(ObjectConstants.DATA_READER, iDataReader, ObjectConstants.BMWP, false, "fa-database", "Data Reader");
        public static readonly EbObjectType DataWriter = new EbObjectType(ObjectConstants.DATA_WRITER, iDataWriter, ObjectConstants.BMWP, false, "fa-database", "Data Writer");
        public static readonly EbObjectType Report = new EbObjectType(ObjectConstants.REPORT, iReport, ObjectConstants.XMWX, true, "fa-file-pdf-o", "PDF Report");
        //public static readonly EbObjectType Table = new EbObjectType(ObjectConstants.TABLE, iTable, ObjectConstants.BMWX, false);
        public static readonly EbObjectType SqlFunction = new EbObjectType(ObjectConstants.SQL_FUNCTION, iSqlFunction, ObjectConstants.BMWX, false, "fa-code", "Sql Function");
        //public static readonly EbObjectType SqlValidator = new EbObjectType(ObjectConstants.SQL_VALIDATOR, iSqlValidator, ObjectConstants.BMWX, false);
        public static readonly EbObjectType JavascriptFunction = new EbObjectType(ObjectConstants.JAVASCRIPT_FUNCTION, iJavascriptFunction, ObjectConstants.BXWX, false, "fa-file-code-o", "JavaScript Function");
        //public static readonly EbObjectType JavascriptValidator = new EbObjectType(ObjectConstants.JAVASCRIPT_VALIDATOR, iJavascriptValidator, ObjectConstants.BMWX, false);
        //public static readonly EbObjectType DataVisualization = new EbObjectType(ObjectConstants.DATA_VISUALIZATION, iDataVisualization, ObjectConstants.BMWX, false);
        public static readonly EbObjectType FilterDialog = new EbObjectType(ObjectConstants.FILTER_DIALOG, iFilterDialog, ObjectConstants.BXWX, false, "fa-filter", "Filter Dialog");
        public static readonly EbObjectType MobilePage = new EbObjectType(ObjectConstants.MOBILE_PAGE, iMobilePage, ObjectConstants.XMXX, true, "fa-mobile", "Mobile Page");
        public static readonly EbObjectType UserControl = new EbObjectType(ObjectConstants.USER_CONTROL, iUserControl, ObjectConstants.BXWX, false, "fa-puzzle-piece", "User Control");
        public static readonly EbObjectType EmailBuilder = new EbObjectType(ObjectConstants.EMAIL_BUILDER, iEmailBuilder, ObjectConstants.XMWX, false, "fa-envelope-o", "Email Builder");
        public static readonly EbObjectType TableVisualization = new EbObjectType(ObjectConstants.TABLE_VISUALIZATION, iTableVisualization, ObjectConstants.BMWX, true, "fa-table", "Table View");
        public static readonly EbObjectType ChartVisualization = new EbObjectType(ObjectConstants.CHART_VISUALIZATION, iChartVisualization, ObjectConstants.BMWX, true, "fa-bar-chart", "Chart View");
        public static readonly EbObjectType BotForm = new EbObjectType(ObjectConstants.BOT_FORM, iBotForm, ObjectConstants.BXXX, true, "fa-wpforms", "Bot Form");
        public static readonly EbObjectType SmsBuilder = new EbObjectType(ObjectConstants.SMS_BUILDER, iSmsBuilder, ObjectConstants.XXWX, false, "fa-commenting-o", "Sms Builder");
        public static readonly EbObjectType Api = new EbObjectType(ObjectConstants.API, iApi, ObjectConstants.BMWP, false, "fa-code", null);
        public static readonly EbObjectType MapView = new EbObjectType(ObjectConstants.MAP_VIEW, iMapView, ObjectConstants.BMWX, true, "fa-map-marker", "Map View");
        public static readonly EbObjectType DashBoard = new EbObjectType(ObjectConstants.DASHBOARD, iDashBoard, ObjectConstants.BMWX, true, "fa-tachometer", null);
        public static readonly EbObjectType SqlJob = new EbObjectType(ObjectConstants.SQLJOB, iSqlJob, ObjectConstants.XXWX, false, "fa-tachometer", "Sql Job");
        public static readonly EbObjectType HtmlPage = new EbObjectType(ObjectConstants.HTML_PAGE, iHtmlPage, ObjectConstants.XXWX, false, "fa-code", "Html Page");
        public static readonly EbObjectType MaterializedView = new EbObjectType(ObjectConstants.MATERIALIZED_VIEW, iMaterializedView, ObjectConstants.XXWX, false, "fa-database", "Materialized View");
        public static readonly EbObjectType PosForm = new EbObjectType(ObjectConstants.POS_FORM, iPosForm, ObjectConstants.XXXP, true, "fa-desktop", "Pos Form");
        public static readonly EbObjectType PrintLayout = new EbObjectType(ObjectConstants.PRINT_LAYOUT, iPrintLayout, ObjectConstants.XMWX, true, "fa-print", "Print Layout");

        public static readonly EbObjectType KanBan = new EbObjectType(ObjectConstants.KANBAN, iKanBan, ObjectConstants.XXWX, false, "fa-tag", null);
        public static readonly EbObjectType CalendarView = new EbObjectType(ObjectConstants.CALENDARVIEW, iCalendarView, ObjectConstants.BXWX, true, "fa-calendar", "Calendar View");
        public static readonly EbObjectType CsharpFunction = new EbObjectType(ObjectConstants.CSHARPFUNCTION, iCsharpFunction, ObjectConstants.XXWX, false, "fa-hashtag", "C# Function");

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
                return new[] {
                    WebForm,
                    //DisplayBlock,
                    DataReader,
                    Report,
                    DataWriter,
                    //Table,
                    SqlFunction,
                    //SqlValidator,
                    //JavascriptValidator,
                    //DataVisualization,
                    FilterDialog,
                    MobilePage,
                    UserControl,
                    EmailBuilder,
                    TableVisualization,
                    ChartVisualization,
                    SmsBuilder,
                    Api,
                    MapView,
                    BotForm,
                    KanBan,
                    CalendarView,
                    DashBoard,
                    JavascriptFunction,
                    CsharpFunction,
                    SqlJob,
                    HtmlPage,
                    MaterializedView,
                    PosForm,
                    PrintLayout
                };
            }
        }
    }
}

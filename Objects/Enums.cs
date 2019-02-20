﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ExpressBase.Common.Objects
{
    //[ProtoBuf.ProtoContract]
    //public enum EbObjectType
    //{
    //    WebForm = 0,
    //    DisplayBlock = 1,
    //    DataSource = 2,
    //    Report = 3,
    //    Table = 4,
    //    SqlFunction = 5,
    //    SqlValidator = 6,
    //    JavascriptFunction = 7,
    //    JavascriptValidator = 8,
    //    //Application = 9,
    //    //ApplicationModule = 10,
    //    DataVisualization = 11,
    //    FilterDialog = 12,
    //    MobileForm = 13,
    //    UserControl = 14,
    //    EmailBuilder = 15,
    //    TableVisualization = 16,
    //    ChartVisualization = 17,
    //    BotForm = 18
    //}

    //[ProtoBuf.ProtoContract]
    //public enum EbObjectTypesUI
    //{
    //    EbWebForm = 0,
    //    EbReport = 3,
    //    EbTableVisualization = 16,
    //    EbChartVisualization = 17,
    //    EbBotForm = 18
    //}

    public enum BuilderType
    {
        DisplayBlock = 1,
        DataReader = 2,
        DataWriter = 4,
        SqlFunctions = 5,
        FilterDialog = 12,
        WebForm = 0,
        MobileForm = 13,
        UserControl = 14,
        Report = 3,
        DVBuilder = 11,
        EmailBuilder = 15,
        BotForm = 18,
        SmsBuilder = 19,
        ApiBuilder = 20,
        All = 100
    }

    [ProtoBuf.ProtoContract]
    public enum EbDataGridViewColumnType
    {
        Boolean,
        DateTime,
        Image,
        Numeric,
        Text,
        Null,
        Chart
    }
    [ProtoBuf.ProtoContract]
    public enum ObjectLifeCycleStatus
    {
        Dev,
        Test,
        UAT,
        Live,
        Offline,
        Obsolete
    }

    public enum HorizontalAlignment
    {
        Left,
        Right,
        Center
    }

    public enum VerticalAlignment
    {
        Top,
        Bottom,
        Middle
    }
}

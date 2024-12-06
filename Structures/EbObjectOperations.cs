using System;
using System.Collections.Generic;
using System.Text;
using ExpressBase.Common.Constants;

namespace ExpressBase.Common.Structures
{
    public struct EbOperation
    {
        public readonly string Name;
        public readonly int IntCode;
        public readonly string BMWP;

        public bool IsAvailableInBot { get; private set; }
        public bool IsAvailableInMobile { get; private set; }
        public bool IsAvailableInWeb { get; private set; }
        public bool IsAvailableInPos { get; private set; }

        internal EbOperation(string name, int code, string bmwp)
        {
            this.Name = name;
            this.IntCode = code;
            this.BMWP = bmwp;

            this.IsAvailableInBot = BMWP.Contains(OperationConstants.B_IN_BMWP);
            this.IsAvailableInMobile = BMWP.Contains(OperationConstants.M_IN_BMWP);
            this.IsAvailableInWeb = BMWP.Contains(OperationConstants.W_IN_BMWP);
            this.IsAvailableInPos = BMWP.Contains(OperationConstants.P_IN_BMWP);
        }

        public static explicit operator int(EbOperation o)
        {
            return o.IntCode;
        }

        public static bool operator ==(int i, EbOperation b)
        {
            return (i == b.IntCode);
        }

        public static bool operator !=(int i, EbOperation b)
        {
            return (i != b.IntCode);
        }

        public override string ToString()
        {
            return this.Name;
        }
    }

    public class EbOperations
    {
        public readonly EbOperation Null;

        public virtual IEnumerable<EbOperation> Enumerator { get; }

        protected EbOperations()
        {
            Null = new EbOperation("Null", -1, OperationConstants.XXXX);
        }

        public EbOperation Get(int intcode)
        {
            foreach (EbOperation o in Enumerator)
            {
                if (o.IntCode == intcode)
                    return o;
            }

            return Null;
        }

        public EbOperation Get(string name)
        {
            foreach (EbOperation o in Enumerator)
            {
                if (o.Name == name)
                    return o;
            }

            return Null;
        }
    }

    public class TVOperations : EbOperations
    {
        public readonly EbOperation Customize, Summarize, Filter, Drilldown, PDFExport, ExcelExport, CSVExport, Print;

        private TVOperations()
        {
            Customize = new EbOperation(OperationConstants.CUSTOMIZE, 0, OperationConstants.BXWX);
            Summarize = new EbOperation(OperationConstants.SUMMARIZE, 1, OperationConstants.XXWX);
            Filter = new EbOperation(OperationConstants.FILTER, 2, OperationConstants.XXWX);
            Drilldown = new EbOperation(OperationConstants.DRILLDOWN, 3, OperationConstants.XXWX);
            PDFExport = new EbOperation(OperationConstants.PDF_EXPORT, 4, OperationConstants.XXWX);
            ExcelExport = new EbOperation(OperationConstants.EXCEL_EXPORT, 5, OperationConstants.XXWX);
            CSVExport = new EbOperation(OperationConstants.CSV_EXPORT, 6, OperationConstants.XXWX);
            Print = new EbOperation(OperationConstants.PRINT, 7, OperationConstants.BMWX);
        }

        public static EbOperations Instance
        {
            get
            {
                return new TVOperations();
            }
        }

        public override IEnumerable<EbOperation> Enumerator
        {
            get
            {
                yield return Customize;
                yield return Summarize;
                yield return Filter;
                yield return Drilldown;
                yield return PDFExport;
                yield return ExcelExport;
                yield return CSVExport;
                yield return Print;
            }
        }
    }

    public class CalendarOperations : EbOperations
    {
        public readonly EbOperation View;

        private CalendarOperations()
        {
            View = new EbOperation(OperationConstants.VIEW, 0, OperationConstants.XXWX);
        }

        public static EbOperations Instance
        {
            get
            {
                return new CalendarOperations();
            }
        }

        public override IEnumerable<EbOperation> Enumerator
        {
            get
            {
                yield return View;
            }
        }
    }

    public class CVOperations : EbOperations
    {
        public readonly EbOperation Customize, Print, DrillDown, Export;

        private CVOperations()
        {
            Customize = new EbOperation(OperationConstants.CUSTOMIZE, 0, OperationConstants.XXWX);
            Print = new EbOperation(OperationConstants.PRINT, 1, OperationConstants.XMWX);
            DrillDown = new EbOperation(OperationConstants.DRILLDOWN, 2, OperationConstants.XXWX);
            Export = new EbOperation(OperationConstants.EXPORT, 3, OperationConstants.XMWX);
        }

        public static EbOperations Instance
        {
            get
            {
                return new CVOperations();
            }
        }

        public override IEnumerable<EbOperation> Enumerator
        {
            get
            {
                yield return Customize;
                yield return Print;
                yield return DrillDown;
                yield return Export;
            }
        }
    }

    public class MapOperations : EbOperations
    {
        public readonly EbOperation Customize, DrillDown;

        private MapOperations()
        {
            Customize = new EbOperation(OperationConstants.CUSTOMIZE, 0, OperationConstants.XXWX);
            DrillDown = new EbOperation(OperationConstants.DRILLDOWN, 2, OperationConstants.XXWX);
        }

        public static EbOperations Instance
        {
            get
            {
                return new MapOperations();
            }
        }

        public override IEnumerable<EbOperation> Enumerator
        {
            get
            {
                yield return Customize;
                yield return DrillDown;
            }
        }
    }

    public class DashBoardOperations : EbOperations
    {
        public readonly EbOperation Customize;

        private DashBoardOperations()
        {
            Customize = new EbOperation(OperationConstants.CUSTOMIZE, 0, OperationConstants.XXWX);
        }

        public static EbOperations Instance
        {
            get
            {
                return new DashBoardOperations();
            }
        }

        public override IEnumerable<EbOperation> Enumerator
        {
            get
            {
                yield return Customize;
            }
        }
    }

    public class BFOperations : EbOperations
    {
        public readonly EbOperation Access;

        private BFOperations()
        {
            Access = new EbOperation(OperationConstants.ACCESS, 0, OperationConstants.BXXX);
        }

        public static EbOperations Instance
        {
            get
            {
                return new BFOperations();
            }
        }

        public override IEnumerable<EbOperation> Enumerator
        {
            get
            {
                yield return Access;
            }
        }
    }

    public class WFOperations : EbOperations
    {
        public readonly EbOperation New;
        public readonly EbOperation View;
        public readonly EbOperation Edit;
        public readonly EbOperation Delete;
        public readonly EbOperation Cancel;
        public readonly EbOperation AuditTrail;
        public readonly EbOperation Clone;
        public readonly EbOperation ExcelImport;
        public readonly EbOperation OwnData;
        public readonly EbOperation LockUnlock;
        public readonly EbOperation RevokeDelete;
        public readonly EbOperation RevokeCancel;
        public readonly EbOperation ChangeLocation;

        private WFOperations()
        {
            New = new EbOperation(OperationConstants.NEW, 0, OperationConstants.XXWX);
            View = new EbOperation(OperationConstants.VIEW, 1, OperationConstants.XXWX);
            Edit = new EbOperation(OperationConstants.EDIT, 2, OperationConstants.XXWX);
            Delete = new EbOperation(OperationConstants.DELETE, 3, OperationConstants.XXWX);
            Cancel = new EbOperation(OperationConstants.CANCEL, 4, OperationConstants.XXWX);
            AuditTrail = new EbOperation(OperationConstants.AUDIT_TRAIL, 5, OperationConstants.XXWX);
            Clone = new EbOperation(OperationConstants.CLONE, 6, OperationConstants.XXWX);
            ExcelImport = new EbOperation(OperationConstants.EXCEL_IMPORT, 7, OperationConstants.XXWX);
            OwnData = new EbOperation(OperationConstants.OWN_DATA, 8, OperationConstants.XXWX);
            LockUnlock = new EbOperation(OperationConstants.LOCK_UNLOCK, 9, OperationConstants.XXWX);
            RevokeDelete = new EbOperation(OperationConstants.REVOKE_DELETE, 10, OperationConstants.XXWX);
            RevokeCancel = new EbOperation(OperationConstants.REVOKE_CANCEL, 11, OperationConstants.XXWX);
            ChangeLocation = new EbOperation(OperationConstants.CHANGE_LOCATION, 12, OperationConstants.XXWX);
        }

        public static EbOperations Instance
        {
            get
            {
                return new WFOperations();
            }
        }

        public override IEnumerable<EbOperation> Enumerator
        {
            get
            {
                yield return New;
                yield return View;
                yield return Edit;
                yield return Delete;
                yield return Cancel;
                yield return AuditTrail;
                yield return Clone;
                yield return ExcelImport;
                yield return OwnData;
                yield return LockUnlock;
                yield return RevokeDelete;
                yield return RevokeCancel;
                yield return ChangeLocation;
            }
        }
    }

    public class PosFormOperations : EbOperations
    {
        public readonly EbOperation New;
        public readonly EbOperation View;
        public readonly EbOperation Edit;
        public readonly EbOperation Delete;
        public readonly EbOperation Cancel;

        private PosFormOperations()
        {
            New = new EbOperation(OperationConstants.NEW, 0, OperationConstants.XXXP);
            View = new EbOperation(OperationConstants.VIEW, 1, OperationConstants.XXXP);
            Edit = new EbOperation(OperationConstants.EDIT, 2, OperationConstants.XXXP);
            Delete = new EbOperation(OperationConstants.DELETE, 3, OperationConstants.XXXP);
            Cancel = new EbOperation(OperationConstants.CANCEL, 4, OperationConstants.XXXP);
        }

        public static EbOperations Instance
        {
            get
            {
                return new PosFormOperations();
            }
        }

        public override IEnumerable<EbOperation> Enumerator
        {
            get
            {
                yield return New;
                yield return View;
                yield return Edit;
                yield return Delete;
                yield return Cancel;
            }
        }
    }

    public class ReportOperations : EbOperations
    {
        public readonly EbOperation Print;

        private ReportOperations()
        {
            Print = new EbOperation(OperationConstants.PRINT, 0, OperationConstants.XMWX);
        }

        public static EbOperations Instance
        {
            get
            {
                return new ReportOperations();
            }
        }

        public override IEnumerable<EbOperation> Enumerator
        {
            get
            {
                yield return Print;
            }
        }
    }

    public class SqlJobOperations : EbOperations
    {
        public readonly EbOperation ViewLog;
        public readonly EbOperation Execute;
        public readonly EbOperation Retry;

        private SqlJobOperations()
        {
            ViewLog = new EbOperation(OperationConstants.VIEWLOG, 0, OperationConstants.XXWX);
            Execute = new EbOperation(OperationConstants.EXECUTE, 1, OperationConstants.XXWX);
            Retry = new EbOperation(OperationConstants.RETRY, 2, OperationConstants.XXWX);
        }

        public static EbOperations Instance
        {
            get
            {
                return new SqlJobOperations();
            }
        }
        public override IEnumerable<EbOperation> Enumerator
        {
            get
            {
                yield return ViewLog;
                yield return Execute;
                yield return Retry;
            }
        }
    }

    public class MobilePageOperations : EbOperations
    {
        public readonly EbOperation New;
        public readonly EbOperation View;
        public readonly EbOperation Edit;
        public readonly EbOperation Delete;
        public readonly EbOperation Cancel;

        private MobilePageOperations()
        {
            New = new EbOperation(OperationConstants.NEW, 0, OperationConstants.XMXX);
            View = new EbOperation(OperationConstants.VIEW, 1, OperationConstants.XMXX);
            Edit = new EbOperation(OperationConstants.EDIT, 2, OperationConstants.XMXX);
            Delete = new EbOperation(OperationConstants.DELETE, 3, OperationConstants.XMXX);
            Cancel = new EbOperation(OperationConstants.CANCEL, 4, OperationConstants.XMXX);
        }

        public static EbOperations Instance
        {
            get
            {
                return new MobilePageOperations();
            }
        }

        public override IEnumerable<EbOperation> Enumerator
        {
            get
            {
                yield return New;
                yield return View;
                yield return Edit;
                yield return Delete;
                yield return Cancel;
            }
        }
    }

    public class HtmlPageOperations : EbOperations
    {
        public readonly EbOperation View;

        private HtmlPageOperations()
        {
            View = new EbOperation(OperationConstants.VIEW, 0, OperationConstants.XXWX);
        }

        public static EbOperations Instance
        {
            get
            {
                return new HtmlPageOperations();
            }
        }

        public override IEnumerable<EbOperation> Enumerator
        {
            get
            {
                yield return View;
            }
        }
    }
}

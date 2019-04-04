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
		public readonly string BMW;

		public bool IsAvailableInBot { get; private set; }
		public bool IsAvailableInMobile { get; private set; }
		public bool IsAvailableInWeb { get; private set; }

		internal EbOperation(string name, int code, string bmw)
		{
			this.Name = name;
			this.IntCode = code;
			this.BMW = bmw;

			this.IsAvailableInBot = BMW.Contains(OperationConstants.B_IN_BMW);
			this.IsAvailableInMobile = BMW.Contains(OperationConstants.M_IN_BMW);
			this.IsAvailableInWeb = BMW.Contains(OperationConstants.W_IN_BMW);
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
			Null = new EbOperation("Null", -1, OperationConstants.XXX);
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
	}

	public class TVOperations : EbOperations
	{
		public readonly EbOperation Customize, Summarize, Filter, Drilldown, PDFExport, ExcelExport, CSVExport, Print;

		private TVOperations()
		{
			Customize = new EbOperation(OperationConstants.CUSTOMIZE, 0, OperationConstants.XXX);
			Summarize = new EbOperation(OperationConstants.SUMMARIZE, 1, OperationConstants.XXX);
			Filter = new EbOperation(OperationConstants.FILTER, 2, OperationConstants.XXX);
			Drilldown = new EbOperation(OperationConstants.DRILLDOWN, 3, OperationConstants.XXX);
			PDFExport = new EbOperation(OperationConstants.PDF_EXPORT, 4, OperationConstants.XXX);
			ExcelExport = new EbOperation(OperationConstants.EXCEL_EXPORT, 5, OperationConstants.XXX);
			CSVExport = new EbOperation(OperationConstants.CSV_EXPORT, 6, OperationConstants.XXX);
			Print = new EbOperation(OperationConstants.PRINT, 7, OperationConstants.BMW);
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


	public class CVOperations : EbOperations
	{
		public readonly EbOperation Customize, Print, DrillDown, Export;

		private CVOperations()
		{
			Customize = new EbOperation(OperationConstants.CUSTOMIZE, 0, OperationConstants.XXW);
			Print = new EbOperation(OperationConstants.PRINT, 1, OperationConstants.XMW);
			DrillDown = new EbOperation(OperationConstants.DRILLDOWN, 2, OperationConstants.XXW);
			Export = new EbOperation(OperationConstants.EXPORT, 3, OperationConstants.XMW);
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

    public class BFOperations : EbOperations
    {
        public readonly EbOperation Access;

        private BFOperations()
        {
            Access = new EbOperation(OperationConstants.ACCESS, 0, OperationConstants.BXX);
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
        public readonly EbOperation Print;

        private WFOperations()
        {
            New = new EbOperation(OperationConstants.NEW, 0, OperationConstants.XXW);
            View = new EbOperation(OperationConstants.VIEW, 1, OperationConstants.XXW);
            Edit = new EbOperation(OperationConstants.EDIT, 2, OperationConstants.XXW);
            Delete = new EbOperation(OperationConstants.DELETE, 3, OperationConstants.XXW);
            Cancel = new EbOperation(OperationConstants.CANCEL, 4, OperationConstants.XXW);
            Print = new EbOperation(OperationConstants.PRINT, 5, OperationConstants.XXW);
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
                yield return Print;
            }
        }
    }

    public class ReportOperations : EbOperations
	{
		public readonly EbOperation Print;

		private ReportOperations()
		{
			Print = new EbOperation(OperationConstants.PRINT, 0, OperationConstants.XMW);
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

}

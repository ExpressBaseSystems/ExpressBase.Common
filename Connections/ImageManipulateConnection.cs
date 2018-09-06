using ExpressBase.Common.Connections;

namespace ExpressBase.Common.Data
{
    public class ImageManipulateConnection : IEbConnection
    {
        public string Cloud { get; set; }

        public string ApiKey { get; set; }

        public string ApiSecret { get; set; }

        public Integrations Integrations { get; set; }

        public override EbConnectionTypes EbConnectionType { get { return EbConnectionTypes.EbImageManipulation; } }
    }
}
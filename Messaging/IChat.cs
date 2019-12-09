using System;
using System.Collections.Generic;
using System.Text;
using ExpressBase.Common.Connections;
using ExpressBase.Common.Data.MongoDB;

namespace ExpressBase.Common.Messaging
{
    public interface IChatConnection
    {
        int InfraConId { get; set; }
        void Send(string channel, string Message, byte[] bytea, string AttachmentName);
        Dictionary<int, string> GetAllUsers();

        Dictionary<int, string> GetAllGroups();
    }   
}

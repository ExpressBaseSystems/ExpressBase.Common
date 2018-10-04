﻿using ExpressBase.Common.Connections;
using System;
using System.Collections.Generic;
using System.Text;
using Twilio;
using Twilio.Rest.Api.V2010.Account;
using Twilio.Types;

namespace ExpressBase.Common.Messaging.Twilio
{
    public class TwilioSms : ISMSConnection
    {
        private string _accountSid { get; set; }
        private string _authToken { get; set; }
        private PhoneNumber _from { get; set; }


        private List<Uri> _mediaUrl;

        private MessageResource _messageResource { get; set; }

        public TwilioSms(SMSConnection SMSConnection)
        {
            _accountSid = SMSConnection.UserName;
            _authToken = SMSConnection.Password;
            _from = new PhoneNumber(SMSConnection.From);
        }

        public Dictionary<string, string> SendSMS(string sTo, string body)
        {
            Dictionary<string, string> msgStatus = null;
            try
            {
                TwilioClient.Init(_accountSid, _authToken);
                PhoneNumber to = new PhoneNumber(sTo);
                MessageResource msg = MessageResource.Create(to, from: _from, body: body, statusCallback: new Uri("https://eb-test.info")
                                             );
                msgStatus = new Dictionary<string, string>
                {
                    { "To", msg.To.ToString() },
                    { "From", msg.From.ToString() },
                    { "Uri", msg.Uri },
                    { "Body", msg.Body },
                    { "Status", msg.Status.ToString() },
                    { "SentTime", msg.DateSent.ToString() },
                    { "ErrorMessage", msg.ErrorMessage }
                };
            }
            catch (Exception e)
            {
                Console.WriteLine("Exception:" + e.ToString());
                msgStatus.Add("ErrorMessage", e.ToString());
            }
            Console.WriteLine(" --- SMS msg" + EbSerializers.Json_Serialize(msgStatus));
            return msgStatus;
        }
    }
}

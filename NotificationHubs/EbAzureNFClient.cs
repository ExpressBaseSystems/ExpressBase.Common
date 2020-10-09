using ExpressBase.Common.Data;
using Microsoft.Azure.NotificationHubs;
using Microsoft.Azure.NotificationHubs.Messaging;
using ServiceStack.Redis;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace ExpressBase.Common.NotificationHubs
{
    public class EbAzureNFClient
    {
        private readonly NotificationHubClient client;

        private EbAzureNFClient(string conString, string hubName)
        {
            client = NotificationHubClient.CreateClientFromConnectionString(conString, hubName);
        }

        #region Client Creation

        public static EbAzureNFClient Create(MobileAppConnection con)
        {
            if (con == null || con.IsNFConnectionsEmpty())
                throw new Exception("Azure NotificationHub connections are empty");

            Console.WriteLine("Azure connection string :" + con.AzureNFConnection);
            Console.WriteLine("Azure HubName :" + con.AzureNFHubName);

            return new EbAzureNFClient(con.AzureNFConnection, con.AzureNFHubName);
        }

        public static EbAzureNFClient Create(string conString, string hubName)
        {
            if (string.IsNullOrEmpty(conString) || string.IsNullOrEmpty(hubName))
                throw new Exception("Azure NotificationHub connections are empty");

            return new EbAzureNFClient(conString, hubName);
        }

        public static EbAzureNFClient Create(string iSolutionId, IRedisClient redis)
        {
            EbConnectionFactory factory = new EbConnectionFactory(iSolutionId, redis);

            if (factory == null)
                throw new Exception("No connection object for sid " + iSolutionId);

            MobileAppConnection con = factory?.MobileAppConnection;

            if (con == null || con.IsNFConnectionsEmpty())
                throw new Exception("Azure NotificationHub connections are empty");

            Console.WriteLine("Azure connection string :" + con.AzureNFConnection);
            Console.WriteLine("Azure HubName :" + con.AzureNFHubName);

            return new EbAzureNFClient(con.AzureNFConnection, con.AzureNFHubName);
        }

        #endregion

        #region TagHelper Methods

        public string ConvertToAuthTag(string authid)
        {
            return string.Format("authid:{0}", authid);
        }

        public string ConvertToSolutionTag(string solutionid)
        {
            return string.Format("solution:{0}", solutionid);
        }

        public string GlobalTag(EbAppVendors vendor)
        {
            return string.Format("global:eb_pns_tag_{0}", vendor);
        }

        #endregion

        #region Public API's

        public async Task<string> CreateRegistrationId()
        {
            return await client.CreateRegistrationIdAsync();
        }

        public async Task DeleteRegistration(string registrationId)
        {
            await client.DeleteRegistrationAsync(registrationId);
        }

        public async Task<EbNFRegisterResponse> Register(string id, DeviceRegistration device)
        {
            EbNFRegisterResponse nFResponse = new EbNFRegisterResponse();

            try
            {
                RegistrationDescription registrationDescription;

                switch (device.Platform)
                {
                    case PNSPlatforms.WNS:
                        registrationDescription = new WindowsRegistrationDescription(device.Handle);
                        break;
                    case PNSPlatforms.APNS:
                        registrationDescription = new AppleRegistrationDescription(device.Handle);
                        break;
                    case PNSPlatforms.GCM:
                        registrationDescription = new FcmRegistrationDescription(device.Handle);
                        break;
                    default:
                        nFResponse.Message = "Please provide correct platform notification service name.";
                        return nFResponse;
                }

                registrationDescription.RegistrationId = id;
                registrationDescription.Tags = new HashSet<string>(device.Tags);

                await client.CreateOrUpdateRegistrationAsync(registrationDescription);
                nFResponse.Status = true;
                nFResponse.Message = "Success";
            }
            catch (MessagingException)
            {
                nFResponse.Status = false;
                nFResponse.Message = "Registration failed because of HttpStatusCode.Gone. PLease register once again.";
            }

            return nFResponse;
        }

        public async Task<EbNFResponse> Send(EbNFRequest request)
        {
            EbNFResponse resp = new EbNFResponse();
            try
            {
                NotificationOutcome outcome = null;

                switch (request.Platform)
                {
                    case PNSPlatforms.WNS:
                        if (request.Tags == null)
                            outcome = await client.SendWindowsNativeNotificationAsync(request.PayLoad);
                        else
                            outcome = await client.SendWindowsNativeNotificationAsync(request.PayLoad, request.Tags);
                        break;
                    case PNSPlatforms.APNS:
                        if (request.Tags == null)
                            outcome = await client.SendAppleNativeNotificationAsync(request.PayLoad);
                        else
                            outcome = await client.SendAppleNativeNotificationAsync(request.PayLoad, request.Tags);
                        break;
                    case PNSPlatforms.GCM:
                        if (request.Tags == null)
                            outcome = await client.SendFcmNativeNotificationAsync(request.PayLoad);
                        else
                            outcome = await client.SendFcmNativeNotificationAsync(request.PayLoad, request.Tags);
                        break;
                }

                if (outcome != null)
                {
                    if (outcome.State == NotificationOutcomeState.Abandoned || outcome.State == NotificationOutcomeState.Unknown)
                    {
                        resp.Status = false;
                        resp.Message = "Failed to send notification. Try again";
                    }
                    else
                    {
                        resp.Status = true;
                        resp.Message = "Success";
                    }
                }
                else
                    Console.WriteLine("Error at SendNotification mobile: outcome is null");
            }
            catch (MessagingException ex)
            {
                Console.WriteLine("Error at SendNotification mobile");
                Console.WriteLine(ex.Message);
            }
            catch (ArgumentException ex)
            {
                Console.WriteLine("Error at SendNotification mobile");
                Console.WriteLine(ex.Message);
            }
            catch (Exception ex)
            {
                Console.WriteLine("Error at SendNotification mobile");
                Console.WriteLine(ex.Message);
            }
            return resp;
        }

        #endregion
    }
}

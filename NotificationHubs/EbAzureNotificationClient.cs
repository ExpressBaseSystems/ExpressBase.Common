using Microsoft.Azure.NotificationHubs;
using Microsoft.Azure.NotificationHubs.Messaging;
using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;

namespace ExpressBase.Common.NotificationHubs
{
    public class EbAzureNotificationClient
    {
        public EbAzureNotificationClient() { }

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

        private NotificationHubClient GetClient(EbAppVendors vendor)
        {
            string connectionString = string.Empty, hubName = string.Empty;

            if (vendor == EbAppVendors.ExpressBase)
            {
                connectionString = Environment.GetEnvironmentVariable(EnvironmentConstants.EB_AZURE_PNS_CON);
                hubName = Environment.GetEnvironmentVariable(EnvironmentConstants.EB_AZURE_PNS_HUBNAME);
            }
            else if (vendor == EbAppVendors.MoveOn)
            {
                connectionString = Environment.GetEnvironmentVariable(EnvironmentConstants.MOVEON_AZURE_PNS_CON);
                hubName = Environment.GetEnvironmentVariable(EnvironmentConstants.MOVEON_AZURE_PNS_HUBNAME);
            }

            Console.WriteLine("----------- Noftification clent ------------");
            Console.WriteLine(vendor);
            Console.WriteLine(connectionString);
            Console.WriteLine(hubName);

            return NotificationHubClient.CreateClientFromConnectionString(connectionString, hubName);
        }

        public async Task<string> CreateRegistrationId(EbAppVendors vendor)
        {
            var client = GetClient(vendor);

            return await client.CreateRegistrationIdAsync();
        }

        public async Task DeleteRegistration(string registrationId, EbAppVendors vendor)
        {
            var client = GetClient(vendor);

            await client.DeleteRegistrationAsync(registrationId);
        }

        public async Task<EbNFRegisterResponse> Register(string id, DeviceRegistration device)
        {
            EbNFRegisterResponse nFResponse = new EbNFRegisterResponse();

            var client = GetClient(device.Vendor);

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
                var client = GetClient(request.Vendor);

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
            return resp;
        }
    }
}

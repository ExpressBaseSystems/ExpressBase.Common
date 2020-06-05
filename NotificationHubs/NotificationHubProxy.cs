using Microsoft.Azure.NotificationHubs;
using Microsoft.Azure.NotificationHubs.Messaging;
using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;

namespace ExpressBase.Common.NotificationHubs
{
    public class NotificationHubProxy
    {
        private readonly NotificationHubClient hubClient;

        private readonly string hubName;

        private readonly string connectionString;

        public NotificationHubProxy()
        {
            connectionString = Environment.GetEnvironmentVariable(EnvironmentConstants.EB_AZURE_PNS_CON);
            hubName = Environment.GetEnvironmentVariable(EnvironmentConstants.EB_AZURE_PNS_HUBNAME);

            if (hubName != null && connectionString != null)
            {
                hubClient = NotificationHubClient.CreateClientFromConnectionString(connectionString, hubName);
            }
        }

        ///<summary>
        /// Get registration ID from Azure Notification Hub
        /// </summary>

        public async Task<string> CreateRegistrationId()
        {
            return await hubClient.CreateRegistrationIdAsync();
        }

        ///<summary>
        /// Delete registration ID from Azure Notification Hub
        /// </summary>

        public async Task DeleteRegistration(string registrationId)
        {
            await hubClient.DeleteRegistrationAsync(registrationId);
        }

        ///<summary>
        /// Register device to receive push notifications. 
        /// Registration ID ontained from Azure Notification Hub has to be provided
        /// Then basing on platform (Android, iOS or Windows) specific
        /// handle (token) obtained from Push Notification Service has to be provided
        /// </summary>

        public async Task<HubResponse> RegisterForPushNotifications(string id, DeviceRegistration deviceUpdate)
        {
            RegistrationDescription registration;

            switch (deviceUpdate.Platform)
            {
                case MobilePlatform.wns:
                    registration = new WindowsRegistrationDescription(deviceUpdate.Handle);
                    break;
                case MobilePlatform.apns:
                    registration = new AppleRegistrationDescription(deviceUpdate.Handle);
                    break;
                case MobilePlatform.gcm:
                    registration = new FcmRegistrationDescription(deviceUpdate.Handle);
                    break;
                default:
                    return new HubResponse().AddErrorMessage("Please provide correct platform notification service name.");
            }

            registration.RegistrationId = id;
            registration.Tags = new HashSet<string>(deviceUpdate.Tags);

            try
            {
                await hubClient.CreateOrUpdateRegistrationAsync(registration);
                return new HubResponse();
            }
            catch (MessagingException)
            {
                return new HubResponse().AddErrorMessage("Registration failed because of HttpStatusCode.Gone. PLease register once again.");
            }
        }

        ///<summary>
        /// Send push notification to specific platform (Android, iOS or Windows)
        /// </summary>

        public async Task<HubResponse<NotificationOutcome>> SendNotification(Notification newNotification)
        {
            try
            {
                NotificationOutcome outcome = null;

                switch (newNotification.Platform)
                {
                    case MobilePlatform.wns:
                        if (newNotification.Tags == null)
                            outcome = await hubClient.SendWindowsNativeNotificationAsync(newNotification.Content);
                        else
                            outcome = await hubClient.SendWindowsNativeNotificationAsync(newNotification.Content, newNotification.Tags);
                        break;
                    case MobilePlatform.apns:
                        if (newNotification.Tags == null)
                            outcome = await hubClient.SendAppleNativeNotificationAsync(newNotification.Content);
                        else
                            outcome = await hubClient.SendAppleNativeNotificationAsync(newNotification.Content, newNotification.Tags);
                        break;
                    case MobilePlatform.gcm:
                        if (newNotification.Tags == null)
                            outcome = await hubClient.SendFcmNativeNotificationAsync(newNotification.Content);
                        else
                            outcome = await hubClient.SendFcmNativeNotificationAsync(newNotification.Content, newNotification.Tags);
                        break;
                }

                if (outcome != null)
                {
                    if (!((outcome.State == NotificationOutcomeState.Abandoned) ||
                        (outcome.State == NotificationOutcomeState.Unknown)))
                        return new HubResponse<NotificationOutcome>();
                }

                return new HubResponse<NotificationOutcome>().SetAsFailureResponse().AddErrorMessage("Notification was not sent due to issue. Please send again.");
            }

            catch (MessagingException ex)
            {
                return new HubResponse<NotificationOutcome>().SetAsFailureResponse().AddErrorMessage(ex.Message);
            }

            catch (ArgumentException ex)
            {
                return new HubResponse<NotificationOutcome>().SetAsFailureResponse().AddErrorMessage(ex.Message);
            }
        }
    }
}

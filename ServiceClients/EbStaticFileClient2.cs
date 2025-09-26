using ExpressBase.Common;
using ExpressBase.Common.EbServiceStack.ReqNRes;
using ExpressBase.Common.Objects;
using ExpressBase.Common.WebApi.RequestNResponse;
using Microsoft.AspNetCore.Http;
using Newtonsoft.Json;
using SendGrid;
using ServiceStack;
using ServiceStack.Auth;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Threading.Tasks;

namespace ExpressBase.Common.ServiceClients
{
    public class EbStaticFileClient2
    {
        private readonly HttpClient Client;

        public EbStaticFileClient2(HttpClient client)
        {
            Client = client;
            Client.BaseAddress = new Uri("http://localhost:42800");

            //_httpClient.BaseAddress = new Uri(Environment.GetEnvironmentVariable(EnvironmentConstants.EB_STATICFILESERVER2_INT_URL));
        }

        public async Task<UploadAsyncResponse2> UploadFileAsync(byte[] fileBytes, FileMeta meta, string endpoint, string solutionId, int userId, string userAuthId, int targetUserId = 0)
        {
            using (var form = new MultipartFormDataContent())
            {
                var content = new ByteArrayContent(fileBytes);
                content.Headers.ContentType = MediaTypeHeaderValue.Parse("application/octet-stream");
                form.Add(content, "File", meta.FileName);

                form.Add(new StringContent(meta.Context ?? ""), "Context");
                form.Add(new StringContent(meta.FileType ?? ""), "FileType");
                form.Add(new StringContent(meta.FileName ?? ""), "FileName");
                form.Add(new StringContent(meta.Length.ToString() ?? ""), "Length");
                form.Add(new StringContent(((int)meta.FileCategory).ToString() ?? ""), "FileCategory");
                if (meta is ImageMeta)
                    form.Add(new StringContent(((int)(meta as ImageMeta).ImageQuality).ToString() ?? ""), "ImageQuality");

                string metaJson = "{}";
                if (meta.MetaDataDictionary != null && meta.MetaDataDictionary.Count > 0)
                {
                    metaJson = JsonConvert.SerializeObject(meta.MetaDataDictionary);
                }
                form.Add(new StringContent(metaJson), "MetaData");

                form.Add(new StringContent(solutionId), "SolnId");
                form.Add(new StringContent(userId.ToString()), "UserId");
                form.Add(new StringContent(userAuthId), "UserAuthId");
                form.Add(new StringContent(targetUserId.ToString() ?? ""), "TargetUserId");



                // Send the request
                HttpResponseMessage response = await Client.PostAsync(endpoint.TrimStart('/'), form);
                response.EnsureSuccessStatusCode();

                string responseContent = await response.Content.ReadAsStringAsync();

                // Use Newtonsoft.Json to deserialize
                return JsonConvert.DeserializeObject<UploadAsyncResponse2>(responseContent);
            }
        }


        public DownloadFileResponse2 DownloadFile(FileMeta meta, string endpoint, string solutionId, int userId = 0, string userAuthId = "_", ImageQuality? imageQuality = null, bool needStreamResult = false)
        {

            var query = new Dictionary<string, string>
            {
                ["FileRefId"] = meta?.FileRefId.ToString(),
                ["FileCategory"] = ((int)meta?.FileCategory).ToString(),
                ["SolnId"] = solutionId,
                ["UserId"] = userId.ToString(),
                ["UserAuthId"] = userAuthId,
                ["FileName"] = meta?.FileName ?? " ",
            };

            // Only add ImageQuality if provided
            if (imageQuality.HasValue)
            {
                query["imageQuality"] = ((int)imageQuality).ToString();
            }
            query["needStreamResult"] = needStreamResult.ToString().ToLowerInvariant();

            string queryString = string.Join("&",
                query.Select(kvp => $"{Uri.EscapeDataString(kvp.Key)}={Uri.EscapeDataString(kvp.Value)}"));

            // Ensure proper URL formatting
            string url = $"{endpoint.TrimStart('/')}?{queryString}";

            HttpResponseMessage response = Client.GetAsync(url).GetAwaiter().GetResult();
            response.EnsureSuccessStatusCode();

            string json = response.Content.ReadAsStringAsync().GetAwaiter().GetResult();
            DownloadFileResponse2 dfs = JsonConvert.DeserializeObject<DownloadFileResponse2>(json);
            return dfs;
        }

        public DownloadFileResponse2 DownloadLogo(string solutionId, bool needStreamResult = false)
        {
            string endpoint = "download/logo";
            var query = new Dictionary<string, string>
            {
                ["SolnId"] = solutionId,
                ["needStreamResult"] = needStreamResult.ToString().ToLowerInvariant()
            };
            string queryString = string.Join("&",
                query.Select(kvp => $"{Uri.EscapeDataString(kvp.Key)}={Uri.EscapeDataString(kvp.Value)}"));

            // Ensure proper URL formatting
            string url = $"{endpoint}?{queryString}";

            HttpResponseMessage response = Client.GetAsync(url).GetAwaiter().GetResult();
            response.EnsureSuccessStatusCode();

            string json = response.Content.ReadAsStringAsync().GetAwaiter().GetResult();
            DownloadFileResponse2 dfs = JsonConvert.DeserializeObject<DownloadFileResponse2>(json);
            return dfs;
        }

    }
}

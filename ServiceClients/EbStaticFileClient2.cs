using ExpressBase.Common;
using ExpressBase.Common.EbServiceStack.ReqNRes;
using ExpressBase.Common.Objects;
using ExpressBase.Common.WebApi.RequestNResponse;
using Microsoft.AspNetCore.Http;
using Newtonsoft.Json;
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

        public async Task<UploadAsyncResponse2> UploadImageAsync(byte[] imageBytes, ImageMeta meta, string endpoint, string solutionId, int userId, string userAuthId, int targetUserId = 0)
        {
            using (var form = new MultipartFormDataContent())
            {
                // Add the image content
                var imageContent = new ByteArrayContent(imageBytes);
                imageContent.Headers.ContentType = MediaTypeHeaderValue.Parse("application/octet-stream");
                form.Add(imageContent, "File", meta.FileName);

                //Add metadata fields
                form.Add(new StringContent(meta.Context ?? ""), "Context");
                form.Add(new StringContent(meta.FileType ?? ""), "FileType");
                form.Add(new StringContent(meta.FileName ?? ""), "FileName");
                form.Add(new StringContent(meta.Length.ToString() ?? ""), "Length");
                form.Add(new StringContent(((int)meta.FileCategory).ToString() ?? ""), "FileCategory");
                form.Add(new StringContent(((int)meta.ImageQuality).ToString() ?? ""), "ImageQuality");

                // Serialize MetaDataDictionary as JSON
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


        public DownloadFileResponse2 DownloadFile(FileMeta meta, string endpoint, string solutionId, int userId, string userAuthId, ImageQuality? imageQuality = null)
        {
            
            var query = new Dictionary<string, string>
            {
                ["FileRefId"] = meta.FileRefId.ToString(),
                ["FileCategory"] = ((int)meta.FileCategory).ToString(),
                ["SolnId"] = solutionId,
                ["UserId"] = userId.ToString(),
                ["UserAuthId"] = userAuthId,
                ["FileName"] = meta.FileName
            };

            // Only add ImageQuality if provided
            if (imageQuality.HasValue)
            {
                query["ImgQuality"] = ((int)imageQuality.Value).ToString();
            }

            string queryString = string.Join("&",
                query.Select(kvp => $"{Uri.EscapeDataString(kvp.Key)}={Uri.EscapeDataString(kvp.Value)}"));

            // Ensure proper URL formatting
            string url = $"{endpoint.TrimStart('/')}?{queryString}";

            HttpResponseMessage response = Client.GetAsync(url).GetAwaiter().GetResult();
            response.EnsureSuccessStatusCode();

            // Read binary stream
            var memStream = new MemoryStream();
            using (var respStream = response.Content.ReadAsStreamAsync().GetAwaiter().GetResult())
            {
                respStream.CopyTo(memStream);
            }

            memStream.Position = 0;

            return new DownloadFileResponse2
            {
                StreamWrapper = new MemorystreamWrapper { Memorystream = memStream }
            };
        }


        public async Task<string> UploadAsync(IFormFile formFile, IFormCollection formFields, string endpoint)
        {
            var form = new MultipartFormDataContent();
            var fileName = Path.GetFileName(formFile.FileName);

            using (var stream = formFile.OpenReadStream())
            {
                form.Add(new StreamContent(stream), "file", fileName);
            }


            // Add *all other fields* from the form (including metadata)
            foreach (var key in formFields.Keys)
            {
                if (key == "file") continue; // already added above
                form.Add(new StringContent(formFields[key]), key);
            }

            var response = await Client.PostAsync(endpoint.TrimStart('/'), form);
            response.EnsureSuccessStatusCode();

            return await response.Content.ReadAsStringAsync();
        }

    }
}

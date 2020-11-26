using System.Collections.Generic;

namespace ExpressBase.Common.Constants
{
    public static class StaticFileConstants
    {
        // File Name Parts
        public const string LOGO = "logo";
        public const string DP = "dp";
        public const string LOC = "loc";
        public const string LOCATION_DP = "location_dp";
        public const string ORG = "org";
        public const string SMALL = "small";
        public const string MEDIUM = "medium";
        public const string LARGE = "large";

        //Bucket Names
        public const string EXTERNAL = "external";
        public const string SOL_LOGOS = "sol_logos";
        public const string DP_IMAGES = "dp_images";
        public const string LOCATION_IMAGES = "location_images";
        public const string IMAGES_ORIGINAL = "images_original";
        public const string FILES = "files";
        public const string IMAGES = "images";
        public const string IMAGES_SMALL = "images_small";
        public const string IMAGES_MEDIUM = "images_medium";
        public const string IMAGES_LARGE = "images_large";

        //Notification Message Constants
        public const string UPLOADSUCCESS = "cmd.onUploadSuccess";
        public const string UPLOADFAILURE = "cmd.onUploadFailure";
        public const string EXPORTTOEXCELSUCCESS = "cmd.onExportToExcel";
        //Controller Types Url catg strings


        //FileTypes
        public const string JPG = "jpg";
        public const string JPEG = "jpeg";
        public const string PNG = "png";
        public const string BMP = "bmp";

        public const string MP4 = "mp4";

        public const string M4A = "m4a";
        public const string FLAC = "flac";
        public const string MP3 = "mp3";
        public const string WAVE = "wave";
        public const string WMA = "wma";
        public const string AAC = "aac";
        public const string OPUS = "opus";

        public const string TXT = "txt";
        public const string TEXT = "text";

        public const string PDF = "pdf";
        public const string DOC = "doc";
        public const string DOCX = "docx";
        public const string XLS = "xls";
        public const string XLSX = "xlsx";
        public const string PPTX = "pptx";
        public const string PPT = "ppt";

        public const string ZIP = "zip";

        public const string DOTJPG = ".jpg";
        public const string DOTJPEG = ".jepg";
        public const string DOTPNG = ".png";
        public const string DOTBMP = ".bmp";

        public const string DOTMP4 = ".mp4";

        public const string DOTTXT = ".txt";
        public const string DOTTEXT = ".text";

        public const string DOTPDF = ".pdf";
        public const string DOTDOC = ".doc";
        public const string DOTDOCX = ".docx";
        public const string DOTXLS = ".xls";
        public const string DOTXLSX = ".xxlsx";
        public const string DOTPPT = ".ppt";
        public const string DOTPPTX = ".pptx";

        public const string DOTZIP = ".zip";

        // Mime Types
        public const string MIME_JPG = "image/jpeg";
        public const string MIME_JPEG = "image/jpeg";
        public const string MIME_PNG = "image/png";
        public const string MIME_BMP = "image/bmp";

        public const string MIME_MP4 = "video/mp4";

        public const string MIME_MP3 = "audio/mp3";
        public const string MIME_WAVE = "audio/wave";
        public const string MIME_AAC = "audio/aac";
        public const string MIME_M4A = "audio/m4a";
        public const string MIME_WMA = "audio/wma";
        public const string MIME_OPUS = "audio/opus";
        public const string MIME_FLAC = "audio/flac";

        public const string MIME_TXT = "text/plain";
        public const string MIME_TEXT = "text/plain";

        public const string MIME_PDF = "application/pdf";
        public const string MIME_DOC = "application/msword";
        public const string MIME_DOCX = "application/msword";
        public const string MIME_XLS = "application/excel";
        public const string MIME_XLSX = "application/excel";
        public const string MIME_PPT = "application/powerpoint";
        public const string MIME_PPTX = "application/powerpoint";

        public const string MIME_ZIP = "application/zip";

        public const string MIME_UNKNOWN = "application/octet-stream";

        public static Dictionary<string, string> GetMime = new Dictionary<string, string>
        {
            {JPEG, MIME_JPEG},
            {JPG, MIME_JPG},
            {PNG, MIME_PNG},
            { BMP, MIME_BMP},

            { MP4, MIME_MP4},

            { M4A, MIME_M4A},
            { FLAC, MIME_FLAC },
            { MP3, MIME_MP3},
            { WAVE, MIME_WAVE},
            { WMA, MIME_WMA},
            { AAC, MIME_AAC},
            { OPUS, MIME_OPUS},

            {TXT, MIME_TXT},
            {TEXT, MIME_TEXT},

            { PDF, MIME_PDF},
            {DOC, MIME_DOC},
            {DOCX, MIME_DOCX},
            { XLS, MIME_XLS},
            {XLSX, MIME_XLSX},
            {PPT, MIME_PPT},
            {PPTX, MIME_PPTX},

            {ZIP, MIME_ZIP},
        };

        public const string TAGS = "Tags";

        public const string CONTEXT_DEFAULT = "default";

        public const string CONTEXT_LOGO = "solution_logo";

        public const string CONTEXT_DP = "user_dp";

        public static readonly List<string> ImageTypes = new List<string>
        {
            JPG,JPEG,BMP,PNG
        };

        public static readonly List<string> AudioTypes = new List<string>
        {
            M4A,FLAC,MP3,WAVE,WMA,AAC,OPUS
        };
    }
}

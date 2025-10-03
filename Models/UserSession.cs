using System;
using System.Collections.Generic;

namespace ExpressBase.Commons.Models
{
    public class UserSession
    {
        
        public const string ENTITY = "user_session";

        public const string SESSION_TAG = "session_tag";

        public const string USER_SESSION_TAG_PUBLIC_FORM_V2 = "public_form_v2";

        public static readonly string[] USER_SESSION_TAGS =
        {
            USER_SESSION_TAG_PUBLIC_FORM_V2
        };
    }
}

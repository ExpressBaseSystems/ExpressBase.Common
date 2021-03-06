﻿using System;
using System.Collections.Generic;
using System.Text;

namespace ExpressBase.Common.Structures
{
    public class SocialSignup
    {
        public string Email { get; set; }
        public string Fullname { get; set; }
        public string Social_id { get; set; }
        public string AuthProvider { get; set; }
        public string Country { get; set; }
        public string IsVerified { get; set; }
        public string Pauto { get; set; }
        public bool UniqueEmail { get; set; }
        public string FbId { get; set; }
        public string GithubId { get; set; }
        public string TwitterId { get; set; }
        public string GoogleId { get; set; }
        public string LinkedInId { get; set; }
		public bool Forsignup { get; set; }
	}
}

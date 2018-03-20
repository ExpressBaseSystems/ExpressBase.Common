using ExpressBase.Security;
using ServiceStack;
using ServiceStack.Auth;
using ServiceStack.Caching;
using ServiceStack.Logging;
using ServiceStack.Web;
using System;
using System.Collections.Generic;
using System.Runtime.Serialization;
using System.Text;

namespace ExpressBase.Common.ServiceStack.Auth
{
    [DataContract]
    public class CustomUserSession : AuthUserSession
    {
        [DataMember(Order = 1)]
        public string CId { get; set; }

        [DataMember(Order = 2)]
        public int Uid { get; set; }

        [DataMember(Order = 3)]
        public User User { get; set; }

        [DataMember(Order = 4)]
        public string WhichConsole { get; set; }

        public override bool IsAuthorized(string provider)
        {
            return true;
        }

        public override bool FromToken
        {
            get
            {
                return base.FromToken;
            }

            set
            {
                base.FromToken = value;
            }
        }

        public override string ProfileUrl
        {
            get
            {
                return base.ProfileUrl;
            }

            set
            {
                base.ProfileUrl = value;
            }
        }

        public override string Sequence
        {
            get
            {
                return base.Sequence;
            }

            set
            {
                base.Sequence = value;
            }
        }

        public override bool IsAuthenticated
        {
            get
            {
                return base.IsAuthenticated;
            }

            set
            {
                base.IsAuthenticated = value;
            }
        }

        public override void OnCreated(IRequest httpReq)
        {
            base.OnCreated(httpReq);
        }

        //public override void OnAuthenticated(IServiceBase authService, IAuthSession session, IAuthTokens tokens, Dictionary<string, string> authInfo)
        //{
        //    base.OnAuthenticated(authService, this, tokens, authInfo);
        //    ILog log = LogManager.GetLogger(GetType());

        //    var user = session.ConvertTo<User>();
        //    user.Id = (session as CustomUserSession).Uid;

        //    foreach (var authToken in session.ProviderOAuthAccess)
        //    {
        //        if (authToken.Provider == FacebookAuthProvider.Name)
        //        {
        //            user.UserName = authToken.DisplayName;
        //            user.FirstName = authToken.FirstName;
        //            user.LastName = authToken.LastName;
        //            user.Email = authToken.Email;
        //        }
        //    }
        //}

        public override void OnLogout(IServiceBase authService)
        {
            base.OnLogout(authService);
            using (var cache = authService.TryResolve<ICacheClient>())
            {
                var sessionKey = SessionFeature.GetSessionKey(this.Id);
                cache.Remove(sessionKey);
            } 
        }
    }
}

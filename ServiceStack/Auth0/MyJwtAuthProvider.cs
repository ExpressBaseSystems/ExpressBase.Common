using ExpressBase.Common.Constants;
using ExpressBase.Security;
using ServiceStack;
using ServiceStack.Auth;
using ServiceStack.Configuration;
using ServiceStack.Text;
using ServiceStack.Web;
using System;
using System.Collections.Generic;
using System.IO;
using System.Security.Cryptography;

namespace ExpressBase.Common.ServiceStack.Auth
{
    /// <summary>
    /// Used to Issue and process JWT Tokens and registers ConvertSessionToToken Service to convert Sessions to JWT Tokens
    /// </summary>
    public class MyJwtAuthProvider : JwtAuthProvider
    {
        public MyJwtAuthProvider() { }

        public MyJwtAuthProvider(IAppSettings appSettings) : base(appSettings) { }

        public override void Init(IAppSettings appSettings = null)
        {
            this.SetBearerTokenOnAuthenticateResponse = true;

            ServiceRoutes = new Dictionary<Type, string[]>
            {
                { typeof(ConvertSessionToTokenService), new[] { "/session-to-token" } },
                //{ typeof(GetAccessTokenService), new[] { "/access-token" } },
            };

            base.Init(appSettings);
        }

        public override string CreateJwtBearerToken(IAuthSession session, IEnumerable<string> roles = null, IEnumerable<string> perms = null) =>
            CreateJwtBearerToken(null, session, roles, perms);

        public override string CreateJwtBearerToken(IRequest req, IAuthSession session, IEnumerable<string> roles = null, IEnumerable<string> perms = null)
        {
            var jwtPayload = CreateJwtPayload(session, Issuer, ExpireTokensIn, Audience, roles, perms);
            CreatePayloadFilter?.Invoke(jwtPayload, session);

            if (EncryptPayload)
            {
                var publicKey = GetPublicKey(req);
                if (publicKey == null)
                    throw new NotSupportedException("PublicKey is required to EncryptPayload");

                return CreateEncryptedJweToken(jwtPayload, publicKey.Value);
            }

            var jwtHeader = CreateJwtHeader(HashAlgorithm, GetKeyId(req));
            CreateHeaderFilter?.Invoke(jwtHeader, session);

            var hashAlgoritm = GetHashAlgorithm(req);
            var bearerToken = CreateJwt(jwtHeader, jwtPayload, hashAlgoritm);
            return bearerToken;
        }

        public override JsonObject CreateJwtPayload(
            IAuthSession session, string issuer, TimeSpan expireIn,
            string audience = null,
            IEnumerable<string> roles = null,
            IEnumerable<string> permissions = null)
        {
            var now = DateTime.UtcNow;
            var jwtPayload = new JsonObject
            {
                {TokenConstants.ISS, issuer},
                {TokenConstants.SUB, session.UserAuthId},
                {TokenConstants.IAT, now.ToUnixTime().ToString()},
                {TokenConstants.EXP, now.Add(expireIn).ToUnixTime().ToString()},
            };

            if (audience != null)
                jwtPayload["aud"] = audience;

            var csession = session as CustomUserSession;

            string[] tempa = session.UserAuthId.Split('-');
            jwtPayload[TokenConstants.EMAIL] = tempa[1];
            jwtPayload[TokenConstants.CID] = tempa[0];
            jwtPayload[TokenConstants.UID] = csession.Uid.ToString();
            jwtPayload[RoutingConstants.WC] = csession.WhichConsole;

            return jwtPayload;
        }
    }
}

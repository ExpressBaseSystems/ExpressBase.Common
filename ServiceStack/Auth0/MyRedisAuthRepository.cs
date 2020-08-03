using ExpressBase.Common.Constants;
using ExpressBase.Security;
using ServiceStack.Auth;
using ServiceStack.Redis;
using System;
using System.Collections.Generic;
using System.Linq;

namespace ExpressBase.Common.ServiceStack.Auth
{
    public class MyRedisAuthRepository : RedisAuthRepository
    {
        public MyRedisAuthRepository(IRedisClientsManager f2)
            : base(f2) { }

        public override IUserAuth CreateUserAuth(IUserAuth newUser, string password)
        {
            using (var redis2 = factory2.GetClient())
                redis2.Set<IUserAuth>(string.Format(TokenConstants.SUB_FORMAT, (newUser as User).CId, (newUser as User).UserId, (newUser as User).wc), newUser);

            return newUser;
        }

        public override IUserAuth UpdateUserAuth(IUserAuth existingUser, IUserAuth newUser, string password)
        {
            using (var redis2 = factory2.GetClient())
                redis2.Set<IUserAuth>(string.Format(TokenConstants.SUB_FORMAT, (newUser as User).CId, (newUser as User).UserId, (newUser as User).wc), newUser);

            return newUser;
        }

        public override IUserAuth UpdateUserAuth(IUserAuth existingUser, IUserAuth newUser)
        {
            using (var redis2 = factory2.GetClient())
                redis2.Set<IUserAuth>(string.Format(TokenConstants.SUB_FORMAT, (newUser as User).CId, (newUser as User).UserId, (newUser as User).wc), newUser);

            return newUser;
        }

        public override IUserAuth GetUserAuth(string userAuthId)
        {
            using (var redis = this.factory2.GetClient())
            {
                var x = redis.Get<IUserAuth>(userAuthId);
                return x;
            }
        }

        public override IUserAuth GetUserAuth(IAuthSession authSession, IAuthTokens tokens)
        {
            var csession = authSession as CustomUserSession;
            using (var redis2 = factory2.GetClient())
                return redis2.Get<IUserAuth>(string.Format(TokenConstants.SUB_FORMAT, csession.CId, csession.Uid, csession.WhichConsole));
        }

        public void Clear() { factory.Clear(); }

        public override void LoadUserAuth(IAuthSession session, IAuthTokens tokens)
        {
            //if (session == null)
            //    throw new ArgumentNullException(nameof(session));

            //var userAuth = GetUserAuth(session, tokens);
            //LoadUserAuth(session, userAuth);
        }

        //private void LoadUserAuth(IAuthSession session, IUserAuth userAuth)
        //{
        //    session.PopulateSession(userAuth,
        //        GetUserAuthDetails(session.UserAuthId).ConvertAll(x => (IAuthTokens)x));
        //}

        //public List<IUserAuthDetails> GetUserAuthDetails(string userAuthId)
        //{
        //    return base.GetUserAuthDetails("6");
        //    if (userAuthId == null)
        //        throw new ArgumentNullException(nameof(userAuthId));

        //    using (var redis = factory.GetClient())
        //    {
        //        var idx = IndexUserAuthAndProviderIdsSet(userAuthId);
        //        var authProiverIds = redis.GetAllItemsFromSet(idx);
        //        return null;
        //        // return redis.As<TUserAuthDetails>().GetByIds(authProiverIds).OrderBy(x => x.ModifiedDate).Cast<IUserAuthDetails>().ToList();
        //    }
        //}
    }
}


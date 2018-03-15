using ExpressBase.Security;
using ServiceStack.Auth;
using ServiceStack.Redis;

namespace ExpressBase.Common.ServiceStack.Auth
{
    public class MyRedisAuthRepository: RedisAuthRepository
    {
        public MyRedisAuthRepository(IRedisClientsManager f2)
            : base(f2) { }

        public override IUserAuth CreateUserAuth(IUserAuth newUser, string password)
        {
            using (var redis2 = factory2.GetClient())
                redis2.Set<IUserAuth>(string.Format("{0}-{1}-{2}", (newUser as User).CId, newUser.Email, (newUser as User).wc), newUser);

            return newUser;
        }

        public override IUserAuth UpdateUserAuth(IUserAuth existingUser, IUserAuth newUser, string password)
        {
            using (var redis2 = factory2.GetClient())
                redis2.Set<IUserAuth>(string.Format("{0}-{1}-{2}", (newUser as User).CId, newUser.Email, (newUser as User).wc), newUser);

            return newUser;
        }

        public override IUserAuth UpdateUserAuth(IUserAuth existingUser, IUserAuth newUser)
        {
            using (var redis2 = factory2.GetClient())
                redis2.Set<IUserAuth>(string.Format("{0}-{1}-{2}", (newUser as User).CId, newUser.Email, (newUser as User).wc), newUser);

            return newUser;
        }

        public override IUserAuth GetUserAuth(string userAuthId)
        {
            using (var redis = this.factory2.GetClient())
            {
                var x= redis.Get<IUserAuth>(userAuthId);
                return x;
            }
        }

        public override IUserAuth GetUserAuth(IAuthSession authSession, IAuthTokens tokens)
        {
            var csession = authSession as CustomUserSession;
            using (var redis2 = factory2.GetClient())
                return redis2.Get<IUserAuth>(string.Format("{0}-{1}-{2}", csession.CId, csession.Email, csession.WhichConsole));
        }

        public void Clear() { factory.Clear(); }
    }
}


using ExpressBase.Common.Constants;
using Microsoft.IdentityModel.Tokens;
using System;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;

namespace ExpressBase.Common.Helpers
{
    public static class JwtHelpers
    {
        public static string GenerateToken(string SolutionId, int UserId, int IdNumber)
        {
            var securityKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(Environment.GetEnvironmentVariable(EnvironmentConstants.EB_API_SECRET)));
            var credentials = new SigningCredentials(securityKey, SecurityAlgorithms.HmacSha256);

            var claims = new[]
            {
                new Claim(TokenConstants.SUB, $"{SolutionId}:{UserId}:{TokenConstants.AC}"),
                new Claim(TokenConstants.CID, SolutionId),
                new Claim(TokenConstants.UID, UserId.ToString()),
                new Claim(TokenConstants.WC, TokenConstants.AC),
                new Claim(TokenConstants.ID, IdNumber.ToString()),
                new Claim(JwtRegisteredClaimNames.Iat, DateTimeOffset.UtcNow.ToUnixTimeSeconds().ToString(), ClaimValueTypes.Integer64)
            };

            var tokenDescriptor = new SecurityTokenDescriptor
            {
                Subject = new ClaimsIdentity(claims),
                Expires = DateTime.UtcNow.AddYears(3),
                SigningCredentials = credentials
            };

            var tokenHandler = new JwtSecurityTokenHandler();
            var token = tokenHandler.CreateToken(tokenDescriptor);

            return tokenHandler.WriteToken(token);
        }

        public static bool ValidateToken(string token, out ClaimsPrincipal claimsPrincipal)
        {
            claimsPrincipal = null;

            try
            {
                var securityKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(Environment.GetEnvironmentVariable(EnvironmentConstants.EB_API_SECRET)));
                var tokenValidationParameters = new TokenValidationParameters
                {
                    ValidateIssuer = false,
                    ValidateAudience = false,
                    ValidateLifetime = true,
                    ValidateIssuerSigningKey = true,
                    IssuerSigningKey = securityKey
                };

                var tokenHandler = new JwtSecurityTokenHandler();
                claimsPrincipal = tokenHandler.ValidateToken(token, tokenValidationParameters, out SecurityToken validatedToken);

                return true;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"JWT Validation Error: {ex.Message}");
                return false;
            }
        }
    }
}

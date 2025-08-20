using ExpressBase.Common.Constants;
using Microsoft.AspNetCore.Http;
using System;
using System.Collections.Generic;
using System.Text;

namespace ExpressBase.Common.Connections
{
    public interface ISolutionContext
    {
        string TenantId { get; }
    }

    public class HttpSolutionContext : ISolutionContext
    {
        private readonly IHttpContextAccessor _httpContextAccessor;

        public HttpSolutionContext(IHttpContextAccessor httpContextAccessor)
        {
            _httpContextAccessor = httpContextAccessor;
        }

        public string TenantId
        {
            get
            {
                var context = _httpContextAccessor.HttpContext;
                if (context?.Items.TryGetValue(CoreConstants.SOLUTION_ID, out var tenantId) == true)
                    return tenantId?.ToString();

                return CoreConstants.EXPRESSBASE; // default fallback
            }
        }
    }
}

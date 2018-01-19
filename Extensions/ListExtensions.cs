using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;

namespace ExpressBase.Common.Extensions
{
    public static class ListExtensions
    {
        public static IEnumerable Flatten(this IEnumerable enumerable)
        {
            foreach (object element in enumerable)
            {
                IEnumerable candidate = element as IEnumerable;
                if (candidate != null)
                {
                    foreach (object nested in Flatten(candidate))
                        yield return nested;
                }
                else
                    yield return element;
            }
        }
    }
}

using System;

namespace ExpressBase.Common.Helpers
{
    public static class StringHelper
    {
        /// <summary>
        /// Returns true if the string is neither null, empty, nor whitespace.
        /// </summary>
        public static bool HasValue(string input)
        {
            return !string.IsNullOrEmpty(input) && !string.IsNullOrWhiteSpace(input);
        }
    }
}

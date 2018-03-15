namespace ServiceStack.Discovery.Redis
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using ServiceStack.DataAnnotations;
    using ServiceStack;

    public static class TypeExtensions
    {
        /// <summary>
        /// Filters out types with <see cref="ExcludeAttribute"/> 
        /// containing values of <see cref="Feature.Metadata"/> or <see cref="Feature.ServiceDiscovery"/>
        /// </summary>
        /// <param name="types">the types to filter</param>
        /// <returns>the filtered types</returns>
        public static IEnumerable<Type> WithServiceDiscoveryAllowed(this IEnumerable<Type> types)
        {
            return types
                .Where(x => x.AllAttributes<ExcludeAttribute>().All(a => (!a.Feature.HasFlag(Feature.Metadata))))
                .Where(x => x.AllAttributes<ExcludeAttribute>().All(a => (!a.Feature.HasFlag(Feature.ServiceDiscovery))));
        }

        /// <summary>
        /// Filters out ServiceStack native type namespaces and types
        /// </summary>
        /// <param name="types">the types to filter</param>
        /// <param name="nativeTypes">the NativeTypesFeature</param>
        /// <returns>the filtered types</returns>
        public static IEnumerable<Type> WithoutNativeTypes(this IEnumerable<Type> types, NativeTypesFeature nativeTypes)
        {
            return nativeTypes == null

                ? types
                : types
                    .Where(x => !nativeTypes.MetadataTypesConfig.IgnoreTypes.Contains(x))
                    .Where(x => !nativeTypes.MetadataTypesConfig.IgnoreTypesInNamespaces.Contains(x.Namespace));
        }

        public static bool HasXmlClientSupport(this Type type) => !type.AllAttributes<ExcludeAttribute>().Any(t => t.Feature.HasFlag(Feature.Xml)) &&
                                                                  type.AllAttributes<RestrictAttribute>().All(t => t.HasAccessTo(RequestAttributes.Xml));
        public static bool HasJsvClientSupport(this Type type) => !type.AllAttributes<ExcludeAttribute>().Any(t => t.Feature.HasFlag(Feature.Jsv)) &&
                                                                  type.AllAttributes<RestrictAttribute>().All(t => t.HasAccessTo(RequestAttributes.Jsv));
        public static bool HasJsonClientSupport(this Type type) => !type.AllAttributes<ExcludeAttribute>().Any(t => t.Feature.HasFlag(Feature.Json)) &&
                                                                  type.AllAttributes<RestrictAttribute>().All(t => t.HasAccessTo(RequestAttributes.Json));
    }
}
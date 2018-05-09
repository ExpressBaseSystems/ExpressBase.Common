using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;

namespace ExpressBase.Common.JsonConverters
{
    // https://stackoverflow.com/questions/28451990/newtonsoft-json-deserialize-dictionary-as-key-value-list-from-datacontractjsonse
    public class DictionaryConverter : JsonConverter
    {
        public override bool CanConvert(Type objectType)
        {
			return (typeof(IDictionary<string, object>).IsAssignableFrom(objectType));
        }

        public override bool CanWrite { get { return true; } }

        object ReadJsonGeneric<TKey, TValue>(JsonReader reader, Type objectType, object existingValue, JsonSerializer serializer)
        {
			JObject obj = JObject.Load(reader);

			var dict = new Dictionary<string, object>();
			var x = obj.Last.First;

			foreach(JToken child in obj.Last.First.Children())
			{
				if (child.First.Type == JTokenType.String)
					dict.Add(child.Path.Remove(0, 8), child.First.Value<string>());
				else if (child.First.Type == JTokenType.Integer)
					dict.Add(child.Path.Remove(0, 8), child.First.Value<Int32>());
				else if (child.First.Type == JTokenType.Float)
					dict.Add(child.Path.Remove(0, 8), child.First.Value<float>());
			}

            return dict;
        }

        public override object ReadJson(JsonReader reader, Type objectType, object existingValue, JsonSerializer serializer)
        {
            var keyValueTypes = objectType.GetDictionaryKeyValueTypes().Single(); // Throws an exception if not exactly one.

            var method = GetType().GetMethod("ReadJsonGeneric", BindingFlags.NonPublic | BindingFlags.Instance | BindingFlags.Public);
            var genericMethod = method.MakeGenericMethod(new[] { keyValueTypes.Key, keyValueTypes.Value });
            return genericMethod.Invoke(this, new object[] { reader, objectType, existingValue, serializer });
        }

        public override void WriteJson(JsonWriter writer, object value, JsonSerializer serializer)
        {
			//throw new NotImplementedException();
			writer.Formatting = Formatting.Indented;
			writer.WriteStartObject();
			writer.WritePropertyName("$type");
			writer.WriteValue(typeof(IDictionary<string, object>).ToString());
			writer.WritePropertyName("$values");
			writer.WriteStartObject();
			foreach (KeyValuePair<string, object> entry in (value as IDictionary<string, object>))
			{
				writer.WritePropertyName(entry.Key);
				writer.WriteValue(entry.Value);
			}
			writer.WriteEnd();
			writer.WriteEndObject();
		}
    }

    public static class TypeExtensions
    {
        /// <summary>
        /// Return all interfaces implemented by the incoming type as well as the type itself if it is an interface.
        /// </summary>
        /// <param name="type"></param>
        /// <returns></returns>
        public static IEnumerable<Type> GetInterfacesAndSelf(this Type type)
        {
            if (type == null)
                throw new ArgumentNullException();
            if (type.IsInterface)
                return new[] { type }.Concat(type.GetInterfaces());
            else
                return type.GetInterfaces();
        }

        public static IEnumerable<KeyValuePair<Type, Type>> GetDictionaryKeyValueTypes(this Type type)
        {
            foreach (Type intType in type.GetInterfacesAndSelf())
            {
                if (intType.IsGenericType
                    && intType.GetGenericTypeDefinition() == typeof(IDictionary<,>))
                {
                    var args = intType.GetGenericArguments();
                    if (args.Length == 2)
                        yield return new KeyValuePair<Type, Type>(args[0], args[1]);
                }
            }
        }
    }

    //public class DictionaryConverter : JsonConverter
    //{
    //    public override object ReadJson(
    //        JsonReader reader,
    //        Type objectType,
    //        object existingValue,
    //        JsonSerializer serializer)
    //    {
    //        IDictionary<string, object> result;

    //        if (reader.TokenType == JsonToken.StartArray)
    //        {
    //            JArray legacyArray = (JArray)JArray.ReadFrom(reader);

    //            result = legacyArray.ToDictionary(
    //                el => el["Key"].ToString(),
    //                el => el["Value"]);
    //        }
    //        else
    //        {
    //            result =
    //                (IDictionary<string, object>)
    //                    serializer.Deserialize(reader, typeof(IDictionary<string, object>));
    //        }

    //        return result;
    //    }

    //    public override void WriteJson(
    //        JsonWriter writer, object value, JsonSerializer serializer)
    //    {
    //        throw new NotImplementedException();
    //    }

    //    public override bool CanConvert(Type objectType)
    //    {
    //        return typeof(IDictionary<string, string>).IsAssignableFrom(objectType);
    //    }

    //    public override bool CanWrite
    //    {
    //        get { return false; }
    //    }
    //}
}

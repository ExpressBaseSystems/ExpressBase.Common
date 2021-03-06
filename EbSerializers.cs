﻿using ExpressBase.Common.Objects;
using ExpressBase.Common.Objects.Attributes;
using ExpressBase.Common.Structures;
using ExpressBase.Objects;
using Newtonsoft.Json;
using Newtonsoft.Json.Serialization;
using ProtoBuf;
using ProtoBuf.Meta;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.IO.Compression;
using System.Linq;
using System.Reflection;

namespace ExpressBase.Common
{
    public class EbSerializers
    {
        public static byte[] ProtoBuf_Serialize(object obj)
        {
            byte[] buffer = null;

            using (var memoryStream = new System.IO.MemoryStream())
            {
                ProtoBuf.Serializer.Serialize(memoryStream, obj);
                buffer = memoryStream.ToArray();
            }

            return buffer;
        }

        public static void ProtoBuf_Serialize(Stream stream, object obj)
        {
            ProtoBuf.Serializer.Serialize(stream, obj);
        }

        public static T ProtoBuf_DeSerialize<T>(byte[] bytea)
        {
            object obj = null;

            using (var mem2 = new MemoryStream(bytea))
            {
                obj = ProtoBuf.Serializer.Deserialize<T>(mem2);
            }

            return (T)obj;
        }

        public static T ProtoBuf_DeSerialize<T>(Stream stream)
        {
            object obj = null;
            obj = ProtoBuf.Serializer.Deserialize<T>(stream);

            return (T)obj;
        }

        public static string Json_Serialize(object obj)
        {
            return JsonConvert.SerializeObject(obj, new JsonSerializerSettings
            {
                TypeNameHandling = TypeNameHandling.All,
                ContractResolver = new ShouldSerializeContractResolver()
            });
        }

        public static string Json_Serialize4AppWraper(ExportPackage package)
        {
            try
            {
                foreach (AppWrapper app in package.Apps)
                {
                    List<EbObject> RootObjects = app.ObjCollection;

                    for (int i = 0; i < RootObjects.Count; i++)
                    {
                        string jsonS = Json_Serialize(RootObjects[i]);

                        app.ObjCollection[i] = Json_Deserialize(jsonS);
                    }
                }              

                return JsonConvert.SerializeObject(package, new JsonSerializerSettings { TypeNameHandling = TypeNameHandling.All });
            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message + e.StackTrace);
                return "";
            }
        }

        public static T Json_Deserialize<T>(string json)
        {
            return (T)(JsonConvert.DeserializeObject(json, new JsonSerializerSettings
            {
                TypeNameHandling = TypeNameHandling.All,
                ObjectCreationHandling = ObjectCreationHandling.Replace,
                MetadataPropertyHandling = MetadataPropertyHandling.ReadAhead
            }));
        }

        public static dynamic Json_Deserialize(string json)
        {
            try
            {
                return JsonConvert.DeserializeObject(json,
                    new JsonSerializerSettings
                    {
                        TypeNameHandling = TypeNameHandling.All,
                        ObjectCreationHandling = ObjectCreationHandling.Replace,
                        MetadataPropertyHandling = MetadataPropertyHandling.ReadAhead
                    });
            }
            catch (Exception ex)
            {

                //if (@"Error converting value 3 to type 'ExpressBase.Common.Objects.UISides'. Path 'Controls.$values[1].Controls.$values[0].Controls.$values[0].Controls.$values[0].Padding', line 1, position 3307."
                //    == ex.Message) {
                //    json = json.Replace("\"Padding\":3", "\"Padding\":{\"$type\":\"ExpressBase.Common.Objects.UISides, ExpressBase.Common\",\"Top\":3,\"Right\":3,\"Bottom\":3,\"Left\":3}");

                //    return JsonConvert.DeserializeObject(json,
                //    new JsonSerializerSettings
                //    {
                //        TypeNameHandling = TypeNameHandling.All,
                //        ObjectCreationHandling = ObjectCreationHandling.Replace,
                //        MetadataPropertyHandling = MetadataPropertyHandling.ReadAhead
                //    });
                //}

                Console.WriteLine("============Json_Deserialize Exception : " + ex.Message);

                return null;
            }
        }
    }

    // a new ContractResolver to override default CreateProperties() 
    public class ShouldSerializeContractResolver : DefaultContractResolver
    {
        private BuilderType _rootObjectBuilderType = (BuilderType)(-1);// initialize with a non existing enum  value

        public ShouldSerializeContractResolver() { }

        //override default CreateProperties()
        protected override IList<JsonProperty> CreateProperties(Type type, MemberSerialization memberSerialization)
        {
            Type _CurrentClassType = type;

            // creates all properties of an object
            IList<JsonProperty> properties = base.CreateProperties(type, memberSerialization);

            //set _rootObjectType - if the object is a type of IEBRootObject and not yet set
            if (typeof(IEBRootObject).IsAssignableFrom(_CurrentClassType) && (int)_rootObjectBuilderType == -1)
                _rootObjectBuilderType = _CurrentClassType.GetCustomAttribute<BuilderTypeEnum>().Type;

            //if rootObject Found - to skip checking for individual objects which are not inside a rootObject
            // && if decoratedby EnableInBuilder attribute skip checking - for helper objects which are not decoratedby EnableInBuilder attribute
            if ((int)_rootObjectBuilderType != -1 && type.IsDefined(typeof(EnableInBuilder)))
            {// filter properties by EnableInBuilder attribute

                PropertyInfo PropertyInfo = null;
                properties = properties.Where(p =>
                {
                    PropertyInfo = _CurrentClassType.GetProperty(p.UnderlyingName);// takes PropertyInfo by name to get EnableInBuilder attribute

                    if (PropertyInfo != null && PropertyInfo.IsDefined(typeof(EnableInBuilder), false))
                        return PropertyInfo.GetCustomAttribute<EnableInBuilder>().BuilderTypes.ToList().Contains(_rootObjectBuilderType);
                    else
                        return false;
                }).ToList();
            }
            return properties;
        }
    }


    public class DataSetCompressor
    {
        public static Byte[] Compress(DataSet dataset)
        {
            byte[] data;
            MemoryStream mem = new MemoryStream();
            GZipStream zip = new GZipStream(mem, CompressionMode.Compress);
            dataset.WriteXml(zip, XmlWriteMode.WriteSchema);
            zip.Close();
            data = mem.ToArray();
            mem.Close();
            return data;
        }
        public static DataSet Decompress(byte[] data)
        {
            MemoryStream mem = new MemoryStream(data);
            GZipStream zip = new GZipStream(mem, CompressionMode.Decompress);
            DataSet dataset = new DataSet();
            dataset.ReadXml(zip, XmlReadMode.ReadSchema);
            zip.Close();
            mem.Close();
            return dataset;
        }
    }

    [ProtoContract]
    public class MemorystreamWrapper
    {
        public MemorystreamWrapper() : this(new MemoryStream()) { }

        public MemorystreamWrapper(MemoryStream stream)
        {
            if (stream == null)
                throw new ArgumentNullException();
            this.Memorystream = stream;
        }

        [ProtoIgnore]
        public MemoryStream Memorystream { get; set; }

        internal static event EventHandler OnDataReadBegin;

        internal static event EventHandler OnDataReadEnd;

        const int ChunkSize = 4096;

        [ProtoMember(1, IsPacked = false, OverwriteList = true)]
        IEnumerable<ByteBuffer> Data
        {
            get
            {
                if (OnDataReadBegin != null)
                    OnDataReadBegin(this, new EventArgs());

                while (true)
                {
                    byte[] buffer = new byte[ChunkSize];
                    int read = Memorystream.Read(buffer, 0, buffer.Length);
                    if (read <= 0)
                    {
                        break;
                    }
                    else if (read == buffer.Length)
                    {
                        yield return new ByteBuffer { Data = buffer };
                    }
                    else
                    {
                        Array.Resize(ref buffer, read);
                        yield return new ByteBuffer { Data = buffer };
                        break;
                    }
                }

                if (OnDataReadEnd != null)
                    OnDataReadEnd(this, new EventArgs());
            }
            set
            {
                if (value == null)
                    return;
                foreach (var buffer in value)
                    Memorystream.Write(buffer.Data, 0, buffer.Data.Length);
            }
        }
    }

    [ProtoContract]
    public struct ByteBuffer
    {
        [ProtoMember(1, IsPacked = true)]
        public byte[] Data { get; set; }
    }
}


﻿using ExpressBase.Common.Structures;
using Newtonsoft.Json;
using ProtoBuf;
using ProtoBuf.Meta;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.IO.Compression;

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
            RuntimeTypeModel.Default[typeof(EbDbType)].SetSurrogate(typeof(EbDbTypeSurrogate));
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
            RuntimeTypeModel.Default[typeof(EbDbType)].SetSurrogate(typeof(EbDbTypeSurrogate));
            obj = ProtoBuf.Serializer.Deserialize<T>(stream);

            return (T)obj;
        }

        public static string Json_Serialize(object obj)
        {
            return JsonConvert.SerializeObject(obj, new JsonSerializerSettings { TypeNameHandling = TypeNameHandling.All });
        }

        public static T Json_Deserialize<T>(string json)
        {
            return (T)(JsonConvert.DeserializeObject(json, new JsonSerializerSettings { TypeNameHandling = TypeNameHandling.All }));
        }

        public static dynamic Json_Deserialize(string json)
        {
            return JsonConvert.DeserializeObject(json, new JsonSerializerSettings { TypeNameHandling = TypeNameHandling.All });
        }
    }

    [ProtoContract]
    public class EbDbTypeSurrogate
    {
        [ProtoMember(1)]
        public int IntCode { get; set; }

        public static implicit operator EbDbTypeSurrogate(EbDbType myClass)
        {
            return
                new EbDbTypeSurrogate { IntCode = myClass.IntCode };
        }

        public static implicit operator EbDbType(EbDbTypeSurrogate myClass)
        {
            return (EbDbType)myClass.IntCode;
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


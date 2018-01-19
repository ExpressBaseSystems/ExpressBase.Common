using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Newtonsoft.Json;
using ProtoBuf;

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

        public static T ProtoBuf_DeSerialize<T>(byte[] bytea)
        {
            object obj = null;

            using (var mem2 = new MemoryStream(bytea))
            {
                obj = ProtoBuf.Serializer.Deserialize<T>(mem2);
            }

            return (T)obj;
        }

        public static string Json_Serialize(object obj)
        {
            string json = null;

            json = JsonConvert.SerializeObject(obj, new JsonSerializerSettings { TypeNameHandling = TypeNameHandling.All });

            return json;
        }

        public static T Json_Deserialize<T>(string json)
        {
            object obj = null;

            obj = JsonConvert.DeserializeObject(json, new JsonSerializerSettings { TypeNameHandling = TypeNameHandling.All });

            return (T)obj;
        }

        public static dynamic Json_Deserialize(string json)
        {
            object obj = null;

            obj = JsonConvert.DeserializeObject(json, new JsonSerializerSettings { TypeNameHandling = TypeNameHandling.All });

            return obj;
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


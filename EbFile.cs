using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExpressBase.Common
{
    public class EbFile
    {
        public static void Bytea_ToFile(byte[] bytea, string path)
        {
            using (var fileStream = File.Create(path))
            {
                fileStream.Write(bytea, 0, bytea.Length);
            }
        }

        public static byte[] Bytea_FromFile(string path)
        {
            byte[] bytea = null;

            using (var fileStream = new FileStream(path, FileMode.Open, FileAccess.Read, FileShare.ReadWrite))
            {
                bytea = new byte[(int)fileStream.Length];
                fileStream.Read(bytea, 0, (int)fileStream.Length);
            }

            return bytea;
        }
    }
}


using ExpressBase.Common.Constants;
using System;
using System.Collections.Generic;
using System.IO;
using System.Security.Cryptography;
using System.Text;
using System.Xml;

namespace ExpressBase.Common.Security
{
    public class HelperFunction
    {
        public static string GeneratePassword()
        {
            string strPwdchar = "abcdefghijklmnopqrstuvwxyz0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
            string strPwd = "a";
            Random rnd = new Random();
            for (int i = 0; i <= 7; i++)
            {
                int iRandom = rnd.Next(0, strPwdchar.Length - 1);
                strPwd += strPwdchar.Substring(iRandom, 1);
            }
            return strPwd;
        }

		//private static string key_iv = "GmZbtv8J5LIT73KDRKrNNdBr62RKlBkOpFV8iIfiScQ=.nhjKQSduQUm3MMCAPGCS3Q==";////////
		private static string key_iv1 = null;
		private static string key_iv
		{
			get
			{
				if(key_iv1 == null)
				{
					using (AesManaged aesAlg = new AesManaged())
					{
						key_iv1 = Convert.ToBase64String(aesAlg.Key) + CharConstants.DOT + Convert.ToBase64String(aesAlg.IV);
					}
				}
				return key_iv1;
			}
		}

		public static string GetEncriptedString_Aes(string plainText)
		{
		//	byte[] key = Convert.FromBase64String(key_iv.Split(CharConstants.DOT)[0]);
		//	byte[] iv = Convert.FromBase64String(key_iv.Split(CharConstants.DOT)[1]);
		//	if (plainText == null || plainText.Length <= 0)
		//		throw new ArgumentNullException("plainText");
		//	if (key == null || key.Length <= 0)
		//		throw new ArgumentNullException("Key");
		//	if (iv == null || iv.Length <= 0)
		//		throw new ArgumentNullException("Initialization Vector");
		//	byte[] encrypted;
		//	using (AesManaged aesAlg = new AesManaged())
		//	{
		//		aesAlg.Key = key;
		//		aesAlg.IV = iv;
		//		ICryptoTransform encryptor = aesAlg.CreateEncryptor(aesAlg.Key, aesAlg.IV);
		//		using (MemoryStream msEncrypt = new MemoryStream())
		//		{
		//			using (CryptoStream csEncrypt = new CryptoStream(msEncrypt, encryptor, CryptoStreamMode.Write))
		//			{
		//				using (StreamWriter swEncrypt = new StreamWriter(csEncrypt))
		//				{
		//					swEncrypt.Write(plainText);
		//				}
		//				encrypted = msEncrypt.ToArray();
		//			}
		//		}
		//	}
		//	return Convert.ToBase64String(encrypted);
			return (plainText);
		}

		public static string GetDecriptedString_Aes(string cipherText)
		{
			//byte[] key = Convert.FromBase64String(key_iv.Split(CharConstants.DOT)[0]);
			//byte[] iv = Convert.FromBase64String(key_iv.Split(CharConstants.DOT)[1]);
			//if (cipherText == null || cipherText.Length <= 0)
			//	throw new ArgumentNullException("cipherText");
			//if (key == null || key.Length <= 0)
			//	throw new ArgumentNullException("Key");
			//if (iv == null || iv.Length <= 0)
			//	throw new ArgumentNullException("Initialization Vector");
			//string plaintext = null;
			//using (AesManaged aesAlg = new AesManaged())
			//{
			//	aesAlg.Key = key;
			//	aesAlg.IV = iv;
			//	ICryptoTransform decryptor = aesAlg.CreateDecryptor(aesAlg.Key, aesAlg.IV);
			//	using (MemoryStream msDecrypt = new MemoryStream(Convert.FromBase64String(cipherText)))
			//	{
			//		using (CryptoStream csDecrypt = new CryptoStream(msDecrypt, decryptor, CryptoStreamMode.Read))
			//		{
			//			using (StreamReader srDecrypt = new StreamReader(csDecrypt))
			//			{
			//				plaintext = srDecrypt.ReadToEnd();
			//			}
			//		}
			//	}
			//}
			//return plaintext;
			return cipherText;
		}



		
		

		
	}
}

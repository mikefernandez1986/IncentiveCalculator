using System;
using System.Collections.Generic;
using System.Security.Cryptography;
using System.Linq;
using System.Text;
using System.Web;

namespace IncentiveCalcPOC.Helpers
{
    public class HashHelper
    {
        const int SALTLENGTH = 16;
        private byte[] GenerateRandomCryptographicBytes(int keyLength)
        {
            RNGCryptoServiceProvider rngCryptoServiceProvider = new RNGCryptoServiceProvider();
            byte[] randomBytes = new byte[keyLength];
            rngCryptoServiceProvider.GetBytes(randomBytes);
            return randomBytes;
        }
        public string CreateHashWithSalt(string password)
        {
            HashAlgorithm hashAlgo = SHA256.Create();
            byte[] saltBytes = GenerateRandomCryptographicBytes(SALTLENGTH);
            byte[] passwordAsBytes = Encoding.UTF8.GetBytes(password);
            List<byte> passwordWithSaltBytes = new List<byte>();
            passwordWithSaltBytes.AddRange(passwordAsBytes);
            passwordWithSaltBytes.AddRange(saltBytes);
            byte[] digestBytes = hashAlgo.ComputeHash(passwordWithSaltBytes.ToArray());

            List<byte> hashWithSaltBytes = new List<byte>();
            hashWithSaltBytes.AddRange(saltBytes);
            hashWithSaltBytes.AddRange(digestBytes);
            //string saltstr = Convert.ToBase64String(saltBytes);
            //return (Convert.ToBase64String(saltBytes) + "+" + Convert.ToBase64String(digestBytes));
            return (Convert.ToBase64String(hashWithSaltBytes.ToArray()));
        }

        public bool CompareHash(string password, string hashWithSalt)
        {
            HashAlgorithm hashAlgo = SHA256.Create();
            try
            {

                byte[] hashedBytes = Convert.FromBase64String(hashWithSalt); //Encoding.ASCII.GetBytes(textBox3.Text);
                byte[] saltBytes = hashedBytes.Take(16).ToArray();

                byte[] passwordAsBytes = Encoding.UTF8.GetBytes(password);
                List<byte> passwordWithSaltBytes = new List<byte>();
                passwordWithSaltBytes.AddRange(passwordAsBytes);
                passwordWithSaltBytes.AddRange(saltBytes);
                byte[] digestBytes = hashAlgo.ComputeHash(passwordWithSaltBytes.ToArray());
                //string saltstr = Convert.ToBase64String(saltBytes);
                //return (Convert.ToBase64String(saltBytes) + "+" + Convert.ToBase64String(digestBytes));

                List<byte> hashWithSaltBytes = new List<byte>();
                hashWithSaltBytes.AddRange(saltBytes);
                hashWithSaltBytes.AddRange(digestBytes);
                string newHashWithSalt = Convert.ToBase64String(hashWithSaltBytes.ToArray());

                if (hashWithSalt == newHashWithSalt)
                {

                    return true;
                }
                else
                {
                    return false;
                }
            }
            catch
            {
                return false;
            }

        }

    }
}
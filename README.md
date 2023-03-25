# Encrypt/Decrypt script for Linux shell using Openssl
## Parameters
The script used the following parameters:
1. -m The mechanism you want to use: Either enc for encryption or dec for decryption
2. -s The string, folder, file you want to encrypt or decrypt
## How to run the script
1. Make sure Openssl is installed: https://www.howtoforge.com/tutorial/how-to-install-openssl-from-source-on-linux/
2. Clone this repository
3. Make the script executable
   - ```sudo chmod -x encrypt_decrypt.sh```
4. Run the script
   - ```./encrypt_decrypt.sh -m enc -s "This is a sample string"  <<<  SuperS3curePassw0rd!```
   - ```./encrypt_decrypt.sh -m dec -s "U2FsdGVkX1/mgl7Z+Y1cmNATJD/CnTHEFLlKhEwwUlpw8YYchYDoTAzMFGI20bIR"  <<< SuperS3curePassw0rd!```
## Changelog
1. v0.2: Made the script more secure by not having the password as parameter but prompting the password
#!/usr/bin/env bash
set -e

# Test valid encryption of a file
echo "1. Test valid encryption of a file"
touch test_file.txt
./encrypt_decrypt.sh -m enc -s test_file.txt <<< "password"
if [ ! -f "test_file.txt.enc" ]; then
  echo "Test failed: File not encrypted"
  exit 1
else
  echo "Success: 1. Test valid encryption of a file"
fi
rm test_file.txt test_file.txt.enc

# Test valid encryption of a folder
echo "2. Test valid encryption of a folder"
mkdir test_folder
touch test_folder/test_file1.txt test_folder/test_file2.txt
./encrypt_decrypt.sh -m enc -s test_folder <<< "password"
if [ ! -f "test_folder.enc" ]; then
  echo "Test failed: Folder not encrypted"
  exit 1
else
  echo "Success: 2. Test valid encryption of a folder"
fi
rm -rf test_folder test_folder.enc

# Test valid decryption of a file
echo "3. Test valid decryption of a file"
touch test_file.txt
./encrypt_decrypt.sh -m enc -s test_file.txt <<< "password"
./encrypt_decrypt.sh -m dec -s test_file.txt.enc <<< "password"
if [ ! -f "test_file.txt" ]; then
  echo "Test failed: File not decrypted"
  exit 1
else
  echo "Success: 3. Test valid decryption of a file"
fi
rm test_file.txt test_file.txt.enc

# Test valid decryption of a folder
echo "4. Test valid decryption of a folder"
mkdir test_folder
touch test_folder/test_file1.txt test_folder/test_file2.txt
./encrypt_decrypt.sh -m enc -s test_folder <<< "password"
./encrypt_decrypt.sh -m dec -s test_folder.enc <<< "password"
if [ ! -d "test_folder" ]; then
  echo "Test failed: Folder not decrypted"
  exit 1
else
  echo "Success: 4. Test valid decryption of a folder"
fi
rm -rf test_folder test_folder.enc

# Test valid encryption and decryption of a string
echo "5. Test valid encryption of a string"
result=$(./encrypt_decrypt.sh -m enc -s "test_folder" <<< "password")
result_dec=$(./encrypt_decrypt.sh -m dec -s $result <<< "password")
if [ $result_dec != "test_folder" ]; then
  echo "Test failed: String not encrypted correctly"
  exit 1
else
  echo "Success: 5. Test valid encryption of a string"
fi
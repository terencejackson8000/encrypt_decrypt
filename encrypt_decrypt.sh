#!/usr/bin/env bash

# Prompt user to enter password
read -s -p "Enter password: " password
echo

# Get the parameters of the script and assign them
while getopts m:s: flag; do
  case "${flag}" in
    m) mechanism="${OPTARG}" ;;
    s) string="${OPTARG}" ;;
    *) exit 1 ;;
  esac
done

# Check if all parameters are set, if not show an error message and exit the script
if [ -z "$mechanism" ] || [ -z "$string" ]; then
  echo "You need to set all variables to run the script: -m enc for encryption or dec for decryption, -s The string to encrypt/decrypt"
  exit 1
fi

# Check if mechanism is valid
if [[ "$mechanism" != "enc" && "$mechanism" != "dec" ]]; then
  echo "Mechanism (-m) must be enc for encryption or dec for decryption"
  exit 1
fi

if [ "$mechanism" == "enc" ]; then
  if [ -d "$string" ]; then
    # Get the last folder of the provided path
    dir="$(basename "$string")"
    # Compress the folder
    tar -czvf "${dir}.tar.gz" "$string"
    # Encrypt the tar file
    openssl enc -e -a -in "${dir}.tar.gz" -aes-256-cbc -salt -pass "pass:$password" -pbkdf2 -base64 -out "${dir}.enc"
    # Delete the tar file
    rm "${dir}.tar.gz"
    echo "Folder encryption done"
  elif [ -f "$string" ]; then
    openssl enc -e -a -in "$string" -aes-256-cbc -salt -pass "pass:$password" -pbkdf2 -base64 -out "${string}.enc"
    echo "File encryption done"
  else
    echo "$string" | openssl enc -base64 -e -aes-256-cbc -salt -pass "pass:$password" -pbkdf2
  fi
fi

if [ "$mechanism" == "dec" ]; then
  if [ -f "$string" ]; then
    new_str="$(echo "$string" | sed 's/.enc//')"
    openssl enc -d -a -in "$string" -aes-256-cbc -salt -pass "pass:$password" -pbkdf2 -base64 -out "$new_str"
    echo "File decryption done"
  else
    echo "$string" | openssl enc -base64 -d -aes-256-cbc -salt -pass "pass:$password" -pbkdf2
  fi
fi

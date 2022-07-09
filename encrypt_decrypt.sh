#!/usr/bin/env bash

#Get the parameteres of the script and assign them
while getopts m:s:p: flag
do
    case "${flag}" in
        m) mechanism=${OPTARG};;
        s) string=${OPTARG};;
        p) password=${OPTARG};;
    esac
done

#Check if all parameters are set, if not show an error message and exit the script
if [ -z "$mechanism" ] || [ -z "$string" ] || [ -z "$password" ]
    then echo "You need to set all variables to run the script: -m enc for encryption or dec for decryption, -s The string to encrypt/decrypt, -p The password for the encryption/decryption"
    exit 0
fi


#if the mechanism is encryption => encrypt the string, if the mechanism is decryption => decrypt the string
if [ $mechanism == 'enc' ]
    then
    if [ -f "$string" ]
        then 
        openssl enc -e -a -in $string -aes-256-cbc -salt -pass pass:$password -pbkdf2 -base64 -out "${string}.enc"
        echo "File encryption done"
    else
        echo $string | openssl enc -base64 -e -aes-256-cbc -salt -pass pass:$password -pbkdf2
    fi
elif [ $mechanism == 'dec' ]
    then
    if [ -f "$string" ]
        then
        new_str=$(echo $string | sed 's/.enc//')
        openssl enc -d -a -in $string -aes-256-cbc -salt -pass pass:$password -pbkdf2 -base64 -out $new_str
        echo "File decryption done"
    else
        echo $string | openssl enc -base64 -d -aes-256-cbc -salt -pass pass:$password -pbkdf2
    fi
else
    echo "Mechanism (-m) must be enc for encryption or dec for decryption"
fi
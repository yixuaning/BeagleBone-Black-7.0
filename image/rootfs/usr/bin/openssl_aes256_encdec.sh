#!/bin/sh

OPENSSL=/usr/bin/openssl

CRYPTOTYPE=aes-256-cbc

AES_256_GEN=/usr/bin/AES_256

echo -e "\nRunning OpenSSL Encryption Decryption (${CRYPTOTYPE})"

## Encrypt&Decrypt 
## "crypto" is the password for encryption, also for decryption 
$AES_256_GEN crypto





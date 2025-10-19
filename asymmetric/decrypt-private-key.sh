#!/bin/bash
#
# Decrypt an RSA private key file in PEM format 
#
# Author: Jose Faisca
#

# Function to display usage information
usage() {
    echo "Usage: $0 <encrypted_private_key_file>"
    exit 1
}

# Check if input file is provided
if [ $# -ne 1 ]; then
    usage
fi

INPUT_FILE=$1

# Check if input file exists
if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: Input file does not exist."
    exit 1
fi

# Generate output file name
OUTPUT_FILE="dec_${INPUT_FILE}"

# Decrypt the private key
openssl rsa -in "$INPUT_FILE" -out "$OUTPUT_FILE"

if [ $? -eq 0 ]; then
    echo "Private key decrypted successfully. Output file: $OUTPUT_FILE"
else
    echo "Error: Failed to decrypt the private key. This could be due to an incorrect passphrase."
    rm -f "$OUTPUT_FILE"
fi

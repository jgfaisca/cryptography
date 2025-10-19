#!/bin/bash
#
# Encrypt an RSA private key file in PEM format 
#
# Author: Jose Faisca
#

# Function to display usage information
usage() {
    echo "Usage: $0 <private_key_file>"
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
OUTPUT_FILE="enc_${INPUT_FILE}"

# Encrypt the private key file
openssl rsa -aes256 -in "$INPUT_FILE" -out "$OUTPUT_FILE"

if [ $? -eq 0 ]; then
    echo "Private key encrypted successfully. Output file: $OUTPUT_FILE"
    echo "Original file: $INPUT_FILE"

    # Ask if user wants to delete the original file
    read -p "Do you want to delete the original unencrypted file? (y/n): " DELETE
    if [[ $DELETE =~ ^[Yy]$ ]]; then
        rm "$INPUT_FILE"
        echo "Original file deleted."
    else
        echo "Original file kept."
    fi
else
    echo "Error: Failed to encrypt the private key."
    rm -f "$OUTPUT_FILE"
fi

#!/bin/bash
#
# Decrypt a file with a private key
#
# Author: Jose Faisca
#

# Function to display usage information
usage() {
    echo "Usage: $0 <input_file> <private_key_file>"
    exit 1
}

# Check if correct number of arguments is provided
if [ $# -ne 2 ]; then
    usage
fi

INPUT_FILE=$1
PRIVATE_KEY_FILE=$2
OUTPUT_FILE="${INPUT_FILE}_.dec"

# Check if input file exists
if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: Input file does not exist."
    exit 1
fi

# Check if private key file exists
if [ ! -f "$PRIVATE_KEY_FILE" ]; then
    echo "Error: Private key file does not exist."
    exit 1
fi

# Decrypt the file
openssl pkeyutl -decrypt -inkey "$PRIVATE_KEY_FILE" -in "$INPUT_FILE" -out "$OUTPUT_FILE"

if [ $? -eq 0 ]; then
    echo "File decrypted successfully. Output: $OUTPUT_FILE"
else
    echo "Error: Decryption failed."
    rm -f "$OUTPUT_FILE"
fi

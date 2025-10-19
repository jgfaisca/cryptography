#!/bin/bash
#
# Sign a file with a private key
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
OUTPUT_FILE="${INPUT_FILE}_sig.bin"

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

# Sign the file
openssl pkeyutl -sign  -inkey "$PRIVATE_KEY_FILE" -in "$INPUT_FILE" -out "$OUTPUT_FILE" 

if [ $? -eq 0 ]; then
    echo "File signed successfully. Signature output: $OUTPUT_FILE"
else
    echo "Error: Signing failed."
    rm -f "$OUTPUT_FILE"
    exit 1
fi

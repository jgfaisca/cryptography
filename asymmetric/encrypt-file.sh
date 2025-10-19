#!/bin/bash
#
# Encrypt a file with a public key
#
# Author: Jose Faisca
#

# Function to display usage information
usage() {
    echo "Usage: $0 <input_file> <public_key_file>"
    exit 1
}

# Check if correct number of arguments is provided
if [ $# -ne 2 ]; then
    usage
fi

INPUT_FILE=$1
PUBLIC_KEY_FILE=$2
OUTPUT_FILE="${INPUT_FILE}_.enc"

# Check if input file exists
if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: Input file does not exist."
    exit 1
fi

# Check if public key file exists
if [ ! -f "$PUBLIC_KEY_FILE" ]; then
    echo "Error: Public key file does not exist."
    exit 1
fi

# Encrypt the file
openssl pkeyutl -encrypt -pubin -inkey "$PUBLIC_KEY_FILE" -in "$INPUT_FILE" -out "$OUTPUT_FILE"

if [ $? -eq 0 ]; then
    echo "File encrypted successfully. Output: $OUTPUT_FILE"
else
    echo "Error: Encryption failed."
    rm -f "$OUTPUT_FILE"
fi

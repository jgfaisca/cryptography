#!/bin/bash
#
# File decryption using a key file 
#
# Author: Jose Faisca
#

# Default cipher
DEFAULT_CIPHER="aes-256-cbc"

# Function to display usage information
usage() {
    echo "Usage: $0 <input_file> <key_file> [cipher]"
    echo
    echo "File decryption using a key file."
    echo
    echo "Arguments:"
    echo "  <input_file>   The encrypted file to be decrypted"
    echo "  <key_file>     The file containing the encryption key"
    echo "  [cipher]       Optional: The cipher to use (default: $DEFAULT_CIPHER)"
    echo
    echo "Example:"
    echo "  $0 secret.enc key.bin"
    echo "  $0 secret.enc key.bin aes-128-cbc"
    echo
    echo "The decrypted file will be saved as '<input_file>_.dec'"
}

# Check if help is requested
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    usage
    exit 0
fi

# Check if the correct number of arguments is provided
if [ $# -lt 2 ] || [ $# -gt 3 ]; then
    echo "Error: Incorrect number of arguments"
    usage
    exit 1
fi

INPUT_FILE="$1"
KEY_FILE="$2"
CIPHER="${3:-$DEFAULT_CIPHER}"

# Generate output filename
OUTPUT_FILE="${INPUT_FILE}_.dec"

# Check if the input file exists
if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: Input file '$INPUT_FILE' does not exist"
    usage
    exit 1
fi

# Check if the key file exists
if [ ! -f "$KEY_FILE" ]; then
    echo "Error: Key file '$KEY_FILE' does not exist"
    usage
    exit 1
fi

# Perform the decryption
openssl "$CIPHER" -d -in "$INPUT_FILE" -out "$OUTPUT_FILE" -kfile "$KEY_FILE"

# Check if the decryption was successful
if [ $? -eq 0 ]; then
    echo "Decryption successful. Decrypted file saved as '$OUTPUT_FILE'"
    echo "Cipher used: $CIPHER"
else
    echo "Error: Decryption failed"
    exit 1
fi

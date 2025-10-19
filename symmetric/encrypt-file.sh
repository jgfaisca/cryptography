#!/bin/bash
#
# File encryption using a key file 
#
# Author: Jose Faisca
#

# Default cipher
DEFAULT_CIPHER="aes-256-cbc"

# Function to display usage message
usage() {
    echo "Usage: $0 <input_file> <key_file> [cipher]"
    echo
    echo "File encryption using a key file."
    echo
    echo "Arguments:"
    echo "  <input_file>  The file to encrypt"
    echo "  <key_file>    The file containing the encryption key"
    echo "  [cipher]      Optional: The cipher to use (default: $DEFAULT_CIPHER)"
    echo
    echo "Example:"
    echo "  $0 secret.txt key.bin"
    echo "  $0 secret.txt key.bin camellia-128-cbc"
    echo
    echo "The encrypted file will be saved as <input_file>_.enc"
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

# Assign arguments to variables
INPUT_FILE="$1"
KEY_FILE="$2"
CIPHER="${3:-$DEFAULT_CIPHER}"

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

# Perform the encryption
openssl "$CIPHER" -in "$INPUT_FILE" -out "${INPUT_FILE}_.enc" -kfile "$KEY_FILE"

# Check if the encryption was successful
if [ $? -eq 0 ]; then
    echo "Encryption successful. Encrypted file saved as '${INPUT_FILE}_.enc'"
    echo "Cipher used: $CIPHER"
else
    echo "Error: Encryption failed"
    exit 1
fi

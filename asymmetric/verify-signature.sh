#!/bin/bash
#
# Verify a file signature
#
# Author: Jose Faisca
#

# Function to display usage information
usage() {
    echo "Usage: $0 <input_file> <signature_file> <public_key_file>"
    exit 1
}

# Check if correct number of arguments is provided
if [ $# -ne 3 ]; then
    usage
fi

INPUT_FILE=$1
SIGNATURE_FILE=$2
PUBLIC_KEY_FILE=$3

# Check if input file exists
if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: Input file does not exist."
    exit 1
fi

# Check if signature file exists
if [ ! -f "$SIGNATURE_FILE" ]; then
    echo "Error: Signature file does not exist."
    exit 1
fi

# Check if public key file exists
if [ ! -f "$PUBLIC_KEY_FILE" ]; then
    echo "Error: Public key file does not exist."
    exit 1
fi

# Verify the signature
openssl pkeyutl -verify -pubin -inkey "$PUBLIC_KEY_FILE" -sigfile "$SIGNATURE_FILE" -in "$INPUT_FILE"

# Check the exit status of the openssl command
if [ $? -eq 0 ]; then
    echo "The signature is valid."
else
    echo "The signature is invalid or the file has been tampered with."
    exit 1
fi

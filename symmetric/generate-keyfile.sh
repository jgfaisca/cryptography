#!/bin/bash
#
# Generate an encryption key file in base64 format 
#
# Author: Jose Faisca
#

# Default key size in bits
DEFAULT_KEY_SIZE=256

# Function to display usage information
usage() {
    echo "Usage: $0 [key_size]"
    echo
    echo "Generate an encryption key file in base64 format."
    echo
    echo "Arguments:"
    echo "  key_size Optional: Size of the key in bits (default: $DEFAULT_KEY_SIZE)"
    echo
    echo "Example:"
    echo "  $0"
    echo "  $0 512"
}

# Check if help is requested
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    usage
    exit 0
fi

# Validate argument if provided
if [[ $# -gt 1 ]]; then
    echo "Error: Too many arguments"
    usage
    exit 1
elif [[ $# -eq 1 ]]; then
    if ! [[ "$1" =~ ^[0-9]+$ ]]; then
        echo "Error: Key size must be a positive integer"
        usage
        exit 1
    fi
    KEY_SIZE=$1
else
    KEY_SIZE=$DEFAULT_KEY_SIZE
fi

# Generate the key file name
OUTPUT_FILE=$(mktemp -p ./ --suffix=.b64 XXXXXXXX)

# Convert bits to bytes
KEY_SIZE_BYTES=$(((KEY_SIZE + 7) / 8))

# Generate the base64 key file
openssl rand -base64 -out "$OUTPUT_FILE" "$KEY_SIZE_BYTES"

# Check if the key file generation was successful
if [ $? -eq 0 ]; then
    echo "Base64 Key with $KEY_SIZE bits generated successfully." 
    echo "Saved as '$OUTPUT_FILE'"
else
    echo "Error: Failed to generate key"
    rm -f "$OUTPUT_FILE"
    exit 1
fi

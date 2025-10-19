#!/bin/bash
#
# Generate RSA private and public key files in PEM format 
#
# Author: Jose Faisca
#

# Default key size
DEFAULT_KEY_SIZE=2048

# Function to display usage information
usage() {
    echo "Usage: $0 [key_size]"
    echo "Generates RSA private and public key files in PEM format."
    echo "  key_size: Optional. Size of the private key in bits. Default is $DEFAULT_KEY_SIZE."
    echo
    echo "Example:"
    echo "  $0"
    echo "  $0 4096"
    
    exit 1
}

# Function to generate a random string 
generate_random_str() {
    str_size="$1"
    template=$(printf 'X%.0s' $(seq 1 "$str_size"))
    mktemp -u "$template"
}

# Check if help is requested
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    usage
fi

# Set key size with default value
KEY_SIZE="${1:-$DEFAULT_KEY_SIZE}"

# Validate key size
if ! [[ "$KEY_SIZE" =~ ^[0-9]+$ ]]; then
    echo "Error: Key size must be a positive integer."
    usage
fi

# Generate the base OUTPUT file name
BASE_OUTPUT_FILE=$(generate_random_str 8)

# Create the private key file name
PRIVATE_KEY_FILE="private_key_${BASE_OUTPUT_FILE}.pem"

# Check if the private key file already exists
if [ -f "$PRIVATE_KEY_FILE" ]; then
    echo "Private key file $PRIVATE_KEY_FILE already exists. Exit key generation."
    exit 1
fi

# Generate the private key file
openssl genrsa -out $PRIVATE_KEY_FILE $KEY_SIZE

# Check if the private key file generation was successful
if [ $? -eq 0 ]; then
    echo "RSA private key successfully generated: $PRIVATE_KEY_FILE"
    echo "Key size: $KEY_SIZE bits"
else
    echo "Error: Failed to generate RSA private key."
    rm -f $PRIVATE_KEY_FILE
    exit 1
fi

# Create the public key file name
PUBLIC_KEY_FILE="public_key_${BASE_OUTPUT_FILE}.pem"

# Gnerate the public key file
openssl rsa -pubout -in $PRIVATE_KEY_FILE -out $PUBLIC_KEY_FILE

# Check if the public key file generation was successful
if [ $? -eq 0 ]; then
    echo "RSA public key successfully generated: $PUBLIC_KEY_FILE"
else
    echo "Error: Failed to generate RSA public key."
    rm -f $PUBLIC_KEY_FILE
    exit 1
fi

#!/bin/bash
#
# Generate Eliptic Curve (EC) private and public key files in PEM format
#
# List curves:
# $ openssl ecparam -list_curves
#
# Author: Jose Faisca
#

# Default curve name
DEFAULT_CURVE_NAME="secp256k1"

# Function to display usage information
usage() {
    echo "Usage: $0 [curve_name]"
    echo "Generates EC private and public key files in PEM format."
    echo "  curve_name: optional curve name. Default is $DEFAULT_CURVE_NAME."
    echo ""
    echo "Example:"
    echo "  $0"
    echo "  $0 secp521r1"

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
CURVE_NAME="${1:-$DEFAULT_CURVE_NAME}"

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
openssl ecparam -name "$CURVE_NAME" -genkey -noout -out "$PRIVATE_KEY_FILE"

# Check if the private key file generation was successful
if [ $? -eq 0 ]; then
    echo "EC private key successfully generated: $PRIVATE_KEY_FILE"
    echo "Curve name: $CURVE_NAME"
else
    echo "Error: Failed to generate EC private key."
    rm -f "$PRIVATE_KEY_FILE"
    exit 1
fi

# Create the public key file name
PUBLIC_KEY_FILE="public_key_${BASE_OUTPUT_FILE}.pem"

# Gnerate the public key file
openssl ec -pubout -in "$PRIVATE_KEY_FILE" -out "$PUBLIC_KEY_FILE"

# Check if the public key file generation was successful
if [ $? -eq 0 ]; then
    echo "EC public key successfully generated: $PUBLIC_KEY_FILE"
else
    echo "Error: Failed to generate EC public key."
    rm -f "$PUBLIC_KEY_FILE"
    exit 1
fi

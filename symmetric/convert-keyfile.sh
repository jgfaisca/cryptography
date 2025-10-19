#!/bin/bash
#
# Convert an encryption key file in base64 format to binary 
#
# Author: Jose Faisca
#

# Function to display usage information
usage() {
    echo "Usage: $0 <input_file>"
    echo
    echo "Convert an encryption key file in base64 format to binary."
    echo
    echo "Arguments:"
    echo "  <input_file> The base64-encoded key file to convert"
    echo
    echo "Output:"
    echo "  The binary key will be saved as '<input_file>_.bin'"
    echo
    echo "Example:"
    echo "  $0 my_key.b64"
}

# Check if help is requested
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    usage
    exit 0
fi

# Validate arguments
if [ $# -ne 1 ]; then
    echo "Error: Incorrect number of arguments"
    usage
    exit 1
fi

INPUT_FILE="$1"
OUTPUT_FILE="${INPUT_FILE}_.bin"

# Check if the input file exists
if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: Input file '$INPUT_FILE' does not exist"
    usage
    exit 1
fi

# Convert base64 to binary
openssl base64 -d -in "$INPUT_FILE" -out "$OUTPUT_FILE"

# Check if the conversion was successful
if [ $? -eq 0 ]; then
    echo "Conversion successful. Binary key saved as '$OUTPUT_FILE'"
else
    echo "Error: Failed to convert the key"
    rm -f "$OUTPUT_FILE"
    exit 1
fi

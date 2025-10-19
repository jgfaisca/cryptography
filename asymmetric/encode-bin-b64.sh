#!/bin/bash
#
# Encode binary file to Base64 format
#
# Author: Jose Faisca
#

# Function to display usage information
usage() {
    echo "Usage: $0 <input_binary_file>"
    exit 1
}

# Check if correct number of arguments is provided
if [ $# -ne 1 ]; then
    usage
fi

INPUT_FILE=$1
OUTPUT_FILE="${INPUT_FILE}_.b64"

# Check if input file exists
if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: Input file does not exist."
    exit 1
fi

# Encode the binary file in Base64 format
openssl base64 -in "$INPUT_FILE" -out "$OUTPUT_FILE"

if [ $? -eq 0 ]; then
    echo "Binary file encoded successfully in Base64 format. Output: $OUTPUT_FILE"
else
    echo "Error: Base64 file encoding failed."
    rm -f "$OUTPUT_FILE"
    exit 1
fi

# Display file information
echo "File information:"
file "$OUTPUT_FILE"

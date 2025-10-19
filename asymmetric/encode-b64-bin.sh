#!/bin/bash
#
# Encode Base64 file to binary format
#
# Author: Jose Faisca
#

# Function to display usage information
usage() {
    echo "Usage: $0 <input_base64_file>"
    exit 1
}

# Check if correct number of arguments is provided
if [ $# -ne 1 ]; then
    usage
fi

INPUT_FILE=$1
OUTPUT_FILE="${INPUT_FILE}_.bin"

# Check if input file exists
if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: Input file does not exist."
    exit 1
fi

# Encode base64 file to binary
openssl base64 -d -in "$INPUT_FILE" -out "$OUTPUT_FILE"

# Check if conversion was successful
if [ $? -eq 0 ]; then
    echo "Base64 file encoded successfully in binary format. Output: $OUTPUT_FILE"
else
    echo "Error: Binary file encoding failed."
    rm -f "$OUTPUT_FILE"
    exit 1
fi

# Display file information
echo "File information:"
file "$OUTPUT_FILE"

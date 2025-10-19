#!/bin/bash
#
# Generate an encryption no-random key file in base64 format
# using master seed from text file. 
#
# Author: Jose Faisca
#

DEFAULT_KEY_SIZE=256
MASTER_SEED_FILE="master_seed.txt"

usage() {
    echo "Usage: $0 [key_size]"
    echo
    echo "Generate an encryption (no-random) key file in base64 format"
    echo "using master seed from file '${MASTER_SEED_FILE}'."
    echo
    echo "Arguments:"
    echo "  key_size Optional: Size of the key in bits (default: ${DEFAULT_KEY_SIZE})"
    echo
    echo "Example:"
    echo "  $0"
    echo "  $0 512"
}

read_master_seed() {
    if [[ ! -f "$MASTER_SEED_FILE" ]]; then
        echo "Error: Master seed file '${MASTER_SEED_FILE}' not found."
        exit 1
    fi
    local seed
    seed=$(<"$MASTER_SEED_FILE")
    echo -n "$seed"
}

generate_no_random_bytes() {
    local length_bytes=$1
    local master_seed=$2
    local output=""
    local counter=0
    local needed_hex_length=$((length_bytes * 2))

    while [ "${#output}" -lt "$needed_hex_length" ]; do
        local data="${master_seed}${counter}"
        local hash_bin
        hash_bin=$(echo -n "$data" | openssl dgst -sha256 -binary)
        local hash_hex
        hash_hex=$(echo -n "$hash_bin" | od -An -tx1 | tr -d ' \n')
        output="${output}${hash_hex}"
        ((counter++))
    done

    echo "${output:0:$needed_hex_length}"
}

if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    usage
    exit 0
fi

if [[ $# -gt 1 ]]; then
    echo "Error: Too many arguments"
    usage
    exit 1
fi

key_size=$DEFAULT_KEY_SIZE
if [[ $# -eq 1 ]]; then
    if ! [[ "$1" =~ ^[0-9]+$ ]] || [[ "$1" -le 0 ]]; then
        echo "Error: Key size must be a positive integer"
        usage
        exit 1
    fi
    key_size=$1
fi

key_size_bytes=$(((key_size + 7) / 8))
master_seed=$(read_master_seed)
temp_file=$(mktemp -p ./ norand_XXXXXXXX.b64)
hex_key=$(generate_no_random_bytes "$key_size_bytes" "$master_seed")
binary_data=$(echo "$hex_key" | perl -pe 's/([0-9a-f]{2})/chr(hex($1))/eg')
echo -n "$binary_data" | openssl base64 -A > "$temp_file"

echo "Base64 Key (no-random) with $key_size bits generated successfully."
echo "Saved as '${temp_file}'"

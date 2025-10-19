#
# File encryption using a key file 
#
# Dependencies: 
# $ pip install cryptography
#
# Author: Jose Faisca
#

import sys
import os
from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes
from cryptography.hazmat.primitives import padding
from cryptography.hazmat.backends import default_backend

DEFAULT_CIPHER = "aes-256-cbc"

# Cipher configuration for cryptography lib
CIPHERS = {
    'aes-128-cbc': {'algorithm': algorithms.AES, 'key_len': 16, 'block_size': 16},
    'aes-192-cbc': {'algorithm': algorithms.AES, 'key_len': 24, 'block_size': 16},
    'aes-256-cbc': {'algorithm': algorithms.AES, 'key_len': 32, 'block_size': 16},
    'camellia-128-cbc': {'algorithm': algorithms.Camellia, 'key_len': 16, 'block_size': 16},
    'camellia-192-cbc': {'algorithm': algorithms.Camellia, 'key_len': 24, 'block_size': 16},
    'camellia-256-cbc': {'algorithm': algorithms.Camellia, 'key_len': 32, 'block_size': 16},
}

def usage():
    print(f"Usage: {sys.argv[0]} <input_file> <key_file> [cipher]")
    print("\nFile encryption using a key file with selectable cipher.\n")
    print("Arguments:")
    print("  <input_file>  The file to encrypt")
    print("  <key_file>    The file containing the encryption key")
    print(f"  [cipher]      Optional cipher (default: {DEFAULT_CIPHER})\n")
    print("Supported ciphers:")
    print(", ".join(CIPHERS.keys()))
    print("\nExample:")
    print(f" python {sys.argv[0]} secret.txt key.bin")
    print(f" python {sys.argv[0]} secret.txt key.bin camellia-128-cbc\n")
    print("Encrypted file is saved as <input_file>_.enc")

def encrypt_file(input_file, key_file, cipher_name):
    if cipher_name not in CIPHERS:
        print(f"Error: Unsupported cipher '{cipher_name}'")
        usage()
        sys.exit(1)

    if not os.path.isfile(input_file):
        print(f"Error: Input file '{input_file}' does not exist")
        usage()
        sys.exit(1)
    if not os.path.isfile(key_file):
        print(f"Error: Key file '{key_file}' does not exist")
        usage()
        sys.exit(1)

    cipher_props = CIPHERS[cipher_name]
    algorithm_class = cipher_props['algorithm']
    key_len = cipher_props['key_len']
    block_size = cipher_props['block_size']

    with open(key_file, "rb") as f:
        key = f.read()

    if len(key) != key_len:
        print(f"Error: Key length in '{key_file}' is {len(key)} bytes but expected {key_len} bytes for {cipher_name}")
        sys.exit(1)

    iv = os.urandom(block_size)

    with open(input_file, "rb") as f:
        plaintext = f.read()

    padder = padding.PKCS7(block_size * 8).padder()
    padded_plaintext = padder.update(plaintext) + padder.finalize()

    cipher = Cipher(algorithm_class(key), modes.CBC(iv), backend=default_backend())
    encryptor = cipher.encryptor()
    ciphertext = encryptor.update(padded_plaintext) + encryptor.finalize()

    encrypted_output = iv + ciphertext

    output_file = f"{input_file}_.enc"
    with open(output_file, "wb") as f:
        f.write(encrypted_output)

    print(f"Encryption successful. File saved as '{output_file}'")
    print(f"Cipher used: {cipher_name}")

def main():
    args = sys.argv[1:]
    if len(args) == 1 and args[0] in ("--help", "-h"):
        usage()
        sys.exit(0)
    if len(args) < 2 or len(args) > 3:
        print("Error: Incorrect number of arguments")
        usage()
        sys.exit(1)

    input_file = args[0]
    key_file = args[1]
    cipher_name = args[2].lower() if len(args) == 3 else DEFAULT_CIPHER

    encrypt_file(input_file, key_file, cipher_name)

if __name__ == "__main__":
    main()

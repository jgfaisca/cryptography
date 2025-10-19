#
# File decryption using a key file 
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

CIPHERS = {
    'aes-128-cbc': {'algorithm': algorithms.AES, 'key_len': 16, 'block_size': 16},
    'aes-192-cbc': {'algorithm': algorithms.AES, 'key_len': 24, 'block_size': 16},
    'aes-256-cbc': {'algorithm': algorithms.AES, 'key_len': 32, 'block_size': 16},
    'camellia-128-cbc': {'algorithm': algorithms.Camellia, 'key_len': 16, 'block_size': 16},
    'camellia-192-cbc': {'algorithm': algorithms.Camellia, 'key_len': 24, 'block_size': 16},
    'camellia-256-cbc': {'algorithm': algorithms.Camellia, 'key_len': 32, 'block_size': 16},
}

def usage():
    print(f"Usage: {sys.argv[0]} <input_file> <key_file> [cipher]\n")
    print("File decryption using a key file.\n")
    print("Arguments:")
    print("  <input_file>   The encrypted file to be decrypted")
    print("  <key_file>     The file containing the encryption key")
    print(f"  [cipher]       Optional: The cipher to use (default: {DEFAULT_CIPHER})\n")
    print("Example:")
    print(f" python {sys.argv[0]} secret.enc key.bin")
    print(f" python {sys.argv[0]} secret.enc key.bin camellia-128-cbc\n")
    print("The decrypted file will be saved as '<input_file>_.dec'")

def decrypt_file(input_file, key_file, cipher_name):
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

    with open(input_file, "rb") as f:
        data = f.read()

    # Extract IV from the beginning
    iv = data[:block_size]
    ciphertext = data[block_size:]

    cipher = Cipher(algorithm_class(key), modes.CBC(iv), backend=default_backend())
    decryptor = cipher.decryptor()
    padded_plaintext = decryptor.update(ciphertext) + decryptor.finalize()

    unpadder = padding.PKCS7(block_size * 8).unpadder()
    try:
        plaintext = unpadder.update(padded_plaintext) + unpadder.finalize()
    except ValueError:
        print("Error: Incorrect padding. Possibly wrong key or corrupted ciphertext.")
        sys.exit(1)

    output_file = f"{input_file}_.dec"
    with open(output_file, "wb") as f:
        f.write(plaintext)

    print(f"Decryption successful. Decrypted file saved as '{output_file}'")
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

    decrypt_file(input_file, key_file, cipher_name)

if __name__ == "__main__":
    main()

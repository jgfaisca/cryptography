#
# Generate an encryption no-random key file in base64 format
# using master seed from text file. 
#
# Author: Jose Faisca
#

import sys
import hashlib
import base64
import tempfile
import os

# default key size in bits
DEFAULT_KEY_SIZE = 256

# master seed file path
MASTER_SEED_FILE = 'master_seed.txt'

def usage():
    print(f"Usage: {sys.argv[0]} [key_size]\n")
    print("Generate an encryption (no-random) key file in base64 format")
    print(f"using master seed from file '{MASTER_SEED_FILE}'.\n")
    print("Arguments:")
    print(f"  key_size Optional: Size of the key in bits (default: {DEFAULT_KEY_SIZE})\n")
    print("Example:")
    print(f"  python {sys.argv[0]}")
    print(f"  python {sys.argv[0]} 512")

def read_master_seed(file_path):
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            return f.read().strip()
    except FileNotFoundError:
        print(f"Error: Master seed file '{file_path}' not found.")
        sys.exit(1)
    except Exception as e:
        print(f"Error reading master seed file: {e}")
        sys.exit(1)

def generate_no_random_bytes(length, master_seed):
    output = b""
    counter = 0
    needed_bytes = length

    while len(output) < needed_bytes:
        data = f"{master_seed}{counter}".encode('utf-8')
        hash_bin = hashlib.sha256(data).digest()
        output += hash_bin
        counter += 1

    return output[:needed_bytes]

def generate_key(length, out_file, master_seed):
    key_bytes = generate_no_random_bytes(length, master_seed)
    b64_key = base64.b64encode(key_bytes).decode('utf-8')
    with open(out_file, "w") as f:
        f.write(b64_key)

if __name__ == "__main__":
    args = sys.argv[1:]

    master_seed = read_master_seed(MASTER_SEED_FILE)

    if len(args) == 1 and args[0] in ("--help", "-h"):
        usage()
        sys.exit(0)

    if len(args) > 1:
        print("Error: Too many arguments\n")
        usage()
        sys.exit(1)

    if len(args) == 1:
        if not args[0].isdigit() or int(args[0]) <= 0:
            print("Error: Key size must be a positive integer\n")
            usage()
            sys.exit(1)
        key_size = int(args[0])
    else:
        key_size = DEFAULT_KEY_SIZE

    key_size_bytes = (key_size + 7) // 8

    fd, temp_path = tempfile.mkstemp(suffix=".b64", dir=".")
    os.close(fd)
    basename = os.path.basename(temp_path)
    new_basename = "norand_" + basename
    new_path = os.path.join(".", new_basename)
    os.rename(temp_path, new_path)

    generate_key(key_size_bytes, new_path, master_seed)

    print(f"Base64 Key (no-random) with {key_size} bits generated successfully.")
    print(f"Saved as '{new_path}'")


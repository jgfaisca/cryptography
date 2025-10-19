#
# Generate an encryption key file in base64 format 
#
# Author: Jose Faisca
#

import sys
import os
import base64
import secrets
import tempfile

# default key size in bits
DEFAULT_KEY_SIZE = 256  

def usage():
    print(f"Usage: {sys.argv[0]} [key_size]\n")
    print("Generate an encryption key file in base64 format.\n")
    print("Arguments:")
    print("  key_size Optional: Size of the key in bits (default: 256)\n")
    print("Example:")
    print(f" python {sys.argv[0]}")
    print(f" python {sys.argv[0]} 512")

def main():
    args = sys.argv[1:]

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

    try:
        fd, output_file = tempfile.mkstemp(suffix=".b64", dir=".")
        os.close(fd)
        
        # Convert bits to bytes
        key_size_bytes = (key_size + 7) // 8

        # Generate secure random bytes and encode as base64 string
        key_bytes = secrets.token_bytes(key_size_bytes)
        b64_key = base64.b64encode(key_bytes)

        # Write base64-encoded key to file
        with open(output_file, "wb") as f:
            f.write(b64_key)

        print(f"Base64 Key with {key_size} bits generated successfully.")
        print(f"Saved as '{output_file}'")

    except Exception as e:
        print(f"Error: Failed to generate key: {e}")
        if os.path.exists(output_file):
            os.remove(output_file)
        sys.exit(1)

if __name__ == "__main__":
    main()

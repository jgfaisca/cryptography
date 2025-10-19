#
# Convert an encryption key file in base64 format to binary 
#
# Author: Jose Faisca
#

import sys
import base64
import os

def usage():
    print(f"Usage: {sys.argv[0]} <input_file>\n")
    print("Convert an encryption key file in base64 format to binary.\n")
    print("Arguments:")
    print("  <input_file> The base64-encoded key file to convert\n")
    print("Output:")
    print("  The binary key will be saved as '<input_file>_.bin'\n")
    print("Example:")
    print(f" python {sys.argv[0]} my_key.b64")

def main():
    if len(sys.argv) != 2:
        print("Error: Incorrect number of arguments\n")
        usage()
        sys.exit(1)

    if sys.argv[1] in ("--help", "-h"):
        usage()
        sys.exit(0)

    input_file = sys.argv[1]
    output_file = f"{input_file}_.bin"

    if not os.path.isfile(input_file):
        print(f"Error: Input file '{input_file}' does not exist\n")
        usage()
        sys.exit(1)

    try:
        with open(input_file, "rb") as f_in:
            b64_data = f_in.read()
        binary_data = base64.b64decode(b64_data)
        with open(output_file, "wb") as f_out:
            f_out.write(binary_data)
        print(f"Conversion successful. Binary key saved as '{output_file}'")
    except Exception as e:
        print(f"Error: Failed to convert the key: {e}")
        if os.path.exists(output_file):
            os.remove(output_file)
        sys.exit(1)

if __name__ == "__main__":
    main()

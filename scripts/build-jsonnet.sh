#!/bin/bash

# This script is used to compile a Jsonnet configuration file into a JSON file
# for use with Karabiner-Elements. It assumes that Jsonnet and jsonnetfmt are installed on
# your system and that the script is run from the repository's root directory.

# Exit on any error
set -e

# Output file path where the compiled JSON will be saved
OUTPUT_FILE="config/windows-keyboard.json"

# Jsonnet source file (specific file to compile)
JSONNET_FILE="jsonnet/windows-mac-remap.jsonnet" # Replace with your Jsonnet file

# Check if Jsonnet is installed
if ! command -v jsonnet &>/dev/null; then
    echo "Error: Jsonnet is not installed. Please install Jsonnet and try again."
    exit 1
fi

# Check if jsonnetfmt is installed
if ! command -v jsonnetfmt &>/dev/null; then
    echo "Warning: jsonnetfmt is not installed. You can format your Jsonnet files later manually."
else
    echo "jsonnetfmt is installed. Formatting Jsonnet file..."
    # Format the Jsonnet file (optional step)
    jsonnetfmt -i "$JSONNET_FILE"
fi

# Check if the Jsonnet source file exists
if [ ! -f "$JSONNET_FILE" ]; then
    echo "Error: The Jsonnet source file '$JSONNET_FILE' does not exist."
    exit 1
fi

# Create the output directory if it doesn't already exist
mkdir -p "$(dirname "$OUTPUT_FILE")"

# Print the starting message
echo "Starting Jsonnet compilation..."

# Print which Jsonnet file is being compiled and to which JSON file it will be saved
echo "Compiling $JSONNET_FILE to $OUTPUT_FILE..."

# Compile the Jsonnet file into JSON and save it to the specified output path
jsonnet "$JSONNET_FILE" >"$OUTPUT_FILE"

# Print success message
echo "Successfully compiled $JSONNET_FILE to $OUTPUT_FILE"

# Print the final message indicating completion
echo "Jsonnet compilation complete! The JSON file is saved as '$OUTPUT_FILE'."

#!/bin/bash

# This script is used to compile a Jsonnet configuration file into a JSON file
# for use with Karabiner-Elements. It assumes that Jsonnet, jsonnet-lint, jsonnetfmt, and jsonnet-deps
# are installed on your system and that the script is run from the repository's root directory.

# Exit on any error
set -e

# Default output file path where the compiled JSON will be saved
OUTPUT_FILE="config/windows-keyboard.json"

# Default Jsonnet source file (specific file to compile)
JSONNET_FILE="jsonnet/windows-mac-remap.jsonnet"

# Check if Jsonnet is installed
if [ ! -x "$(command -v jsonnet)" ]; then
    echo "Error: Jsonnet is not installed. Please install Jsonnet and try again."
    exit 1
else
    jsonnet_version=$(jsonnet --version)
    echo "Jsonnet version: $jsonnet_version"
fi

# Check if jsonnet-lint is installed
if [ ! -x "$(command -v jsonnet-lint)" ]; then
    echo "Warning: jsonnet-lint is not installed."
    exit 1
else
    jsonnet_lint_version=$(jsonnet-lint --version)
    echo "jsonnet-lint version: $jsonnet_lint_version"
    # Lint the Jsonnet file
    jsonnet-lint "$JSONNET_FILE"
fi

# Check if jsonnetfmt is installed
if [ ! -x "$(command -v jsonnetfmt)" ]; then
    echo "Error: jsonnetfmt is not installed. Please install it and try again."
    exit 1
else
    jsonnetfmt_version=$(jsonnetfmt --version)
    echo "jsonnetfmt version: $jsonnetfmt_version"
    # Format the Jsonnet file in place
    jsonnetfmt -i "$JSONNET_FILE"
fi

# Check if jsonnet-deps is installed
if [ ! -x "$(command -v jsonnet-deps)" ]; then
    echo "Error: jsonnet-deps is not installed. Please install it and try again."
    exit 1
else
    jsonnet_deps_version=$(jsonnet-deps --version)
    echo "jsonnet-deps version: $jsonnet_deps_version"
    # Analyze dependencies in the Jsonnet file
    jsonnet-deps "$JSONNET_FILE"
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

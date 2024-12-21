# Scripts Directory

This directory contains essential scripts for managing and processing Jsonnet files in this project. The main script in this directory is `build-jsonnet.sh`, which automates the process of building, validating, and generating output from Jsonnet files.

## Overview

The scripts in this folder help streamline the process of managing Jsonnet configurations, validating code, and building outputs for further use or deployment. They use `jsonnet` and `jsonnet-lint` tools for code generation and linting.

## Scripts

### 1. `build-jsonnet.sh`

This shell script automates the process of compiling Jsonnet files and generating the output in the desired format.

#### Features

- **Jsonnet Compilation**: Compiles Jsonnet files into JSON or other desired formats.
- **Linting**: Uses `jsonnet-lint` to ensure the Jsonnet files are formatted and error-free before proceeding with the build.
- **Customizable Output**: Supports customizable output locations and formats, making it easy to integrate into a larger build system or deployment pipeline.

#### Script Workflow

- **Step 1**: It first lints the Jsonnet files to ensure there are no errors or formatting issues.
- **Step 2**: Then, it proceeds to compile the Jsonnet files into the final output format (e.g., JSON).
- **Step 3**: The resulting output is saved to a specific directory or file based on the script configuration.

### Requirements

Before using the script, ensure that you have the following installed and properly configured:

- **Go**: A Go environment is needed to install the required dependencies (`jsonnet` and `jsonnet-lint`).
- **jsonnet**: A tool that compiles Jsonnet files into JSON or other formats.
- **jsonnet-lint**: A tool to check Jsonnet files for syntax errors, warnings, and formatting issues.

### Installing Dependencies

Install `jsonnet` and `jsonnet-lint` through Go:

1. Install Go (version 1.18 or later is recommended). If you don't have Go installed, you can follow the installation instructions on the official website: [Go Installation Guide](https://golang.org/doc/install).

2. Install `jsonnet` and `jsonnet-lint` via Go:

   ```bash
   go install github.com/google/go-jsonnet/cmd/jsonnet@latest
   go install github.com/google/go-jsonnet/cmd/jsonnet-lint@latest
   ```

3. Make sure that Go is properly configured and that the `$GOPATH/bin` directory is added to your `PATH` environment variable. You can do this by adding the following line to your shell configuration file (e.g., `.bashrc`, `.zshrc`):

   ```bash
   export PATH=$PATH:$(go env GOPATH)/bin
   ```

4. Verify the installation by checking the versions of `jsonnet` and `jsonnet-lint`:

   ```bash
   jsonnet --version
   jsonnet-lint --version
   ```

### Running the Script

Once you've installed the necessary dependencies, you can run the `build-jsonnet.sh` script.

**Example**: To execute the script, use the following command:

```bash
./scripts/build-jsonnet.sh
```

By default, this will:

- Lint all Jsonnet files in the project.
- Generate the compiled output in the configured location (you can customize this in the script if needed).

### Troubleshooting

If you encounter any issues, check the following:

- **Permission Issues**: If you get a permission denied error while running the script, ensure it has execute permissions:
  ```bash
  chmod +x ./scripts/build-jsonnet.sh
  ```
- **Go Path Configuration**: If `jsonnet` or `jsonnet-lint` are not found, ensure that the `$GOPATH/bin` is correctly added to your `PATH`.
- **Dependencies**: If the dependencies (`jsonnet`, `jsonnet-lint`) are not installed correctly, try reinstalling them using the `go install` commands above.

#### Common Error Messages

- **Error: Command not found**: This typically means that `jsonnet` or `jsonnet-lint` are not correctly installed or are not in the `PATH`. Ensure the installation steps are followed correctly.
- **Error in Jsonnet file**: If the script outputs errors related to the Jsonnet files themselves, check for syntax or formatting issues. You can run `jsonnet-lint` manually to find and fix the issues.

### Examples

#### Example 1: Basic Script Run

Run the script with default settings:

```bash
./scripts/build-jsonnet.sh
```

This will lint all Jsonnet files in the project and generate the output as configured in the script.

## Contributing

If you'd like to contribute to improving or extending the functionality of the scripts, feel free to fork the repository and submit pull requests. Ensure that your code is well-tested and follows the project's coding standards.

## License

This project is licensed under the MIT License. See the [LICENSE](../LICENSE) file for more details.

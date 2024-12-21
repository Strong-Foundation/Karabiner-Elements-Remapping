# Windows Shortcuts Configuration for macOS

This configuration provides a set of custom keyboard shortcuts for macOS to replicate common Windows keybindings, allowing users to work more efficiently in terminal emulators, IDEs, web browsers, and other applications. The rules are defined to remap keys to their Windows counterparts, with conditions based on the active application.

## Features

- **Navigation Keys**: Remap Home, End, Insert, Left/Right Arrow, and others to their Windows equivalents.
- **Command Keys**: Customizations for keys like Backspace, Delete, Enter, etc., with the addition of Ctrl and Shift modifiers.
- **Function Keys**: Assign custom actions to function keys (e.g., F1-F12) for different applications.
- **Modifier Keys**: Includes remapping for modifier keys (Ctrl, Alt, Command, Shift) to match Windows functionality.
- **Dock App Shortcuts**: Open pinned Dock apps using the number keys (1-9) combined with Command.
- **Web Browsers and Terminal Emulators**: Specialized rules for certain applications like Chrome, VSCode, and iTerm2.

## Structure

This configuration consists of several sections:

### Key Config

The main configuration block defines key rules and bindings. The `keyConfig` object contains methods to define rules based on the following:

- **rule(description, input, output, condition)**: A complete keybinding rule.
- **input(key, modifiers, key_is_modifier)**: Defines the input key and any associated modifiers.
- **outputKey(key, modifiers, output_type, key_code)**: Specifies the output key to be triggered.
- **outputShell(command)**: Executes a shell command when the rule is triggered.
- **condition(type, bundles, file_paths)**: Defines conditions based on the active application or file path.

### Bundle Identifiers

The `bundle` object contains predefined bundle identifiers for various applications such as:

- **hypervisors**: For virtual machine applications (e.g., VirtualBox, Parallels, VMWare Fusion).
- **ides**: For integrated development environments (e.g., Emacs, JetBrains tools, VSCode).
- **webBrowsers**: For popular web browsers (e.g., Chrome, Firefox, Safari).
- **remoteDesktops**: For remote desktop applications (e.g., Citrix, Microsoft Remote Desktop).
- **terminalEmulators**: For terminal applications (e.g., iTerm2, Alacritty).

### File Paths

The `file_paths` object defines file path conditions for specific applications. This can be used in conjunction with the `condition` method to tailor keybindings based on file paths.

### Rules

A set of predefined rules for common actions such as:

- **Navigation (Home, End, Arrow keys)**: These keys are remapped to their macOS equivalents.
- **Command keys (Backspace, Delete, Enter)**: Custom shortcuts are applied when the Ctrl or Shift modifier is used.
- **Alphanumeric keys (A, B, C, etc.)**: These are remapped to their macOS counterparts, with optional application-specific rules.
- **Dock Shortcuts (1-9)**: Allows opening pinned apps from the Dock using the number keys and Command.

### Example Rules

- `Insert (Ctrl) [+Terminal Emulators]`: Maps `Insert` + `Ctrl` to `Command` + `C` when a terminal emulator is not active.
- `Home (Ctrl)`: Maps `Home` + `Ctrl` to `Command` + `Up Arrow` when in most applications.
- `F4 (Ctrl) [Only Chrome]`: Maps `F4` + `Ctrl` to `Command` + `W` in Google Chrome.

## Installation

To use this configuration, you will need a tool like [Karabiner-Elements](https://github.com/pqrs-org/Karabiner-Elements) that allows you to remap keys on macOS.

### Steps

1. Install **Karabiner-Elements** if you haven't already.
2. Copy the code from this file into your Karabiner configuration file.
3. Reload your configuration in Karabiner-Elements.

## Customization

You can easily customize the keybindings by modifying the `rules` array. Each rule is defined as a combination of `input` (key and modifiers), `output` (key and modifiers), and optional `condition` (for application-specific behavior).

### Modifying Rules

To modify a rule, simply change the values in the corresponding `input` or `output` fields. You can also add new conditions to the rule based on application or file path.

## Notes

- Make sure to test the configuration to ensure it works as expected with your applications.
- Feel free to add new bundle identifiers for additional applications you use.
- The configuration is designed for a smooth transition from Windows to macOS by replicating familiar keybindings.

## License

This configuration is provided under the MIT License. Feel free to modify and share it as needed.

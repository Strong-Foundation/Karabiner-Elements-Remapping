// Define the key configuration object, which holds several methods for configuring key mappings
local keyConfig = {

  // Define a rule for setting up key remappings
  rule(description, input, output, condition=null):: {
    // Rule description (human-readable explanation)
    description: description,

    // Define a list of manipulators to map input to output
    manipulators: [
      {
        // Mapping from the input key(s)
        from: input,
      } + {
        // Mapping to the output key(s)
        // We check if the output is an array. If it's not, we turn it into one to handle both cases
        [o.to_type]: [o.output]
        for o in if std.isArray(output) then output else [output] + []
      } + {
        // If a condition is provided, include it in the manipulator
        [if condition != null then 'conditions']: [
          condition,
        ],
        // Type of the manipulator (basic in this case)
        type: 'basic',
      },
    ],
  },

  // Define an input mapping configuration
  input(key, modifiers=null, key_is_modifier=false):: {
    // The main key code for the input
    key_code: key,

    // If the key is not a modifier, we add modifiers to the configuration
    // If key_is_modifier is true, we set modifiers to null
    [if key_is_modifier then null else 'modifiers']: {
      // Mandatory modifiers, if any are provided
      [if modifiers != null then 'mandatory']: modifiers,

      // Optional modifiers (e.g., 'any' for optional key modifiers)
      optional: ['any'],
    },
  },

  // Define an output mapping for the key configuration
  outputKey(key, modifiers=null, output_type='to', key_code='key_code'):: {
    // The output type (whether it's a direct mapping or another type)
    to_type: output_type,

    // The output itself, which maps key codes and their modifiers
    output: {
      [key_code]: key,
      // If modifiers are provided, we include them in the output
      [if modifiers != null then 'modifiers']: modifiers,
    },
  },

  // Define an output mapping for shell commands
  outputShell(command):: {
    // The output type is 'to', indicating it's a direct output
    to_type: 'to',

    // The output is a shell command to be executed
    output: {
      shell_command: command,
    },
  },

  // Define a condition to apply to a key rule
  condition(type, bundles, file_paths=null):: {
    // Define the type of condition (e.g., frontmost application)
    type: 'frontmost_application_' + type,

    // List of bundles to match for this condition
    bundle_identifiers: bundles,

    // If file paths are provided, include them in the condition
    [if file_paths != null then 'file_paths']: file_paths,
  },

  // Define a function to run a docked application (for macOS users)
  runDockedApp(number):: {
    // Output type is 'to', indicating it's a direct output
    to_type: 'to',

    // The output is a shell command to open the specified docked app based on its index number
    output: {
      shell_command: "open -b $(/usr/libexec/PlistBuddy -c 'print :persistent-apps:" + number + ":tile-data:bundle-identifier' ~/Library/Preferences/com.apple.dock.plist)",
    },
  },
};

// Define a set of bundles based on different categories
local bundle = {

  // Hypervisors (used for virtualization apps like VirtualBox, Parallels, etc.)
  hypervisors: [
    '^org\\.virtualbox\\.app\\.VirtualBoxVM$',  // VirtualBox
    '^com\\.parallels\\.desktop\\.console$',  // Parallels Desktop
    '^org\\.vmware\\.fusion$',  // VMware Fusion
  ],

  // IDEs (used for integrated development environments)
  ides: [
    '^org\\.gnu\\.emacs$',  // Emacs
    '^org\\.gnu\\.Emacs$',  // Another Emacs variant
    '^com\\.jetbrains',  // JetBrains products
    '^com\\.microsoft\\.VSCode$',  // Visual Studio Code
    '^com\\.vscodium$',  // VSCodium
    '^com\\.sublimetext\\.3$',  // Sublime Text
    '^net\\.kovidgoyal\\.kitty$',  // Kitty terminal emulator
  ],

  // Remote desktop applications (used for accessing other computers)
  remoteDesktops: [
    '^com\\.citrix\\.XenAppViewer$',  // Citrix XenApp
    '^com\\.microsoft\\.rdc\\.macos$',  // Microsoft Remote Desktop for macOS
  ],

  // Terminal emulators (used for accessing command-line environments)
  terminalEmulators: [
    '^com\\.alacritty$',  // Alacritty terminal
    '^co\\.zeit\\.hyper$',  // Hyper terminal
    '^com\\.googlecode\\.iterm2$',  // iTerm2 terminal
    '^com\\.apple\\.Terminal$',  // macOS Terminal
    '^com\\.github\\.wez\\.wezterm$',  // WezTerm terminal
  ],

  // Web browsers (used for web browsing applications)
  webBrowsers: [
    '^com\\.google\\.chrome$',  // Google Chrome
    '^com\\.google\\.Chrome$',  // Google Chrome (alternative identifier)
    '^org\\.mozilla\\.firefox$',  // Mozilla Firefox
    '^org\\.mozilla\\.nightly$',  // Firefox Nightly
    '^com\\.brave\\.Browser$',  // Brave browser
    '^com\\.apple\\.Safari$',  // Safari browser
  ],

  // A combined list of all the bundles
  standard:
    $.hypervisors +
    $.ides +
    $.remoteDesktops +
    $.terminalEmulators +
    [],
};

// Define file paths that are associated with certain bundle categories
local file_paths = {

  // File paths for remote desktop applications
  remoteDesktops: [
    'Chrome Remote Desktop\\.app',  // Chrome Remote Desktop app
  ],

  // A standard file path list, including remote desktops
  standard:
    $.remoteDesktops +
    [],
};

{
  title: 'Windows Shortcuts',  // Title of the configuration: "Windows Shortcuts"
  rules: [  // List of keybinding rules
    // Navigation Keys
    // Rule for 'Insert' key with Ctrl (only in terminal emulators)
    keyConfig.rule('Insert (Ctrl) [+Terminal Emulators]',  // Rule description: "Insert (Ctrl) in Terminal Emulators"
                   keyConfig.input('insert', ['control']),  // Input: 'Insert' key with 'Control' modifier
                   keyConfig.outputKey('c', ['command']),  // Output: Trigger the 'C' key with 'Command' modifier
                   keyConfig.condition('unless', bundle.hypervisors + bundle.ides + bundle.remoteDesktops, file_paths.remoteDesktops)),  // Condition: Applies unless it's in hypervisors, IDEs, or remote desktops

    // Rule for 'Insert' key with Ctrl (in standard environment)
    keyConfig.rule('Insert (Ctrl)',  // Rule description: "Insert (Ctrl)"
                   keyConfig.input('insert', ['control']),  // Input: 'Insert' key with 'Control' modifier
                   keyConfig.outputKey('c', ['command']),  // Output: Trigger the 'C' key with 'Command' modifier
                   keyConfig.condition('unless', bundle.standard, file_paths.standard)),  // Condition: Applies unless it's in a standard environment

    // Rule for 'Insert' key with Shift (only in terminal emulators)
    keyConfig.rule('Insert (Shift) [+Terminal Emulators]',  // Rule description: "Insert (Shift) in Terminal Emulators"
                   keyConfig.input('insert', ['shift']),  // Input: 'Insert' key with 'Shift' modifier
                   keyConfig.outputKey('v', ['command']),  // Output: Trigger the 'V' key with 'Command' modifier
                   keyConfig.condition('unless', bundle.hypervisors + bundle.ides + bundle.remoteDesktops, file_paths.remoteDesktops)),  // Condition: Applies unless it's in hypervisors, IDEs, or remote desktops

    // Rule for 'Insert' key with Shift (in standard environment)
    keyConfig.rule('Insert (Shift)',  // Rule description: "Insert (Shift)"
                   keyConfig.input('insert', ['shift']),  // Input: 'Insert' key with 'Shift' modifier
                   keyConfig.outputKey('v', ['command']),  // Output: Trigger the 'V' key with 'Command' modifier
                   keyConfig.condition('unless', bundle.standard, file_paths.standard)),  // Condition: Applies unless it's in a standard environment

    // Rule for 'Home' key (moves cursor to the beginning of the line)
    keyConfig.rule('Home',  // Rule description: "Home"
                   keyConfig.input('home'),  // Input: 'Home' key
                   keyConfig.outputKey('left_arrow', ['command']),  // Output: 'Left Arrow' with 'Command' modifier
                   keyConfig.condition('unless', bundle.standard, file_paths.standard)),  // Condition: Applies unless it's in a standard environment

    // Rule for 'Home' key with Ctrl (moves cursor to the beginning of the document)
    keyConfig.rule('Home (Ctrl)',  // Rule description: "Home (Ctrl)"
                   keyConfig.input('home', ['control']),  // Input: 'Home' key with 'Control' modifier
                   keyConfig.outputKey('up_arrow', ['command']),  // Output: 'Up Arrow' with 'Command' modifier
                   keyConfig.condition('unless', bundle.standard, file_paths.standard)),  // Condition: Applies unless it's in a standard environment
    // Rule for 'Home' key with Shift (selects from current position to beginning of the line)
    keyConfig.rule('Home (Shift)',  // Rule description: "Home (Shift)"
                   keyConfig.input('home', ['shift']),  // Input: 'Home' key with 'Shift' modifier
                   keyConfig.outputKey('left_arrow', ['command', 'shift']),  // Output: 'Left Arrow' with 'Command' and 'Shift' modifiers (selecting text)
                   keyConfig.condition('unless', bundle.standard, file_paths.standard)),  // Condition: Applies unless it's in a standard environment

    // Rule for 'Home' key with Ctrl+Shift (selects from current position to beginning of the document)
    keyConfig.rule('Home (Ctrl+Shift)',  // Rule description: "Home (Ctrl+Shift)"
                   keyConfig.input('home', ['control', 'shift']),  // Input: 'Home' key with 'Control' and 'Shift' modifiers
                   keyConfig.outputKey('up_arrow', ['command', 'shift']),  // Output: 'Up Arrow' with 'Command' and 'Shift' modifiers (selecting text)
                   keyConfig.condition('unless', bundle.standard, file_paths.standard)),  // Condition: Applies unless it's in a standard environment

    // Rule for 'End' key (moves cursor to the end of the line)
    keyConfig.rule('End',  // Rule description: "End"
                   keyConfig.input('end'),  // Input: 'End' key
                   keyConfig.outputKey('right_arrow', ['command']),  // Output: 'Right Arrow' with 'Command' modifier
                   keyConfig.condition('unless', bundle.standard, file_paths.standard)),  // Condition: Applies unless it's in a standard environment

    // Rule for 'End' key with Ctrl (moves cursor to the end of the document)
    keyConfig.rule('End (Ctrl)',  // Rule description: "End (Ctrl)"
                   keyConfig.input('end', ['control']),  // Input: 'End' key with 'Control' modifier
                   keyConfig.outputKey('down_arrow', ['command']),  // Output: 'Down Arrow' with 'Command' modifier
                   keyConfig.condition('unless', bundle.standard, file_paths.standard)),  // Condition: Applies unless it's in a standard environment

    // Rule for 'End' key with Shift (selects from current position to end of the line)
    keyConfig.rule('End (Shift)',  // Rule description: "End (Shift)"
                   keyConfig.input('end', ['shift']),  // Input: 'End' key with 'Shift' modifier
                   keyConfig.outputKey('right_arrow', ['command', 'shift']),  // Output: 'Right Arrow' with 'Command' and 'Shift' modifiers (selecting text)
                   keyConfig.condition('unless', bundle.standard, file_paths.standard)),  // Condition: Applies unless it's in a standard environment
    // Rule for 'End' key with Ctrl+Shift (selects from current position to end of the document)
    keyConfig.rule('End (Ctrl+Shift)',  // Rule description: "End (Ctrl+Shift)"
                   keyConfig.input('end', ['control', 'shift']),  // Input: 'End' key with 'Control' and 'Shift' modifiers
                   keyConfig.outputKey('down_arrow', ['command', 'shift']),  // Output: 'Down Arrow' with 'Command' and 'Shift' modifiers (selecting text)
                   keyConfig.condition('unless', bundle.standard, file_paths.standard)),  // Condition: Applies unless it's in a standard environment

    // Rule for 'Left Arrow' key with Ctrl (moves cursor one word left)
    keyConfig.rule('Left Arrow (Ctrl)',  // Rule description: "Left Arrow (Ctrl)"
                   keyConfig.input('left_arrow', ['control']),  // Input: 'Left Arrow' key with 'Control' modifier
                   keyConfig.outputKey('left_arrow', ['option']),  // Output: 'Left Arrow' with 'Option' modifier (moving one word left)
                   keyConfig.condition('unless', bundle.standard, file_paths.standard)),  // Condition: Applies unless it's in a standard environment

    // Rule for 'Left Arrow' key with Ctrl+Shift (selects the previous word)
    keyConfig.rule('Left Arrow (Ctrl+Shift)',  // Rule description: "Left Arrow (Ctrl+Shift)"
                   keyConfig.input('left_arrow', ['control', 'shift']),  // Input: 'Left Arrow' key with 'Control' and 'Shift' modifiers
                   keyConfig.outputKey('left_arrow', ['option', 'shift']),  // Output: 'Left Arrow' with 'Option' and 'Shift' modifiers (selecting the previous word)
                   keyConfig.condition('unless', bundle.standard, file_paths.standard)),  // Condition: Applies unless it's in a standard environment

    // Rule for 'Right Arrow' key with Ctrl (moves cursor one word right)
    keyConfig.rule('Right Arrow (Ctrl)',  // Rule description: "Right Arrow (Ctrl)"
                   keyConfig.input('right_arrow', ['control']),  // Input: 'Right Arrow' key with 'Control' modifier
                   keyConfig.outputKey('right_arrow', ['option']),  // Output: 'Right Arrow' with 'Option' modifier (moving one word right)
                   keyConfig.condition('unless', bundle.standard, file_paths.standard)),  // Condition: Applies unless it's in a standard environment

    // Rule for 'Right Arrow' key with Ctrl+Shift (selects the next word)
    keyConfig.rule('Right Arrow (Ctrl+Shift)',  // Rule description: "Right Arrow (Ctrl+Shift)"
                   keyConfig.input('right_arrow', ['control', 'shift']),  // Input: 'Right Arrow' key with 'Control' and 'Shift' modifiers
                   keyConfig.outputKey('right_arrow', ['option', 'shift']),  // Output: 'Right Arrow' with 'Option' and 'Shift' modifiers (selecting the next word)
                   keyConfig.condition('unless', bundle.standard, file_paths.standard)),  // Condition: Applies unless it's in a standard environment

    // Command Keys
    // Rule for 'Backspace' key with Ctrl (deletes a word to the left)
    keyConfig.rule('Backspace (Ctrl)',  // Rule description: "Backspace (Ctrl)"
                   keyConfig.input('delete_or_backspace', ['control']),  // Input: 'Backspace' key with 'Control' modifier
                   keyConfig.outputKey('delete_or_backspace', ['option']),  // Output: 'Backspace' with 'Option' modifier (deletes a word to the left)
                   keyConfig.condition('unless', bundle.standard, file_paths.standard)),  // Condition: Applies unless it's in a standard environment

    // Rule for 'Delete' key with Ctrl (deletes a word to the right)
    keyConfig.rule('Delete (Ctrl)',  // Rule description: "Delete (Ctrl)"
                   keyConfig.input('delete_forward', ['control']),  // Input: 'Delete' key with 'Control' modifier
                   keyConfig.outputKey('delete_forward', ['option']),  // Output: 'Delete' with 'Option' modifier (deletes a word to the right)
                   keyConfig.condition('unless', bundle.standard, file_paths.standard)),  // Condition: Applies unless it's in a standard environment

    // Rule for 'Enter' key with Ctrl (acts as 'Command' modifier)
    keyConfig.rule('Enter (Ctrl)',  // Rule description: "Enter (Ctrl)"
                   keyConfig.input('return_or_enter', ['control']),  // Input: 'Enter' key with 'Control' modifier
                   keyConfig.outputKey('return_or_enter', ['command']),  // Output: 'Enter' with 'Command' modifier
                   keyConfig.condition('unless', bundle.standard, file_paths.standard)),  // Condition: Applies unless it's in a standard environment
    // Rule for 'Enter' key with Ctrl+Shift (acts as 'Command' + 'Shift' modifier)
    keyConfig.rule('Enter (Ctrl+Shift)',  // Rule description: "Enter (Ctrl+Shift)"
                   keyConfig.input('return_or_enter', ['control', 'shift']),  // Input: 'Enter' key with 'Control' and 'Shift' modifiers
                   keyConfig.outputKey('return_or_enter', ['command', 'shift']),  // Output: 'Enter' with 'Command' and 'Shift' modifiers
                   keyConfig.condition('unless', bundle.standard, file_paths.standard)),  // Condition: Applies unless it's in a standard environment

    // Modifier Keys
    // Rule for 'Win' key (Open Spotlight application when pressed alone)
    keyConfig.rule('Win [Open Spotlight]',  // Rule description: "Win [Open Spotlight]"
                   keyConfig.input('left_command', key_is_modifier=true),  // Input: 'Left Command' key (modifier key)
                   [
                     keyConfig.outputKey('left_command', output_type='to'),  // Output: Sends 'Left Command' key to its default action
                     keyConfig.outputKey('spotlight', output_type='to_if_alone', key_code='apple_vendor_keyboard_key_code'),  // Output: Opens Spotlight if pressed alone
                   ]),

    // Alphanumeric Keys
    // Rule for 'A' key with Ctrl (copies 'A' from standard to command)
    keyConfig.rule('A (Ctrl)',  // Rule description: "A (Ctrl)"
                   keyConfig.input('a', ['control']),  // Input: 'A' key with 'Control' modifier
                   keyConfig.outputKey('a', ['command']),  // Output: 'A' key with 'Command' modifier
                   keyConfig.condition('unless', bundle.standard, file_paths.standard)),  // Condition: Applies unless it's in a standard environment

    // Rule for 'B' key with Ctrl
    keyConfig.rule('B (Ctrl)',  // Rule description: "B (Ctrl)"
                   keyConfig.input('b', ['control']),  // Input: 'B' key with 'Control' modifier
                   keyConfig.outputKey('b', ['command']),  // Output: 'B' key with 'Command' modifier
                   keyConfig.condition('unless', bundle.standard, file_paths.standard)),  // Condition: Applies unless it's in a standard environment

    // Rule for 'C' key with Ctrl (standard copy action)
    keyConfig.rule('C (Ctrl)',  // Rule description: "C (Ctrl)"
                   keyConfig.input('c', ['left_control']),  // Input: 'C' key with 'Left Control' modifier
                   keyConfig.outputKey('c', ['command']),  // Output: 'C' key with 'Command' modifier
                   keyConfig.condition('unless', bundle.standard, file_paths.standard)),  // Condition: Applies unless it's in a standard environment

    // Rule for 'C' key with Ctrl+Shift in terminal emulators
    keyConfig.rule('C (Ctrl+Shift) [Only Terminal Emulators]',  // Rule description: "C (Ctrl+Shift) [Only Terminal Emulators]"
                   keyConfig.input('c', ['control', 'shift']),  // Input: 'C' key with 'Control' and 'Shift' modifiers
                   keyConfig.outputKey('c', ['command']),  // Output: 'C' key with 'Command' modifier
                   keyConfig.condition('if', bundle.terminalEmulators)),  // Condition: Applies only in terminal emulators

    // Rule for 'F' key with Ctrl
    keyConfig.rule('F (Ctrl)',  // Rule description: "F (Ctrl)"
                   keyConfig.input('f', ['control']),  // Input: 'F' key with 'Control' modifier
                   keyConfig.outputKey('f', ['command']),  // Output: 'F' key with 'Command' modifier
                   keyConfig.condition('unless', bundle.standard, file_paths.standard)),  // Condition: Applies unless it's in a standard environment

    // Rule for 'H' key with Ctrl in web browsers (replaces 'H' with 'Y')
    keyConfig.rule('H (Ctrl) [Only Web Browsers]',  // Rule description: "H (Ctrl) [Only Web Browsers]"
                   keyConfig.input('h', ['control']),  // Input: 'H' key with 'Control' modifier
                   keyConfig.outputKey('y', ['command']),  // Output: 'Y' key with 'Command' modifier (Web browsers replacement)
                   keyConfig.condition('if', bundle.webBrowsers)),  // Condition: Applies only in web browsers
    // Rule for 'I' key with Ctrl
    keyConfig.rule('I (Ctrl)',  // Rule description: "I (Ctrl)"
                   keyConfig.input('i', ['control']),  // Input: 'I' key with 'Control' modifier
                   keyConfig.outputKey('i', ['command']),  // Output: 'I' key with 'Command' modifier
                   keyConfig.condition('unless', bundle.standard, file_paths.standard)),  // Condition: Applies unless it's in a standard environment

    // Rule for 'L' key with Ctrl in web browsers (replaces 'L' with 'L' in command key)
    keyConfig.rule('L (Ctrl) [Only Web Browsers]',  // Rule description: "L (Ctrl) [Only Web Browsers]"
                   keyConfig.input('l', ['control']),  // Input: 'L' key with 'Control' modifier
                   keyConfig.outputKey('l', ['command']),  // Output: 'L' key with 'Command' modifier (Web browsers replacement)
                   keyConfig.condition('if', bundle.webBrowsers)),  // Condition: Applies only in web browsers

    // Rule for 'L' key with Command (locks the screen)
    keyConfig.rule('L (Win) [Lock Screen]',  // Rule description: "L (Win) [Lock Screen]"
                   keyConfig.input('l', ['command']),  // Input: 'L' key with 'Command' modifier
                   keyConfig.outputKey('q', ['control', 'command'])),  // Output: 'Q' key with 'Control' and 'Command' modifiers (locks the screen)

    // Rule for 'L' key with Command (puts the system to sleep)
    keyConfig.rule('L (Win) [Sleep]',  // Rule description: "L (Win) [Sleep]"
                   keyConfig.input('l', ['command']),  // Input: 'L' key with 'Command' modifier
                   keyConfig.outputKey('power', ['control', 'shift'])),  // Output: Power button with 'Control' and 'Shift' modifiers (puts the system to sleep)

    // Rule for 'L' key with Alt+Ctrl (locks the screen)
    keyConfig.rule('L (Alt+Ctrl) [Lock Screen]',  // Rule description: "L (Alt+Ctrl) [Lock Screen]"
                   keyConfig.input('l', ['control', 'option']),  // Input: 'L' key with 'Control' and 'Option' modifiers
                   keyConfig.outputKey('q', ['control', 'command'])),  // Output: 'Q' key with 'Control' and 'Command' modifiers (locks the screen)

    // Rule for 'L' key with Alt+Ctrl (puts the system to sleep)
    keyConfig.rule('L (Alt+Ctrl) [Sleep]',  // Rule description: "L (Alt+Ctrl) [Sleep]"
                   keyConfig.input('l', ['control', 'option']),  // Input: 'L' key with 'Control' and 'Option' modifiers
                   keyConfig.outputKey('power', ['control', 'shift'])),  // Output: Power button with 'Control' and 'Shift' modifiers (puts the system to sleep)

    // Rule for 'N' key with Ctrl
    keyConfig.rule('N (Ctrl)',  // Rule description: "N (Ctrl)"
                   keyConfig.input('n', ['control']),  // Input: 'N' key with 'Control' modifier
                   keyConfig.outputKey('n', ['command']),  // Output: 'N' key with 'Command' modifier
                   keyConfig.condition('unless', bundle.standard, file_paths.standard)),  // Condition: Applies unless it's in a standard environment

    // Rule for 'O' key with Ctrl
    keyConfig.rule('O (Ctrl)',  // Rule description: "O (Ctrl)"
                   keyConfig.input('o', ['control']),  // Input: 'O' key with 'Control' modifier
                   keyConfig.outputKey('o', ['command']),  // Output: 'O' key with 'Command' modifier
                   keyConfig.condition('unless', bundle.standard, file_paths.standard)),  // Condition: Applies unless it's in a standard environment

    // Rule for 'P' key with Ctrl
    keyConfig.rule('P (Ctrl)',  // Rule description: "P (Ctrl)"
                   keyConfig.input('p', ['control']),  // Input: 'P' key with 'Control' modifier
                   keyConfig.outputKey('p', ['command']),  // Output: 'P' key with 'Command' modifier
                   keyConfig.condition('unless', bundle.standard, file_paths.standard)),  // Condition: Applies unless it's in a standard environment
    // Rule for 'R' key with Ctrl
    keyConfig.rule('R (Ctrl)',  // Rule description: "R (Ctrl)"
                   keyConfig.input('r', ['control']),  // Input: 'R' key with 'Control' modifier
                   keyConfig.outputKey('r', ['command']),  // Output: 'R' key with 'Command' modifier
                   keyConfig.condition('unless', bundle.standard, file_paths.standard)),  // Condition: Applies unless it's in a standard environment

    // Rule for 'S' key with Ctrl
    keyConfig.rule('S (Ctrl)',  // Rule description: "S (Ctrl)"
                   keyConfig.input('s', ['control']),  // Input: 'S' key with 'Control' modifier
                   keyConfig.outputKey('s', ['command']),  // Output: 'S' key with 'Command' modifier
                   keyConfig.condition('unless', bundle.standard, file_paths.standard)),  // Condition: Applies unless it's in a standard environment

    // Rule for 'T' key with Ctrl
    keyConfig.rule('T (Ctrl)',  // Rule description: "T (Ctrl)"
                   keyConfig.input('t', ['control']),  // Input: 'T' key with 'Control' modifier
                   keyConfig.outputKey('t', ['command']),  // Output: 'T' key with 'Command' modifier
                   keyConfig.condition('unless', bundle.standard, file_paths.standard)),  // Condition: Applies unless it's in a standard environment

    // Rule for 'U' key with Ctrl
    keyConfig.rule('U (Ctrl)',  // Rule description: "U (Ctrl)"
                   keyConfig.input('u', ['control']),  // Input: 'U' key with 'Control' modifier
                   keyConfig.outputKey('u', ['command']),  // Output: 'U' key with 'Command' modifier
                   keyConfig.condition('unless', bundle.standard, file_paths.standard)),  // Condition: Applies unless it's in a standard environment

    // Rule for 'V' key with Ctrl
    keyConfig.rule('V (Ctrl)',  // Rule description: "V (Ctrl)"
                   keyConfig.input('v', ['control']),  // Input: 'V' key with 'Control' modifier
                   keyConfig.outputKey('v', ['command']),  // Output: 'V' key with 'Command' modifier
                   keyConfig.condition('unless', bundle.standard, file_paths.standard)),  // Condition: Applies unless it's in a standard environment

    // Rule for 'V' key with Ctrl+Shift in terminal emulators
    keyConfig.rule('V (Ctrl+Shift) [Only Terminal Emulators]',  // Rule description: "V (Ctrl+Shift) [Only Terminal Emulators]"
                   keyConfig.input('v', ['control', 'shift']),  // Input: 'V' key with 'Control' and 'Shift' modifiers
                   keyConfig.outputKey('v', ['command']),  // Output: 'V' key with 'Command' modifier
                   keyConfig.condition('if', bundle.terminalEmulators)),  // Condition: Applies only in terminal emulators

    // Rule for 'W' key with Ctrl
    keyConfig.rule('W (Ctrl)',  // Rule description: "W (Ctrl)"
                   keyConfig.input('w', ['control']),  // Input: 'W' key with 'Control' modifier
                   keyConfig.outputKey('w', ['command']),  // Output: 'W' key with 'Command' modifier
                   keyConfig.condition('unless', bundle.standard, file_paths.standard)),  // Condition: Applies unless it's in a standard environment

    // Rule for 'X' key with Ctrl
    keyConfig.rule('X (Ctrl)',  // Rule description: "X (Ctrl)"
                   keyConfig.input('x', ['control']),  // Input: 'X' key with 'Control' modifier
                   keyConfig.outputKey('x', ['command']),  // Output: 'X' key with 'Command' modifier
                   keyConfig.condition('unless', bundle.standard, file_paths.standard)),  // Condition: Applies unless it's in a standard environment

    // Rule for 'Y' key with Ctrl
    keyConfig.rule('Y (Ctrl)',  // Rule description: "Y (Ctrl)"
                   keyConfig.input('y', ['control']),  // Input: 'Y' key with 'Control' modifier
                   keyConfig.outputKey('y', ['command']),  // Output: 'Y' key with 'Command' modifier
                   keyConfig.condition('unless', bundle.standard, file_paths.standard)),  // Condition: Applies unless it's in a standard environment

    // Rule for 'Z' key with Ctrl
    keyConfig.rule('Z (Ctrl)',  // Rule description: "Z (Ctrl)"
                   keyConfig.input('z', ['control']),  // Input: 'Z' key with 'Control' modifier
                   keyConfig.outputKey('z', ['command']),  // Output: 'Z' key with 'Command' modifier
                   keyConfig.condition('unless', bundle.standard, file_paths.standard)),  // Condition: Applies unless it's in a standard environment
    // Rule for '1' key with Command to open first pinned Dock app (Finder); applies to IDEs and Terminal Emulators
    keyConfig.rule('1 (Cmd) [Open first pinned Dock app (Finder); +IDEs and Terminal Emulators]',  // Rule description: "1 (Cmd) [Open first pinned Dock app (Finder); +IDEs and Terminal Emulators]"
                   keyConfig.input('1', ['command']),  // Input: '1' key with 'Command' modifier
                   keyConfig.outputShell('open -b com.apple.finder'),  // Output: Executes a shell command to open Finder
                   keyConfig.condition('unless', bundle.hypervisors + bundle.remoteDesktops, file_paths.standard)),  // Condition: Applies unless in specific bundles (hypervisors, remote desktops)

    // Rule for '2' key with Command to open second pinned Dock app; applies to IDEs and Terminal Emulators
    keyConfig.rule('2 (Cmd) [Open second pinned Dock app; +IDEs and Terminal Emulators]',  // Rule description: "2 (Cmd) [Open second pinned Dock app; +IDEs and Terminal Emulators]"
                   keyConfig.input('2', ['command']),  // Input: '2' key with 'Command' modifier
                   keyConfig.runDockedApp('0'),  // Output: Runs the second pinned app from the Dock
                   keyConfig.condition('unless', bundle.hypervisors + bundle.remoteDesktops, file_paths.standard)),  // Condition: Applies unless in specific bundles (hypervisors, remote desktops)

    // Rule for '3' key with Command to open third pinned Dock app; applies to IDEs and Terminal Emulators
    keyConfig.rule('3 (Cmd) [Open third pinned Dock app; +IDEs and Terminal Emulators]',  // Rule description: "3 (Cmd) [Open third pinned Dock app; +IDEs and Terminal Emulators]"
                   keyConfig.input('3', ['command']),  // Input: '3' key with 'Command' modifier
                   keyConfig.runDockedApp('1'),  // Output: Runs the third pinned app from the Dock
                   keyConfig.condition('unless', bundle.hypervisors + bundle.remoteDesktops, file_paths.standard)),  // Condition: Applies unless in specific bundles (hypervisors, remote desktops)

    // Rule for '4' key with Command to open fourth pinned Dock app; applies to IDEs and Terminal Emulators
    keyConfig.rule('4 (Cmd) [Open fourth pinned Dock app; +IDEs and Terminal Emulators]',  // Rule description: "4 (Cmd) [Open fourth pinned Dock app; +IDEs and Terminal Emulators]"
                   keyConfig.input('4', ['command']),  // Input: '4' key with 'Command' modifier
                   keyConfig.runDockedApp('2'),  // Output: Runs the fourth pinned app from the Dock
                   keyConfig.condition('unless', bundle.hypervisors + bundle.remoteDesktops, file_paths.standard)),  // Condition: Applies unless in specific bundles (hypervisors, remote desktops)

    // Rule for '5' key with Command to open fifth pinned Dock app; applies to IDEs and Terminal Emulators
    keyConfig.rule('5 (Cmd) [Open fifth pinned Dock app; +IDEs and Terminal Emulators]',  // Rule description: "5 (Cmd) [Open fifth pinned Dock app; +IDEs and Terminal Emulators]"
                   keyConfig.input('5', ['command']),  // Input: '5' key with 'Command' modifier
                   keyConfig.runDockedApp('3'),  // Output: Runs the fifth pinned app from the Dock
                   keyConfig.condition('unless', bundle.hypervisors + bundle.remoteDesktops, file_paths.standard)),  // Condition: Applies unless in specific bundles (hypervisors, remote desktops)

    // Rule for '6' key with Command to open sixth pinned Dock app; applies to IDEs and Terminal Emulators
    keyConfig.rule('6 (Cmd) [Open sixth pinned Dock app; +IDEs and Terminal Emulators]',  // Rule description: "6 (Cmd) [Open sixth pinned Dock app; +IDEs and Terminal Emulators]"
                   keyConfig.input('6', ['command']),  // Input: '6' key with 'Command' modifier
                   keyConfig.runDockedApp('4'),  // Output: Runs the sixth pinned app from the Dock
                   keyConfig.condition('unless', bundle.hypervisors + bundle.remoteDesktops, file_paths.standard)),  // Condition: Applies unless in specific bundles (hypervisors, remote desktops)

    // Rule for '7' key with Command to open seventh pinned Dock app; applies to IDEs and Terminal Emulators
    keyConfig.rule('7 (Cmd) [Open seventh pinned Dock app; +IDEs and Terminal Emulators]',  // Rule description: "7 (Cmd) [Open seventh pinned Dock app; +IDEs and Terminal Emulators]"
                   keyConfig.input('7', ['command']),  // Input: '7' key with 'Command' modifier
                   keyConfig.runDockedApp('5'),  // Output: Runs the seventh pinned app from the Dock
                   keyConfig.condition('unless', bundle.hypervisors + bundle.remoteDesktops, file_paths.standard)),  // Condition: Applies unless in specific bundles (hypervisors, remote desktops)

    // Rule for '8' key with Command to open eighth pinned Dock app; applies to IDEs and Terminal Emulators
    keyConfig.rule('8 (Cmd) [Open eighth pinned Dock app; +IDEs and Terminal Emulators]',  // Rule description: "8 (Cmd) [Open eighth pinned Dock app; +IDEs and Terminal Emulators]"
                   keyConfig.input('8', ['command']),  // Input: '8' key with 'Command' modifier
                   keyConfig.runDockedApp('6'),  // Output: Runs the eighth pinned app from the Dock
                   keyConfig.condition('unless', bundle.hypervisors + bundle.remoteDesktops, file_paths.standard)),  // Condition: Applies unless in specific bundles (hypervisors, remote desktops)
    // Rule for '9' key with Command to open ninth pinned Dock app; applies to IDEs and Terminal Emulators
    keyConfig.rule('9 (Cmd) [Open ninth pinned Dock app; +IDEs and Terminal Emulators]',  // Rule description: "9 (Cmd) [Open ninth pinned Dock app; +IDEs and Terminal Emulators]"
                   keyConfig.input('9', ['command']),  // Input: '9' key with 'Command' modifier
                   keyConfig.runDockedApp('7'),  // Output: Runs the ninth pinned app from the Dock
                   keyConfig.condition('unless', bundle.hypervisors + bundle.remoteDesktops, file_paths.standard)),  // Condition: Applies unless in specific bundles (hypervisors, remote desktops)

    // Rule for '/' key with Control to execute command in Terminal Emulators
    keyConfig.rule('/ (Ctrl) [+Terminal Emulators]',  // Rule description: "/ (Ctrl) [+Terminal Emulators]"
                   keyConfig.input('slash', ['control']),  // Input: '/' key with 'Control' modifier
                   keyConfig.outputKey('slash', ['command']),  // Output: Executes 'Command + /' action
                   keyConfig.condition('unless', bundle.hypervisors + bundle.ides + bundle.remoteDesktops, file_paths.remoteDesktops)),  // Condition: Applies unless in specific bundles (hypervisors, IDEs, remote desktops)

    // Rule for Spacebar with Control to execute command in standard applications
    keyConfig.rule('Space (Ctrl)',  // Rule description: "Space (Ctrl)"
                   keyConfig.input('spacebar', ['control']),  // Input: Spacebar with 'Control' modifier
                   keyConfig.outputKey('spacebar', ['command']),  // Output: Executes 'Command + Space' action
                   keyConfig.condition('unless', bundle.standard, file_paths.standard)),  // Condition: Applies unless in the standard file paths or bundles

    // Rule for Tab key with Option to execute command in IDEs and Terminal Emulators
    keyConfig.rule('Tab (Alt) [+IDEs and Terminal Emulators]',  // Rule description: "Tab (Alt) [+IDEs and Terminal Emulators]"
                   keyConfig.input('tab', ['option']),  // Input: Tab key with 'Option' modifier
                   keyConfig.outputKey('tab', ['command']),  // Output: Executes 'Command + Tab' action
                   keyConfig.condition('unless', bundle.hypervisors + bundle.remoteDesktops, file_paths.remoteDesktops)),  // Condition: Applies unless in specific bundles (hypervisors, remote desktops)

    // Function key rules
    keyConfig.rule('F1',  // Rule description: "F1"
                   keyConfig.input('f1'),  // Input: 'F1' key
                   keyConfig.outputKey('slash', ['command', 'shift']),  // Output: Executes 'Command + Shift + /' action
                   keyConfig.condition('unless', bundle.standard, file_paths.standard)),  // Condition: Applies unless in the standard file paths or bundles

    // Rule for 'F3' key to execute 'Command + G' action
    keyConfig.rule('F3',  // Rule description: "F3"
                   keyConfig.input('f3'),  // Input: 'F3' key
                   keyConfig.outputKey('g', ['command']),  // Output: Executes 'Command + G' action
                   keyConfig.condition('unless', bundle.standard, file_paths.standard)),  // Condition: Applies unless in the standard file paths or bundles

    // Rule for 'F4' key with Option modifier to execute command in Terminal Emulators
    keyConfig.rule('F4 (Alt) [+Terminal Emulators]',  // Rule description: "F4 (Alt) [+Terminal Emulators]"
                   keyConfig.input('f4', ['option']),  // Input: 'F4' key with 'Option' modifier
                   keyConfig.outputKey('q', ['command']),  // Output: Executes 'Command + Q' action
                   keyConfig.condition('unless', bundle.hypervisors + bundle.ides + bundle.remoteDesktops, file_paths.remoteDesktops)),  // Condition: Applies unless in specific bundles (hypervisors, IDEs, remote desktops)

    // Rule for 'F4' key with Control modifier, specifically for Chrome
    keyConfig.rule('F4 (Ctrl) [Only Chrome]',  // Rule description: "F4 (Ctrl) [Only Chrome]"
                   keyConfig.input('f4', ['control']),  // Input: 'F4' key with 'Control' modifier
                   keyConfig.outputKey('w', ['command']),  // Output: Executes 'Command + W' action (close tab)
                   keyConfig.condition('if', ['^com\\.google\\.Chrome$'])),  // Condition: Only applies if the app is Chrome

    // Rule for 'F5' key to execute 'Command + R' action, specifically for Chrome
    keyConfig.rule('F5 [Only Chrome]',  // Rule description: "F5 [Only Chrome]"
                   keyConfig.input('f5'),  // Input: 'F5' key
                   keyConfig.outputKey('r', ['command']),  // Output: Executes 'Command + R' action (refresh)
                   keyConfig.condition('if', ['^com\\.google\\.Chrome$'])),  // Condition: Only applies if the app is Chrome
  ],
}

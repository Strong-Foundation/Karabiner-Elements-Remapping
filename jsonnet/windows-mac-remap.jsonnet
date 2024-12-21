-- Define a local table named 'keyConfig' that contains functions and configurations for key mapping.
local keyConfig = {

  -- Define a function 'rule' to create a key mapping rule.
  -- Takes a description of the rule, input trigger, output action, and an optional condition.
  rule(description, input, output, condition=null):: {
    description: description,  -- The human-readable description of the rule.
    manipulators: [  -- Array of objects defining how the key should be manipulated.
      {
        from: input,  -- Specifies the input trigger for the rule, using the 'input' object.
      } + {
        -- Maps each output type to its corresponding output definition.
        [o.to_type]: [o.output]
        for o in if std.isArray(output) then output else [output] + []  -- Ensures that 'output' is processed as an array.
      } + {
        [if condition != null then 'conditions']: [  -- Includes conditions only if they are provided.
          condition,  -- Adds the specified condition to the conditions array.
        ],
        type: 'basic',  -- Specifies the rule type; default is 'basic'.
      },
    ],
  },

  -- Define a function 'input' to configure the input trigger for a rule.
  -- Takes the key to trigger, optional modifiers, and an optional flag if the key itself is a modifier.
  input(key, modifiers=null, key_is_modifier=false):: {
    key_code: key,  -- Specifies the key that will trigger the rule.
    [if key_is_modifier then null else 'modifiers']: {  -- Adds modifiers unless the key is a modifier itself.
      [if modifiers != null then 'mandatory']: modifiers,  -- Adds mandatory modifiers if provided.
      optional: ['any'],  -- Allows any optional modifiers by default.
    },
  },

  -- Define a function 'outputKey' to specify the key output when a rule is triggered.
  -- Takes the output key, optional modifiers, output type, and an optional key code type.
  outputKey(key, modifiers=null, output_type='to', key_code='key_code'):: {
    to_type: output_type,  -- Specifies the type of output object (default is 'to').
    output: {  -- Configures the output key properties.
      [key_code]: key,  -- Sets the key to output when the rule is triggered.
      [if modifiers != null then 'modifiers']: modifiers,  -- Adds modifiers to the output if provided.
    },
  },

  -- Define a function 'outputShell' to specify a shell command as the output for a rule.
  -- Takes the shell command to execute.
  outputShell(command):: {
    to_type: 'to',  -- Specifies the type of output object as 'to'.
    output: {  -- Configures the shell command to execute when the rule is triggered.
      shell_command: command,  -- Sets the shell command to run.
    },
  },

  -- Define a function 'condition' to configure a condition for triggering a rule.
  -- Takes a condition type, an array of bundle identifiers, and optional file paths.
  condition(type, bundles, file_paths=null):: {
    type: 'frontmost_application_' + type,  -- Constructs the condition type, e.g., 'frontmost_application_if' or 'unless'.
    bundle_identifiers: bundles,  -- Specifies the bundle identifiers of applications for the condition.
    [if file_paths != null then 'file_paths']: file_paths,  -- Optionally adds file paths if provided.
  },

  -- Define a function 'runDockedApp' to run a specific docked application by its index.
  -- Takes the zero-indexed position of the docked app to run.
  runDockedApp(number):: {
    to_type: 'to',  -- Specifies the type of output object as 'to'.
    output: {  -- Configures the shell command to launch the docked application.
      -- Constructs a shell command to open the application based on its position in the dock.
      shell_command: "open -b $(/usr/libexec/PlistBuddy -c 'print :persistent-apps:" + number + ":tile-data:bundle-identifier' ~/Library/Preferences/com.apple.dock.plist)",
    },
  },
};


//---------//
// BUNDLE  //
//---------//

local bundle = {
  //--------------------//
  // BUNDLE IDENTIFIERS //
  //--------------------//

  // bundle identifiers for hypervisor applications
  hypervisors: [
    // Oracle VirtualBox
    '^org\\.virtualbox\\.app\\.VirtualBoxVM$',
    // Parallels
    '^com\\.parallels\\.desktop\\.console$',
    // VMWare Fusion
    '^org\\.vmware\\.fusion$',
  ],

  // bundle identifiers for IDE applications
  ides: [
    // GNU Emacs (GUI)
    '^org\\.gnu\\.emacs$',
    '^org\\.gnu\\.Emacs$',
    // JetBrains tools
    '^com\\.jetbrains',
    // Microsoft VSCode
    '^com\\.microsoft\\.VSCode$',
    // VSCodium - Open Source VSCode
    '^com\\.vscodium$',
    // Sublime Text
    '^com\\.sublimetext\\.3$',
    // Kitty
    '^net\\.kovidgoyal\\.kitty$',
  ],

  // bundle identifiers for remote desktop applications
  remoteDesktops: [
    // Citrix XenAppViewer
    '^com\\.citrix\\.XenAppViewer$',
    // Microsoft Remote Desktop Connection
    '^com\\.microsoft\\.rdc\\.macos$',
  ],

  // bundle identifiers for terminal emulator applications
  terminalEmulators: [
    // Alacritty
    '^com\\.alacritty$',
    // Hyper
    '^co\\.zeit\\.hyper$',
    // iTerm2
    '^com\\.googlecode\\.iterm2$',
    // Terminal
    '^com\\.apple\\.Terminal$',
    // WezTerm
    '^com\\.github\\.wez\\.wezterm$',
  ],

  // bundle identifiers for web browser applications
  webBrowsers: [
    // Google Chrome
    '^com\\.google\\.chrome$',
    '^com\\.google\\.Chrome$',
    // Mozilla Firefox
    '^org\\.mozilla\\.firefox$',
    '^org\\.mozilla\\.nightly$',
    // Brave Browser
    '^com\\.brave\\.Browser$',
    // Safari
    '^com\\.apple\\.Safari$',
  ],

  // since this combination is used so much, it's given its own identifier
  standard:
    $.hypervisors +
    $.ides +
    $.remoteDesktops +
    $.terminalEmulators +
    [],  // unnecessary, but it allows the '$.foo +'-style for the preceeding lines, which makes my OCD happy
};
//---------//
// FILE PATHS //
//---------//

local file_paths = {
  //-----------------------//
  // FILE PATH IDENTIFIERS //
  //-----------------------//

  // file path identifiers for remote desktop applications
  remoteDesktops: [
    // Chrome Remote desktop
    'Chrome Remote Desktop\\.app',
  ],

  // since this combination is used so much, it's given its own identifier
  standard:
    $.remoteDesktops +
    [],  // unnecessary, but it allows the '$.foo +'-style for the preceeding lines, which makes my OCD happy
};

//------//
// MAIN //
//------//

{
  title: 'Windows Shortcuts',
  rules: [
    // Navigation Keys
    keyConfig.rule('Insert (Ctrl) [+Terminal Emulators]',
                   keyConfig.input('insert', ['control']),
                   keyConfig.outputKey('c', ['command']),
                   keyConfig.condition('unless', bundle.hypervisors + bundle.ides + bundle.remoteDesktops, file_paths.remoteDesktops)),
    keyConfig.rule('Insert (Ctrl)',
                   keyConfig.input('insert', ['control']),
                   keyConfig.outputKey('c', ['command']),
                   keyConfig.condition('unless', bundle.standard, file_paths.standard)),
    keyConfig.rule('Insert (Shift) [+Terminal Emulators]',
                   keyConfig.input('insert', ['shift']),
                   keyConfig.outputKey('v', ['command']),
                   keyConfig.condition('unless', bundle.hypervisors + bundle.ides + bundle.remoteDesktops, file_paths.remoteDesktops)),
    keyConfig.rule('Insert (Shift)',
                   keyConfig.input('insert', ['shift']),
                   keyConfig.outputKey('v', ['command']),
                   keyConfig.condition('unless', bundle.standard, file_paths.standard)),
    keyConfig.rule('Home',
                   keyConfig.input('home'),
                   keyConfig.outputKey('left_arrow', ['command']),
                   keyConfig.condition('unless', bundle.standard, file_paths.standard)),
    keyConfig.rule('Home (Ctrl)',
                   keyConfig.input('home', ['control']),
                   keyConfig.outputKey('up_arrow', ['command']),
                   keyConfig.condition('unless', bundle.standard, file_paths.standard)),
    keyConfig.rule('Home (Shift)',
                   keyConfig.input('home', ['shift']),
                   keyConfig.outputKey('left_arrow', ['command', 'shift']),
                   keyConfig.condition('unless', bundle.standard, file_paths.standard)),
    keyConfig.rule('Home (Ctrl+Shift)',
                   keyConfig.input('home', ['control', 'shift']),
                   keyConfig.outputKey('up_arrow', ['command', 'shift']),
                   keyConfig.condition('unless', bundle.standard, file_paths.standard)),
    keyConfig.rule('End',
                   keyConfig.input('end'),
                   keyConfig.outputKey('right_arrow', ['command']),
                   keyConfig.condition('unless', bundle.standard, file_paths.standard)),
    keyConfig.rule('End (Ctrl)',
                   keyConfig.input('end', ['control']),
                   keyConfig.outputKey('down_arrow', ['command']),
                   keyConfig.condition('unless', bundle.standard, file_paths.standard)),
    keyConfig.rule('End (Shift)',
                   keyConfig.input('end', ['shift']),
                   keyConfig.outputKey('right_arrow', ['command', 'shift']),
                   keyConfig.condition('unless', bundle.standard, file_paths.standard)),
    keyConfig.rule('End (Ctrl+Shift)',
                   keyConfig.input('end', ['control', 'shift']),
                   keyConfig.outputKey('down_arrow', ['command', 'shift']),
                   keyConfig.condition('unless', bundle.standard, file_paths.standard)),
    keyConfig.rule('Left Arrow (Ctrl)',
                   keyConfig.input('left_arrow', ['control']),
                   keyConfig.outputKey('left_arrow', ['option']),
                   keyConfig.condition('unless', bundle.standard, file_paths.standard)),
    keyConfig.rule('Left Arrow (Ctrl+Shift)',
                   keyConfig.input('left_arrow', ['control', 'shift']),
                   keyConfig.outputKey('left_arrow', ['option', 'shift']),
                   keyConfig.condition('unless', bundle.standard, file_paths.standard)),
    keyConfig.rule('Right Arrow (Ctrl)',
                   keyConfig.input('right_arrow', ['control']),
                   keyConfig.outputKey('right_arrow', ['option']),
                   keyConfig.condition('unless', bundle.standard, file_paths.standard)),
    keyConfig.rule('Right Arrow (Ctrl+Shift)',
                   keyConfig.input('right_arrow', ['control', 'shift']),
                   keyConfig.outputKey('right_arrow', ['option', 'shift']),
                   keyConfig.condition('unless', bundle.standard, file_paths.standard)),
    // Command Keys
    keyConfig.rule('Backspace (Ctrl)',
                   keyConfig.input('delete_or_backspace', ['control']),
                   keyConfig.outputKey('delete_or_backspace', ['option']),
                   keyConfig.condition('unless', bundle.standard, file_paths.standard)),
    keyConfig.rule('Delete (Ctrl)',
                   keyConfig.input('delete_forward', ['control']),
                   keyConfig.outputKey('delete_forward', ['option']),
                   keyConfig.condition('unless', bundle.standard, file_paths.standard)),
    keyConfig.rule('Enter (Ctrl)',
                   keyConfig.input('return_or_enter', ['control']),
                   keyConfig.outputKey('return_or_enter', ['command']),
                   keyConfig.condition('unless', bundle.standard, file_paths.standard)),
    keyConfig.rule('Enter (Ctrl+Shift)',
                   keyConfig.input('return_or_enter', ['control', 'shift']),
                   keyConfig.outputKey('return_or_enter', ['command', 'shift']),
                   keyConfig.condition('unless', bundle.standard, file_paths.standard)),
    // Modifier Keys
    keyConfig.rule('Win [Open Spotlight]',
                   keyConfig.input('left_command', key_is_modifier=true),
                   [
                     keyConfig.outputKey('left_command', output_type='to'),
                     keyConfig.outputKey('spotlight', output_type='to_if_alone', key_code='apple_vendor_keyboard_key_code'),
                   ]),
    // Alphanumeric Keys
    keyConfig.rule('A (Ctrl)',
                   keyConfig.input('a', ['control']),
                   keyConfig.outputKey('a', ['command']),
                   keyConfig.condition('unless', bundle.standard, file_paths.standard)),
    keyConfig.rule('B (Ctrl)',
                   keyConfig.input('b', ['control']),
                   keyConfig.outputKey('b', ['command']),
                   keyConfig.condition('unless', bundle.standard, file_paths.standard)),
    keyConfig.rule('C (Ctrl)',
                   keyConfig.input('c', ['left_control']),
                   keyConfig.outputKey('c', ['command']),
                   keyConfig.condition('unless', bundle.standard, file_paths.standard)),
    keyConfig.rule('C (Ctrl+Shift) [Only Terminal Emulators]',
                   keyConfig.input('c', ['control', 'shift']),
                   keyConfig.outputKey('c', ['command']),
                   keyConfig.condition('if', bundle.terminalEmulators)),
    keyConfig.rule('F (Ctrl)',
                   keyConfig.input('f', ['control']),
                   keyConfig.outputKey('f', ['command']),
                   keyConfig.condition('unless', bundle.standard, file_paths.standard)),
    keyConfig.rule('H (Ctrl) [Only Web Browsers]',
                   keyConfig.input('h', ['control']),
                   keyConfig.outputKey('y', ['command']),
                   keyConfig.condition('if', bundle.webBrowsers)),
    keyConfig.rule('I (Ctrl)',
                   keyConfig.input('i', ['control']),
                   keyConfig.outputKey('i', ['command']),
                   keyConfig.condition('unless', bundle.standard, file_paths.standard)),
    keyConfig.rule('L (Ctrl) [Only Web Browsers]',
                   keyConfig.input('l', ['control']),
                   keyConfig.outputKey('l', ['command']),
                   keyConfig.condition('if', bundle.webBrowsers)),
    keyConfig.rule('L (Win) [Lock Screen]',
                   keyConfig.input('l', ['command']),
                   keyConfig.outputKey('q', ['control', 'command'])),
    keyConfig.rule('L (Win) [Sleep]',
                   keyConfig.input('l', ['command']),
                   keyConfig.outputKey('power', ['control', 'shift'])),
    keyConfig.rule('L (Alt+Ctrl) [Lock Screen]',
                   keyConfig.input('l', ['control', 'option']),
                   keyConfig.outputKey('q', ['control', 'command'])),
    keyConfig.rule('L (Alt+Ctrl) [Sleep]',
                   keyConfig.input('l', ['control', 'option']),
                   keyConfig.outputKey('power', ['control', 'shift'])),
    keyConfig.rule('N (Ctrl)',
                   keyConfig.input('n', ['control']),
                   keyConfig.outputKey('n', ['command']),
                   keyConfig.condition('unless', bundle.standard, file_paths.standard)),
    keyConfig.rule('O (Ctrl)',
                   keyConfig.input('o', ['control']),
                   keyConfig.outputKey('o', ['command']),
                   keyConfig.condition('unless', bundle.standard, file_paths.standard)),
    keyConfig.rule('P (Ctrl)',
                   keyConfig.input('p', ['control']),
                   keyConfig.outputKey('p', ['command']),
                   keyConfig.condition('unless', bundle.standard, file_paths.standard)),
    keyConfig.rule('R (Ctrl)',
                   keyConfig.input('r', ['control']),
                   keyConfig.outputKey('r', ['command']),
                   keyConfig.condition('unless', bundle.standard, file_paths.standard)),
    keyConfig.rule('S (Ctrl)',
                   keyConfig.input('s', ['control']),
                   keyConfig.outputKey('s', ['command']),
                   keyConfig.condition('unless', bundle.standard, file_paths.standard)),
    keyConfig.rule('T (Ctrl)',
                   keyConfig.input('t', ['control']),
                   keyConfig.outputKey('t', ['command']),
                   keyConfig.condition('unless', bundle.standard, file_paths.standard)),
    keyConfig.rule('U (Ctrl)',
                   keyConfig.input('u', ['control']),
                   keyConfig.outputKey('u', ['command']),
                   keyConfig.condition('unless', bundle.standard, file_paths.standard)),
    keyConfig.rule('V (Ctrl)',
                   keyConfig.input('v', ['control']),
                   keyConfig.outputKey('v', ['command']),
                   keyConfig.condition('unless', bundle.standard, file_paths.standard)),
    keyConfig.rule('V (Ctrl+Shift) [Only Terminal Emulators]',
                   keyConfig.input('v', ['control', 'shift']),
                   keyConfig.outputKey('v', ['command']),
                   keyConfig.condition('if', bundle.terminalEmulators)),
    keyConfig.rule('W (Ctrl)',
                   keyConfig.input('w', ['control']),
                   keyConfig.outputKey('w', ['command']),
                   keyConfig.condition('unless', bundle.standard, file_paths.standard)),
    keyConfig.rule('X (Ctrl)',
                   keyConfig.input('x', ['control']),
                   keyConfig.outputKey('x', ['command']),
                   keyConfig.condition('unless', bundle.standard, file_paths.standard)),
    keyConfig.rule('Y (Ctrl)',
                   keyConfig.input('y', ['control']),
                   keyConfig.outputKey('y', ['command']),
                   keyConfig.condition('unless', bundle.standard, file_paths.standard)),
    keyConfig.rule('Z (Ctrl)',
                   keyConfig.input('z', ['control']),
                   keyConfig.outputKey('z', ['command']),
                   keyConfig.condition('unless', bundle.standard, file_paths.standard)),
    keyConfig.rule('1 (Cmd) [Open first pinned Dock app (Finder); +IDEs and Terminal Emulators]',
                   keyConfig.input('1', ['command']),
                   keyConfig.outputShell('open -b com.apple.finder'),
                   keyConfig.condition('unless', bundle.hypervisors + bundle.remoteDesktops, file_paths.standard)),
    keyConfig.rule('2 (Cmd) [Open second pinned Dock app; +IDEs and Terminal Emulators]',
                   keyConfig.input('2', ['command']),
                   keyConfig.runDockedApp('0'),
                   keyConfig.condition('unless', bundle.hypervisors + bundle.remoteDesktops, file_paths.standard)),
    keyConfig.rule('3 (Cmd) [Open third pinned Dock app; +IDEs and Terminal Emulators]',
                   keyConfig.input('3', ['command']),
                   keyConfig.runDockedApp('1'),
                   keyConfig.condition('unless', bundle.hypervisors + bundle.remoteDesktops, file_paths.standard)),
    keyConfig.rule('4 (Cmd) [Open fourth pinned Dock app; +IDEs and Terminal Emulators]',
                   keyConfig.input('4', ['command']),
                   keyConfig.runDockedApp('2'),
                   keyConfig.condition('unless', bundle.hypervisors + bundle.remoteDesktops, file_paths.standard)),
    keyConfig.rule('5 (Cmd) [Open fifth pinned Dock app; +IDEs and Terminal Emulators]',
                   keyConfig.input('5', ['command']),
                   keyConfig.runDockedApp('3'),
                   keyConfig.condition('unless', bundle.hypervisors + bundle.remoteDesktops, file_paths.standard)),
    keyConfig.rule('6 (Cmd) [Open sixth pinned Dock app; +IDEs and Terminal Emulators]',
                   keyConfig.input('6', ['command']),
                   keyConfig.runDockedApp('4'),
                   keyConfig.condition('unless', bundle.hypervisors + bundle.remoteDesktops, file_paths.standard)),
    keyConfig.rule('7 (Cmd) [Open seventh pinned Dock app; +IDEs and Terminal Emulators]',
                   keyConfig.input('7', ['command']),
                   keyConfig.runDockedApp('5'),
                   keyConfig.condition('unless', bundle.hypervisors + bundle.remoteDesktops, file_paths.standard)),
    keyConfig.rule('8 (Cmd) [Open eighth pinned Dock app; +IDEs and Terminal Emulators]',
                   keyConfig.input('8', ['command']),
                   keyConfig.runDockedApp('6'),
                   keyConfig.condition('unless', bundle.hypervisors + bundle.remoteDesktops, file_paths.standard)),
    keyConfig.rule('9 (Cmd) [Open ninth pinned Dock app; +IDEs and Terminal Emulators]',
                   keyConfig.input('9', ['command']),
                   keyConfig.runDockedApp('7'),
                   keyConfig.condition('unless', bundle.hypervisors + bundle.remoteDesktops, file_paths.standard)),
    // Punctuation Keys
    keyConfig.rule('/ (Ctrl) [+Terminal Emulators]',
                   keyConfig.input('slash', ['control']),
                   keyConfig.outputKey('slash', ['command']),
                   keyConfig.condition('unless', bundle.hypervisors + bundle.ides + bundle.remoteDesktops, file_paths.remoteDesktops)),
    keyConfig.rule('Space (Ctrl)',
                   keyConfig.input('spacebar', ['control']),
                   keyConfig.outputKey('spacebar', ['command']),
                   keyConfig.condition('unless', bundle.standard, file_paths.standard)),
    keyConfig.rule('Tab (Alt) [+IDEs and Terminal Emulators]',
                   keyConfig.input('tab', ['option']),
                   keyConfig.outputKey('tab', ['command']),
                   keyConfig.condition('unless', bundle.hypervisors + bundle.remoteDesktops, file_paths.remoteDesktops)),
    // Function Keys
    keyConfig.rule('F1',
                   keyConfig.input('f1'),
                   keyConfig.outputKey('slash', ['command', 'shift']),
                   keyConfig.condition('unless', bundle.standard, file_paths.standard)),
    keyConfig.rule('F3',
                   keyConfig.input('f3'),
                   keyConfig.outputKey('g', ['command']),
                   keyConfig.condition('unless', bundle.standard, file_paths.standard)),
    keyConfig.rule('F4 (Alt) [+Terminal Emulators]',
                   keyConfig.input('f4', ['option']),
                   keyConfig.outputKey('q', ['command']),
                   keyConfig.condition('unless', bundle.hypervisors + bundle.ides + bundle.remoteDesktops, file_paths.remoteDesktops)),
    keyConfig.rule('F4 (Ctrl) [Only Chrome]',
                   keyConfig.input('f4', ['control']),
                   keyConfig.outputKey('w', ['command']),
                   keyConfig.condition('if', ['^com\\.google\\.Chrome$'])),
    keyConfig.rule('F5 [Only Chrome]',
                   keyConfig.input('f5'),
                   keyConfig.outputKey('r', ['command']),
                   keyConfig.condition('if', ['^com\\.google\\.Chrome$'])),
  ],
}

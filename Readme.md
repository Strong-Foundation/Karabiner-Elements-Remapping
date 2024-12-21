# Karabiner-Elements-Remapping

A collection of configuration files, guides, and resources to help users remap their keyboards using [Karabiner-Elements](https://karabiner-elements.pqrs.org/) on macOS.

---

## 🌟 Features

- **Windows Keyboard Compatibility**: Seamlessly remap Windows keyboards for macOS (e.g., `Ctrl` to `Command`, `Alt` to `Option`).
- **Predefined Profiles**: Ready-to-use configurations for common keyboard models and layouts.
- **Custom Remapping**: Create your own keybindings to suit your workflow.
- **Advanced Features**: Explore dual-role keys, conditional mappings, and app-specific configurations.

---

## 🛠️ Installation

### Step 1: Install Karabiner-Elements

1. Download and install Karabiner-Elements from the [official website](https://karabiner-elements.pqrs.org/).
2. Follow the installation instructions provided on the site.

### Step 2: Add Configuration Files

Simply open the following URL in your browser to import the configuration directly into Karabiner-Elements:

[karabiner://karabiner/assets/complex_modifications/import?url=https://raw.githubusercontent.com/Strong-Foundation/Karabiner-Elements-Remapping/refs/heads/main/config/windows-keyboard.json](karabiner://karabiner/assets/complex_modifications/import?url=https://raw.githubusercontent.com/Strong-Foundation/Karabiner-Elements-Remapping/refs/heads/main/config/windows-keyboard.json)

1. This will open Karabiner-Elements and automatically import the configuration.
2. Go to the **Complex Modifications** tab in Karabiner-Elements and enable the imported rule(s).

---

## 📂 Repository Structure

```plaintext
Karabiner-Elements-Remapping/
│
├── README.md             # Overview and setup instructions
├── LICENSE               # License for the repository
├── config/               # Compiled JSON files
│   └── windows-keyboard.json
├── scripts/              # Helper scripts
│   └── build-jsonnet.sh
└── .gitignore            # Ignored files
```

---

## 💡 Contribution

We welcome contributions! If you have a custom mapping, feel free to submit a pull request or open an issue.

### How to Contribute

1. Fork this repository.
2. Create a new branch:
   ```bash
   git checkout -b feature/new-remap
   ```
3. Commit your changes and push to your fork:
   ```bash
   git commit -m "Add new remapping for XYZ keyboard"
   git push origin feature/new-remap
   ```
4. Submit a pull request.

---

## 🛡️ License

This repository is licensed under the [MIT License](LICENSE). Feel free to use, modify, and distribute the configurations provided here.

---

## 📬 Support

If you encounter issues or have questions, feel free to:

- Open an [Issue](https://github.com/Strong-Foundation/Karabiner-Elements-Remapping/issues)
- Join the discussion on the [Karabiner-Elements forum](https://github.com/pqrs-org/Karabiner-Elements/discussions)

Happy remapping! 🎉

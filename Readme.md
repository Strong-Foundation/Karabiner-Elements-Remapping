# Karabiner-Elements-Remapping

A collection of configuration files, guides, and resources to help users remap their keyboards using [Karabiner-Elements](https://karabiner-elements.pqrs.org/) on macOS.

---

## 🌟 Features

- **Windows Keyboard Compatibility**: Easily remap Windows keyboards for macOS (e.g., `Ctrl` to `Command`, `Alt` to `Option`).
- **Predefined Profiles**: Ready-to-use configurations for common keyboard models and layouts.
- **Custom Remapping**: Create your own keybindings to fit your personal workflow.
- **Advanced Features**: Unlock dual-role keys, conditional mappings, and app-specific configurations.

---

## 🛠️ Installation

### Step 1: Install Karabiner-Elements

1. Download and install Karabiner-Elements from the [official website](https://karabiner-elements.pqrs.org/).
2. Follow the installation instructions provided on the site.

### Step 2: Import Configuration Files

1. Open the following URL in your browser to automatically import the configuration into Karabiner-Elements:

   ```
   karabiner://karabiner/assets/complex_modifications/import?url=https://raw.githubusercontent.com/Strong-Foundation/Karabiner-Elements-Remapping/main/config/windows-keyboard.json
   ```

2. This will launch Karabiner-Elements and directly import the `windows-keyboard.json` configuration file into your local system.
3. Navigate to the **Complex Modifications** tab within Karabiner-Elements and enable the imported rule(s).

---

## 📂 Repository Structure

```plaintext
Karabiner-Elements-Remapping/
│
├── .github/              # GitHub Actions and workflows
│   └── workflows
│       └── build-jsonnet.yml # Workflow for automating the build process
├── .gitignore            # Files to be ignored by Git
├── License.md            # License for the repository
├── Readme.md             # Overview and setup instructions
├── config/               # Compiled JSON configuration files
│   └── windows-keyboard.json  # The file Karabiner-Elements will import to the local system
├── jsonnet/              # JSONNET files for custom configurations
│   └── windows-mac-remap.jsonnet
└── scripts/              # Helper scripts
    └── build-jsonnet.sh  # Script to generate JSON configuration from JSONNET
```

---

## 💡 Contribution

We welcome contributions! If you have custom remaps or enhancements, feel free to submit a pull request or open an issue.

### How to Contribute

1. **Fork** this repository.
2. **Create a new branch** for your changes:
   ```bash
   git checkout -b feature/new-remap
   ```
3. **Commit** your changes and **push** them to your fork:
   ```bash
   git commit -m "Add new remapping for XYZ keyboard"
   git push origin feature/new-remap
   ```
4. **Submit a pull request** to merge your changes.

---

## 🛡️ License

This repository is licensed under the [MIT License](LICENSE). Feel free to use, modify, and distribute the configurations.

---

## 📬 Support

For assistance or questions, you can:

- Open an [Issue](https://github.com/Strong-Foundation/Karabiner-Elements-Remapping/issues)
- Join the discussion on the [Karabiner-Elements forum](https://github.com/pqrs-org/Karabiner-Elements/discussions)

Happy remapping! 🎉

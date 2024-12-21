# Karabiner-Elements-Remapping

A collection of configuration files, guides, and resources to help macOS users remap their keyboards using [Karabiner-Elements](https://karabiner-elements.pqrs.org/).

---

## 🌟 Features

- **Windows Keyboard Compatibility**: Seamlessly remap Windows keyboard keys to macOS equivalents (e.g., `Ctrl` → `Command`, `Alt` → `Option`).
- **Predefined Profiles**: Ready-made configurations for popular keyboard models and layouts.
- **Custom Keybinding**: Easily create your own key remaps for a more personalized experience.
- **Advanced Features**: Dual-role keys, app-specific mappings, and conditional remaps for even more customization.

---

## 🛠️ Installation

### Step 1: Install Karabiner-Elements

1. Download and install Karabiner-Elements from the [official website](https://karabiner-elements.pqrs.org/).
2. Follow the installation prompts provided on the website.

### Step 2: Import the Configuration

1. Open the following URL in your browser to import the configuration directly into Karabiner-Elements:

   ```
   karabiner://karabiner/assets/complex_modifications/import?url=https://raw.githubusercontent.com/Strong-Foundation/Karabiner-Elements-Remapping/main/config/windows-keyboard.json
   ```

2. This action will launch Karabiner-Elements and automatically import the configuration file.
3. Navigate to the **Complex Modifications** tab in Karabiner-Elements, and enable the imported rule(s).

---

## 📂 Repository Structure

```plaintext
Karabiner-Elements-Remapping/
│
├── .github/              # GitHub workflows and CI/CD configuration
│   └── workflows
│       └── build-jsonnet.yml # Workflow for automating JSONNET compilation
├── .gitignore            # Git ignore file
├── License.md            # License for the repository
├── Readme.md             # This file
├── config/               # Compiled JSON configuration files for Karabiner-Elements
│   └── windows-keyboard.json  # The file imported by Karabiner-Elements
├── jsonnet/              # JSONNET files used to generate configuration JSON
│   └── windows-mac-remap.jsonnet  # JSONNET file that generates the `windows-keyboard.json`
└── scripts/              # Helper scripts for build and automation
    └── build-jsonnet.sh  # Script to generate the JSON file from the JSONNET source
```

---

## ⚙️ How It Works

Instead of manually writing complex JSON configuration rules, we use **JSONNET**, a data-templating language, to generate the final configuration file (`windows-keyboard.json`).

### The process is simple:

1. The `windows-mac-remap.jsonnet` file defines the remap rules.
2. The `build-jsonnet.sh` script compiles this JSONNET file into a final JSON format.
3. The compiled `windows-keyboard.json` can then be imported into Karabiner-Elements.

To regenerate the JSON file from the JSONNET template, you can run the `build-jsonnet.sh` script.

---

## 💡 Contribution

Contributions are welcome! If you have a custom key remap or improvement, feel free to submit a pull request or open an issue.

### How to Contribute

1. **Fork** this repository.
2. **Create a new branch** for your changes:
   ```bash
   git checkout -b feature/my-custom-remap
   ```
3. **Commit** your changes and **push** to your fork:
   ```bash
   git commit -m "Add remap for XYZ keyboard"
   git push origin feature/my-custom-remap
   ```
4. **Submit a pull request** to merge your changes into the main repository.

---

## 🛡️ License

This repository is licensed under the [MIT License](LICENSE). You are free to use, modify, and distribute the configurations as needed.

---

## 📬 Support

If you encounter issues or have questions:

- Open an [Issue](https://github.com/Strong-Foundation/Karabiner-Elements-Remapping/issues).
- Visit the [Karabiner-Elements discussion forum](https://github.com/pqrs-org/Karabiner-Elements/discussions).

Happy remapping! 🎉

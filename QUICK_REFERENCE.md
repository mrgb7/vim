# 🚀 Neovim Quick Reference - Enhanced Configuration

## 🎯 Supported File Types & Language Servers

| File Type | Extensions | Language Server | Features |
|-----------|------------|----------------|----------|
| **Go Templates** | `.gotmpl`, `.tmpl`, `.tpl` | gopls | Syntax highlighting, formatting, completion |
| **Helm Charts** | `Chart.yaml`, `values.yaml`, `templates/*.yaml` | helm_ls + yamlls | Template validation, schema support |
| **YAML** | `.yaml`, `.yml` | yamlls | Kubernetes schema validation, formatting |
| **CUE** | `.cue` | cuelsp | Schema validation, formatting, completion |
| **Go** | `.go` | gopls | Full Go support with template extensions |

## ⌨️ Essential Keybindings

### Helm Development
```
<leader>hv  - Validate Helm template
<leader>hl  - Lint Helm chart  
<leader>hd  - Update dependencies
<leader>ht  - Test Helm release
```

### LSP Navigation
```
gd          - Go to definition
gr          - Find references
K           - Hover documentation
<leader>ca  - Code actions
<leader>rn  - Rename symbol
[d / ]d     - Previous/Next diagnostic
```

### Telescope Integration
```
<leader>gd  - Go to definition (Telescope)
<leader>gr  - Find references (Telescope)
<leader>gs  - Document symbols
<leader>gw  - Workspace symbols
```

## 🧪 Quick Testing

```bash
# Test your configuration
cd ~/.config/nvim
./comprehensive_test.sh

# Expected: All 12 tests should pass ✅
```

## 🔧 Auto-features

- **Format on Save**: Enabled for all supported file types
- **Error Detection**: Real-time diagnostics
- **Auto-completion**: Context-aware suggestions
- **Import Organization**: Automatic for Go files

## 📁 Configuration Structure

```
~/.config/nvim/
├── lua/
│   ├── config.lua              # LSP configurations
│   ├── plugins.lua             # Plugin management
│   ├── helm_gotmpl_config.lua  # Helm/template settings
│   └── options.lua             # Enhanced options
├── comprehensive_test.sh       # Testing script
└── test_files/                # Sample files
```

## 🚨 Troubleshooting

### Language Server Not Starting?
```bash
# Check Mason installations
:Mason

# Restart LSP
:LspRestart
```

### Syntax Highlighting Issues?
```bash
# Check Treesitter
:TSInstall go yaml gotmpl helm cue

# Update parsers
:TSUpdate
```

### PackerSync Issues?
```bash
# Clean and reinstall
:PackerClean
:PackerSync
```

---

*Quick Reference | Configuration Complete ✅*
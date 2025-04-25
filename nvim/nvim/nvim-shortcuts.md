# Neovim Shortcuts Cheat Sheet

## Basic Navigation

### Word Navigation (Works in normal and insert mode)
- `Option + Left` or `Option + h` - Jump backward by word
- `Option + Right` or `Option + l` - Jump forward by word
- `H` - Jump to start of line
- `L` - Jump to end of line

### Vertical Navigation
- `Ctrl + d` - Move half page down (centered)
- `Ctrl + u` - Move half page up (centered)
- `Ctrl + j` - Move down 5 lines
- `Ctrl + k` - Move up 5 lines
- `Ctrl + e` - Smooth scroll down 3 lines
- `Ctrl + y` - Smooth scroll up 3 lines
- `gg` - Jump to start of file (centered)
- `G` - Jump to end of file (centered)
- `}` - Jump to next paragraph
- `{` - Jump to previous paragraph
- `]]` - Jump to next function
- `[[` - Jump to previous function

## File Management

### Buffer Operations (Files)
- `Space + x` - Close current file
- `Space + X` - Force close current file (without saving)
- `Space + w` - Save current file
- `Tab` - Go to next file
- `Shift + Tab` - Go to previous file
- `Space + fb` - Show list of all open files (Telescope)

### File Explorer (NvimTree)
- `Space + e` - Toggle file explorer
- `Space + E` - Focus file explorer

## Code Navigation and LSP Features

### Quick Navigation
- `gd` - Go to definition
- `gD` - Go to declaration
- `gi` - Go to implementation
- `gr` - Find all references
- `K` - Show documentation hover
- `Ctrl + k` - Show function signature help

### Telescope-Enhanced Navigation
- `Space + gd` - Find definitions
- `Space + gr` - Find references
- `Space + gi` - Find implementations
- `Space + gs` - Browse symbols in current file
- `Space + gw` - Browse symbols in workspace

### File Finding (Telescope)
- `Space + ff` - Find files
- `Space + fg` - Live grep (search in all files)
- `Space + fb` - Find in open buffers
- `Space + fh` - Find in help tags
- `Space + gf` - Find in git files

## Error Navigation and Code Actions

### Error Navigation
- `[d` - Go to previous error/warning
- `]d` - Go to next error/warning
- `Space + e` - Show error message in floating window
- `Space + q` - Open error list

### Code Actions
- `Space + rn` - Rename symbol
- `Space + ca` - Code actions menu

## Search Navigation
- `n` - Next search result (centered)
- `N` - Previous search result (centered)

## Auto-Completion and Formatting

### Auto-Completion
- Auto-pairs enabled for:
  - `{` → `}`
  - `(` → `)`
  - `[` → `]`
  - `'` → `'`
  - `"` → `"`

### Formatting
- Auto-format on save enabled for:
  - Go files
  - Python files
  - Bash files

## Additional Features

### Go-Specific Features
- Auto-import on save
- Unused variable detection
- Type information on hover
- Auto-completion for unimported packages

### General IDE Features
- Syntax highlighting
- Error highlighting
- Git integration
- File icons
- Indent guides

## Theme and UI
- Tokyo Night theme
- Custom status line with file information
- Error icons in the gutter
- Indent guides
- Line numbers enabled
- Relative line numbers for easy navigation

## Notes
- `Space` is the leader key
- Most commands work in normal mode unless specified
- LSP features are language-specific and require the language server to be installed
- All centered movements (with `zz`) keep your cursor in the middle of the screen 

## Selection and Visual Mode
### Enter Visual Mode
- `v` - Start character-wise visual mode
- `V` - Start line-wise visual mode
- `Ctrl + v` - Start block-wise visual mode (vertical selection)

### Visual Mode Navigation
- Use all normal mode navigation commands (`hjkl`, `w`, `b`, etc.)
- `o` - Jump to other end of selection
- `O` - Jump to other corner of block selection

### Visual Mode Operations
- `d` - Delete selected text
- `y` - Yank (copy) selected text
- `p` - Paste over selected text
- `>` - Indent selected lines
- `<` - Unindent selected lines
- `=` - Auto-indent selected lines

## Code Commenting
### Single Line
- `gcc` - Toggle line comment
- `gbc` - Toggle block comment

### Multiple Lines
- `gc` + motion - Toggle line comment for motion
- `gb` + motion - Toggle block comment for motion

### Visual Mode Commenting
- Select text with `v`, `V`, or `Ctrl + v`, then:
  - `gc` - Toggle line comment for selection
  - `gb` - Toggle block comment for selection

## Additional Operations
### Delete Operations
- `dd` - Delete current line
- `D` - Delete from cursor to end of line
- Select text in visual mode + `d` - Delete selection

### Copy/Paste Operations
- `yy` - Copy current line
- `Y` - Copy from cursor to end of line
- Select text in visual mode + `y` - Copy selection
- `p` - Paste after cursor
- `P` - Paste before cursor 
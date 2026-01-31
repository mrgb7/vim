# GitHub Copilot Setup for Neovim

This guide explains how to set up GitHub Copilot in your Neovim configuration.

## Installation

The Copilot plugin is already configured in your Neovim setup. On first launch, Lazy.nvim will automatically install it.

## Authentication

### Option 1: Browser-based Authentication (Recommended)

When you first use Copilot in Neovim, it will prompt you to authenticate:

1. Open Neovim and any file
2. Start typing or trigger completion with `<C-Space>`
3. You'll see a prompt with a device code and URL
4. Copy the device code
5. Visit the URL shown in your terminal (opens in browser)
6. Log in with your GitHub account
7. Paste the device code
8. Confirm authorization
9. Return to Neovim - authentication is complete

### Option 2: Using GitHub Token

If you prefer to use an access token directly:

1. Generate a GitHub Personal Access Token:
   - Go to https://github.com/settings/tokens
   - Create new token with `copilot` scope
   - Copy the token

2. Authenticate in Neovim:
   ```vim
   :Copilot auth
   ```
   - Choose "paste token"
   - Paste your token when prompted

## Keybindings

| Keybinding | Action |
|-----------|--------|
| `<C-j>` | Accept Copilot suggestion |
| `<Tab>` | Accept suggestion (alternative) |
| `<C-l>` | Show next suggestion inline |
| `<C-k>` | Show previous suggestion |
| `<C-n>` | Cycle to next suggestion |
| `<C-d>` | Dismiss suggestion |

## How to Use

### Get Suggestions

Copilot provides suggestions in two ways:

1. **Inline Suggestions** - Grey text appears as you type
   - Accept with `<C-j>` or `<Tab>`
   - Navigate with `<C-k>` / `<C-n>`
   - Dismiss with `<C-d>`

2. **Manual Trigger**
   - Press `<C-l>` to manually request suggestions
   - Press `<C-Space>` to open completion menu

### Example Workflow

```go
// Type a function signature
func ProcessIncident(

// Copilot suggests the rest
func ProcessIncident(ctx context.Context, incident *domain.Incident) error {
    // More suggestions available here
    return nil
}
```

Just start typing and watch for grey suggestion text. Accept with `<C-j>` or keep typing to dismiss.

## Troubleshooting

### "Copilot is not available"

1. Verify Node.js is installed:
   ```bash
   which node
   ```

2. Check authentication status:
   ```vim
   :Copilot status
   ```

3. Force re-authenticate:
   ```vim
   :Copilot auth
   ```

### Suggestions not appearing

1. Try manually triggering:
   ```vim
   <C-l>
   ```

2. Restart Neovim

3. Check internet connection

### Integration with nvim-cmp

Copilot suggestions work alongside your LSP completions. You may see:
- LSP completions in the menu
- Copilot inline suggestions (grey text)

These don't conflict - use whichever feels right:
- LSP menu: `<C-Space>` then arrow keys + `<CR>`
- Copilot inline: Just press `<C-j>` to accept

## Commands

```vim
:Copilot auth              " Authenticate or re-authenticate
:Copilot status            " Check authentication status
:Copilot enable            " Enable Copilot
:Copilot disable           " Disable Copilot
:Copilot version           " Show Copilot version
```

## Performance Notes

- Copilot runs asynchronously, so it won't block your editor
- First suggestion request may take 1-2 seconds
- Subsequent suggestions are typically instant
- Works best with 100+ characters of context (after that line/function)

## Privacy

- Copilot only sends code context when you're idle for a moment
- Suggestions are cached locally
- No code is permanently stored by GitHub
- You can view telemetry settings in `~/.config/github-copilot`

## Disabling Copilot

If you want to disable Copilot temporarily:

```vim
:Copilot disable
```

Or for a specific file:
```vim
:Copilot disable
" Edit your file
:Copilot enable
```

## Configuration

Additional configuration is in `~/.config/nvim/lua/plugins/copilot.lua`. Key settings:

- `copilot_no_tab_map = true` - Prevents Tab from conflicting with cmp
- `copilot_request_timeout = 5` - Request timeout in seconds
- Tab is mapped to accept Copilot suggestions

## Reference

- [Copilot.vim GitHub](https://github.com/github/copilot.vim)
- [Copilot Documentation](https://docs.github.com/en/copilot)

# Neovim Keymaps

This document lists all the custom keymaps defined in the Neovim configuration.

## General Keymaps

| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| I | `jk` | `<ESC>` | Exit insert mode with jk |
| N | `<leader>nh` | `:nohl<CR>` | Clear search highlights |
| N | `<leader>+` | `<C-a>` | Increment number |
| N | `<leader>-` | `<C-x>` | Decrement number |
| N | `<leader>gf` | `vim.lsp.buf.format` | Format buffer |

## Window Management

| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| N | `<leader>sv` | `<C-w>v` | Split window vertically |
| N | `<leader>sh` | `<C-w>s` | Split window horizontally |
| N | `<leader>se` | `<C-w>=` | Make splits equal size |
| N | `<leader>sx` | `<cmd>close<CR>` | Close current split |
| N | `<leader>sm` | `<cmd>MaximizerToggle<CR>` | Maximize/minimize a split |
| N | `<C-h>` | `<cmd>TmuxNavigateLeft<cr>` | Navigate left (tmux/vim) |
| N | `<C-j>` | `<cmd>TmuxNavigateDown<cr>` | Navigate down (tmux/vim) |
| N | `<C-k>` | `<cmd>TmuxNavigateUp<cr>` | Navigate up (tmux/vim) |
| N | `<C-l>` | `<cmd>TmuxNavigateRight<cr>` | Navigate right (tmux/vim) |

## Tab Management

| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| N | `<leader>to` | `<cmd>tabnew<CR>` | Open new tab |
| N | `<leader>tx` | `<cmd>tabclose<CR>` | Close current tab |
| N | `<leader>tn` | `<cmd>tabn<CR>` | Go to next tab |
| N | `<leader>tp` | `<cmd>tabp<CR>` | Go to previous tab |
| N | `<leader>tf` | `<cmd>tabnew %<CR>` | Open current buffer in new tab |

## Telescope (Fuzzy Finder)

| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| N | `<leader>ff` | `<cmd>Telescope find_files<cr>` | Fuzzy find files in cwd |
| N | `<leader>fg` | `<cmd>Telescope live_grep<cr>` | Live grep in cwd |
| N | `<leader>fr` | `<cmd>Telescope oldfiles<cr>` | Fuzzy find recent files |
| N | `<leader>fs` | `<cmd>Telescope live_grep<cr>` | Find string in cwd |
| N | `<leader>fc` | `<cmd>Telescope grep_string<cr>` | Find string under cursor in cwd |
| N | `<leader>ft` | `<cmd>TodoTelescope<cr>` | Find todos |

## LSP (Language Server Protocol)

| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| N | `gR` | `<cmd>Telescope lsp_references<CR>` | Show LSP references |
| N | `gD` | `vim.lsp.buf.declaration` | Go to declaration |
| N | `gd` | `<cmd>Telescope lsp_definitions<CR>` | Show LSP definitions |
| N | `gi` | `<cmd>Telescope lsp_implementations<CR>` | Show LSP implementations |
| N | `gt` | `<cmd>Telescope lsp_type_definitions<CR>` | Show LSP type definitions |
| N, V | `<leader>ca` | `vim.lsp.buf.code_action` | See available code actions |
| N | `<leader>rn` | `vim.lsp.buf.rename` | Smart rename |
| N | `<leader>D` | `<cmd>Telescope diagnostics bufnr=0<CR>` | Show buffer diagnostics |
| N | `<leader>d` | `vim.diagnostic.open_float` | Show line diagnostics |
| N | `[d` | `vim.diagnostic.goto_prev` | Go to previous diagnostic |
| N | `]d` | `vim.diagnostic.goto_next` | Go to next diagnostic |
| N | `K` | `vim.lsp.buf.hover` | Show documentation for what is under cursor |
| N | `<leader>rs` | `:LspRestart<CR>` | Mapping to restart lsp if necessary |

## Git Operations (Gitsigns & LazyGit)

| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| N | `<leader>lg` | `<cmd>LazyGit<cr>` | Open LazyGit |
| N | `]c` | `gs.next_hunk()` | Next Hunk |
| N | `[c` | `gs.prev_hunk()` | Prev Hunk |
| N | `<leader>gs` | `gs.stage_hunk` | Stage Hunk |
| N | `<leader>gr` | `gs.reset_hunk` | Reset Hunk |
| N | `<leader>gp` | `gs.preview_hunk` | Preview Hunk |
| N | `<leader>gb` | `gs.blame_line({ full = true })` | Blame Line |

## Harpoon

| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| N | `<leader>ha` | `harpoon:list():add()` | Harpoon Add File |
| N | `<leader>hl` | `harpoon.ui:toggle_quick_menu()` | Harpoon List |
| N | `<leader>1` | `harpoon:list():select(1)` | Select Harpoon 1 |
| N | `<leader>2` | `harpoon:list():select(2)` | Select Harpoon 2 |
| N | `<leader>3` | `harpoon:list():select(3)` | Select Harpoon 3 |
| N | `<leader>4` | `harpoon:list():select(4)` | Select Harpoon 4 |

## Trouble (Diagnostics & Lists)

| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| N | `<leader>xx` | `<cmd>Trouble diagnostics toggle<cr>` | Diagnostics (Trouble) |
| N | `<leader>xX` | `<cmd>Trouble diagnostics toggle filter.buf=0<cr>` | Buffer Diagnostics (Trouble) |
| N | `<leader>cs` | `<cmd>Trouble symbols toggle focus=false<cr>` | Symbols (Trouble) |
| N | `<leader>cl` | `<cmd>Trouble lsp toggle focus=false win.position=right<cr>` | LSP Definitions / references / ... (Trouble) |
| N | `<leader>xL` | `<cmd>Trouble loclist toggle<cr>` | Location List (Trouble) |
| N | `<leader>xQ` | `<cmd>Trouble qflist toggle<cr>` | Quickfix List (Trouble) |

## DAP (Debugger)

| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| N | `<leader>db` | `dap.toggle_breakpoint` | Toggle Breakpoint |
| N | `<leader>dc` | `dap.continue` | Continue |
| N | `<leader>di` | `dap.step_into` | Step Into |
| N | `<leader>do` | `dap.step_over` | Step Over |

## File Explorer (nvim-tree)

| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| N | `<leader>ee` | `<CMD>NvimTreeToggle<CR>` | Toggle file explorer |
| N | `<leader>ef` | `<CMD>NvimTreeFindFileToggle<CR>` | Toggle file explorer on current file |
| N | `<leader>ec` | `<CMD>NvimTreeCollapse<CR>` | Collapse file explorer |
| N | `<leader>er` | `<CMD>NvimTreeRefresh<CR>` | Refresh file explorer |

## Copilot

| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| I | `<Tab>` | `copilot#Accept()` | Accept Copilot suggestion |
| I | `<M-]>` | `<Plug>(copilot-next)` | Next Copilot suggestion |
| I | `<M-[>` | `<Plug>(copilot-previous)` | Previous Copilot suggestion |
| I | `<C-]>` | `<Plug>(copilot-dismiss)` | Dismiss Copilot suggestion |

## Autocompletion (nvim-cmp)

| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| I | `<C-k>` | `cmp.mapping.select_prev_item()` | Previous suggestion |
| I | `<C-j>` | `cmp.mapping.select_next_item()` | Next suggestion |
| I | `<C-b>` | `cmp.mapping.scroll_docs(-4)` | Scroll docs up |
| I | `<C-f>` | `cmp.mapping.scroll_docs(4)` | Scroll docs down |
| I | `<C-Space>` | `cmp.mapping.complete()` | Show completion suggestions |
| I | `<C-e>` | `cmp.mapping.abort()` | Close completion window |
| I | `<CR>` | `cmp.mapping.confirm()` | Confirm selection |

## Terminal (ToggleTerm)

| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| T | `<esc>` | `<C-\><C-n>` | Exit terminal mode |
| T | `jk` | `<C-\><C-n>` | Exit terminal mode |
| T | `<C-h>` | `<Cmd>wincmd h<CR>` | Move to left window |
| T | `<C-j>` | `<Cmd>wincmd j<CR>` | Move to bottom window |
| T | `<C-k>` | `<Cmd>wincmd k<CR>` | Move to top window |
| T | `<C-l>` | `<Cmd>wincmd l<CR>` | Move to right window |
| T | `<C-w>` | `<C-\><C-n><C-w>` | Window command |

## Session Management

| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| N | `<leader>wr` | `<cmd>SessionRestore<CR>` | Restore session for cwd |
| N | `<leader>ws` | `<cmd>SessionSave<CR>` | Save session for cwd |

## Commenting (Comment.nvim)

| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| N | `gcc` | `comment line` | Toggle comment on current line |
| V | `gc` | `comment selection` | Toggle comment on selection |
| N | `gbc` | `block comment line` | Toggle block comment on current line |
| V | `gb` | `block comment selection` | Toggle block comment on selection |

## Todo Comments

| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| N | `]t` | `next todo` | Next todo comment |
| N | `[t` | `prev todo` | Previous todo comment |

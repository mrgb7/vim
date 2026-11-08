# Neovim config

Built from scratch on lazy.nvim (plugin manager only, no distribution). Works on
Neovim 0.11.4+ and 0.12, using the native `vim.lsp.config` / `vim.lsp.enable` API.

## Layout

```
init.lua                 core -> langs.setup() -> lazy
lua/ragab/
  util.lua               shared helpers (augroup, map, toggle, run_in_terminal)
  lsp.lua                LspAttach keymaps + enables every server from langs/
  core/                  plugin-independent editor setup
    options.lua  keymaps.lua  autocmds.lua  diagnostics.lua  lazy.lua
  langs/                 ONE FILE PER LANGUAGE (the only place to touch for a language)
    init.lua             registry + list of enabled languages
    go.lua c.lua shell.lua yaml.lua json.lua python.lua docker.lua
    terraform.lua proto.lua toml.lua lua.lua markdown.lua
  plugins/               lazy.nvim specs grouped by concern
    colorscheme  completion  debug  editor  explorer  format  git
    langs  lint  lsp  terminal  treesitter  ui
after/queries/go/highlights.scm   extra Go captures (err, exported, tags, go/defer)
```

Each `langs/<name>.lua` declares its parsers, LSP servers, formatters, linters,
Mason tools, indentation, filetype detection, buffer-local keymaps and extra
plugins. The plugin specs read those tables, so **adding a language = one new
file + one line in `langs/init.lua`**. Field reference: top of `langs/init.lua`.

## Language behaviour

| Language | LSP | On save | Lint |
|---|---|---|---|
| Go | gopls (no placeholders, unimported completion) | goimports (add/remove imports) + gofumpt | golangci-lint (inside a module) |
| C / C++ | clangd (no arg placeholders, no header insertion) | clang-format **only if** a `.clang-format` exists | clang-tidy via clangd |
| CMake / Make | neocmakelsp | cmake-format | — |
| Bash / sh / zsh | bashls (+shellcheck) | shfmt `-i 2 -ci -bn` | shellcheck |
| YAML | yamlls + SchemaStore + k8s schemas | prettier | yamllint (actionlint for workflows) |
| Helm templates | helm_ls (completion only, lint off) | trim whitespace only | **none** |
| Helm values | helm_ls | prettier | none |
| JSON | jsonls + SchemaStore | prettier | — |
| Python | basedpyright + ruff | ruff fix (unused imports) + isort + format | ruff |
| Docker / Terraform / Proto / TOML / Lua / Markdown | yes | yes | hadolint / tflint / markdownlint |

Everything is installed by Mason on start (`:Mason` to inspect).

## Keymaps

Leader `<Space>`, local leader `\`. Press `<Space>` and wait for which-key.

### Core
| Key | Action |
|---|---|
| `jk` (insert) | Exit insert |
| `<C-s>` | Save |
| `<C-d>` / `<C-u>` | Half page down / up, centred |
| `u` / `<C-r>` / `y` | Undo / redo / yank (system clipboard) |
| `J` / `K` (visual) | Move selection |
| `<leader>p` (visual) | Paste without yanking |
| `s` / `S` | Flash jump / treesitter select |
| `ys` `ds` `cs` | Surround add / delete / change |
| `gc` / `gcc` | Comment (built in) |
| `an` / `in` (visual, 0.12) | Expand / shrink treesitter selection |

### Find, explorer, terminal
| Key | Action |
|---|---|
| `<leader>ff` / `<leader>fg` | Telescope files / live grep |
| `<leader>fc` `fb` `fr` `fh` `fk` `f/` `f.` `fG` `ft` | Word, buffers, recent, help, keymaps, in-buffer, resume, git status, TODOs |
| `<leader>ee` `ef` `ec` `er` | Tree toggle / reveal / collapse / refresh |
| in tree: `a` `d` `r` `x` `c` `p` `g?` | Create (end with `/` for dir) / delete / rename / cut / copy / paste / help |
| `<leader>tt` / `tv` / `ts` / `<C-\>` | Float / vertical / select / toggle terminal |
| `<leader>tl` | Send line / selection to terminal |

### LSP & diagnostics
| Key | Action |
|---|---|
| `gd` `gD` `gi` `gt` `gR` `K` | Definition, declaration, impl, type, references, hover |
| `<leader>ca` / `<leader>rn` / `<leader>rs` | Code action / rename / restart LSP |
| `<leader>fo` / `<leader>fS` | Document / workspace symbols |
| `<leader>ci` / `<leader>co` | Incoming / outgoing calls |
| `<leader>cf` / `<leader>uf` | Format / toggle format on save |
| `<leader>cm` | `:make` into quickfix |
| `gl`, `]d` `[d`, `]e` `[e` | Line diagnostics, next/prev diagnostic, next/prev error |
| `<leader>xx` `xX` `xQ` `xL` `cs` `cl` | Trouble panels |
| `<leader>ll` | Run linters now |
| `<leader>ih` `ud` `ul` `uw` `us` `uc` `ub` | Toggle inlay hints, diagnostics, full messages, wrap, spell, sticky context, light/dark |

### Go (`\`, Go buffers)
`\r` run · `\b` build · `\t` test func · `\T` test file · `\p` test pkg · `\g` generate test ·
`\c` coverage · `\a` test/impl · `\e` if err · `\j`/`\y` json/yaml tags · `\J` remove json tags ·
`\i` impl interface · `\f` fill struct · `\m` mod tidy · `\l` golangci-lint · `\v` run code lens

### C / C++ (`\`)
`\h` source/header · `\s` symbol info · `\t` type hierarchy · `\a` AST · `\b` build (`make`, errors to quickfix)

### Shell (`\`)
`\r` run file in terminal · `\x` chmod +x

### Debug (delve for Go, codelldb for C)
`<leader>db`/`dB` breakpoint/conditional · `dc` continue · `di` `do` `dO` step in/over/out ·
`dC` run to cursor · `dl` last · `dt`/`dT` Go test · `du` UI · `de` eval · `dr` REPL · `dq` stop

### Git
`]c`/`[c` hunks · `<leader>gs`/`gr` stage/reset hunk · `gS`/`gR` buffer · `gp` preview ·
`gb`/`gB` blame · `gD` diff · `ih` hunk object

Fugitive: `<leader>gg` status · `gc` commit · `gP` push · `gl` log · `gh` file history (quickfix) · `gv` diff split.
In the status window: `s`/`u` stage/unstage · `=` inline diff · `cc` commit · `ca` amend · `X` discard · `g?` help

### Windows, tabs, buffers, sessions, harpoon
`<leader>sv` `sh` `se` `sx` `sm` split / equalize / close / maximize · `<C-h/j/k/l>` move (tmux aware) ·
`<leader>to` `tx` `tn` `tp` `tf` tabs · `<S-h>`/`<S-l>`/`<leader>bd` buffers ·
`<leader>wr` `ws` `wf` sessions · `<leader>ha` `hl` `1-4` harpoon

### Completion & Copilot (insert)
`<C-j>`/`<C-k>` select · `<C-Space>` open · `<CR>` confirm · `<C-e>` abort · `<C-l>`/`<C-h>` snippet jump ·
`<Tab>` accept Copilot · `<M-Right>` accept word · `<M-]>`/`<M-[>` cycle · `<C-]>` dismiss

## C / eBPF project setup

clangd needs compile flags: `bear -- make`, `cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON`,
or a `compile_flags.txt`, e.g. for BPF objects:

```
-target
bpf
-D__TARGET_ARCH_x86
-I.
```

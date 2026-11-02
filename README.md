# Neovim configuration for Clojure and Elixir

The theme is tokyonight.nvim (night style by default) with lualine. Press `<leader>fs` to switch the style; the choice is kept across restarts.
Elixir files format on save through elixir-ls. Terraform files format on save through `terraform fmt`.

## Install dependencies

```bash
$ brew install neovim fd stylua clojure-lsp/brew/clojure-lsp-native
```

## Install configuration

```bash
$ mkdir -p ~/.config
$ git clone git@github.com:k13gomez/nvim-config.git ~/.config/nvim
```

## Launch Neovim

```bash
$ nvim
```

On first launch, the built-in `vim.pack` asks to install the plugins. It records each plugin revision in `nvim-pack-lock.json`. Keep that file in git.

## Useful links

- [Conjure Docs](https://github.com/Olical/conjure/blob/master/doc/conjure.txt)

---

# Keybindings

`<leader>` = `,` &nbsp;·&nbsp; `<localleader>` = `,` (same key)

The popup at runtime is provided by [which-key.nvim](https://github.com/folke/which-key.nvim) — press a prefix and wait ~300ms.

## General

| Key | Mode | Action |
|---|---|---|
| `<leader>ne` | n | Empty buffer in new tab |
| `<leader>nt` | n | Terminal in new tab |
| `<leader>qq` | n | Quit |
| `<leader>qa` | n | Quit all |
| `<leader>qw` | n | Write and quit |
| `<leader>qs` | n | Write all and quit all |
| `<leader>rt` | n | Retab |
| `<leader>tl` | n | Toggle line numbers |
| `<leader>ti` | n | Toggle parinfer |

## Insert / utilities (`<leader>u…`)

| Key | Action |
|---|---|
| `<leader>uu` | Insert UUID |
| `<leader>ue` | Insert empty UUID |
| `<leader>uh` | Insert random hex hash |
| `<leader>uts` | Insert ISO-8601 timestamp |
| `<leader>ufx` | Pretty-print XML buffer |
| `<leader>ufj` | Pretty-print JSON buffer |

## Plugins (`<leader>p…`)

| Key | Action |
|---|---|
| `<leader>pu` | Update plugins. Review the changes, then `:w` to apply or `:q` to cancel |
| `<leader>pl` | List the installed plugins (no network) |
| `<leader>pc` | Delete the plugins that are no longer in `lua/bootstrap.lua` |

## Git (gitsigns, buffer-local)

| Key | Action |
|---|---|
| `]c` / `[c` | Next / previous hunk |
| `<leader>Gp` | Preview hunk |
| `<leader>Gs` / `<leader>Gr` | Stage / reset hunk |
| `<leader>Gb` | Blame line |
| `<leader>Gt` | Toggle git signs |

## Files & buffers

| Key | Action |
|---|---|
| `<leader>tt` | Toggle neo-tree |
| `\` | Neo-tree: reveal current file |
| `<leader>ff` | Telescope: find files |
| `<leader>fg` | Telescope: live grep |
| `<leader>fb` | Telescope: buffers |
| `<leader>fh` | Telescope: help tags |
| `<leader>fs` | Telescope: switch the tokyonight style, with live preview (remembered across restarts) |

## Tabs

| Key | Action |
|---|---|
| `` <leader>` `` | Last tab (backtick) |
| `<leader>1` … `<leader>9` | Go to tab N |
| `<leader>0` | Last tab |

## Window resize

Vertical (wider / narrower):

| Key | Δ |
|---|---|
| `<leader>>>` / `<leader><<` | ±5 |
| `<leader>>>>` / `<leader><<<` | ±10 |
| `<leader>>>>>` / `<leader><<<<` | ±20 |

Horizontal (taller / shorter):

| Key | Δ |
|---|---|
| `<leader>,>>` / `<leader>,<<` | ±5 |
| `<leader>,>>>` / `<leader>,<<<` | ±10 |
| `<leader>,>>>>` / `<leader>,<<<<` | ±20 |

## Case conversion

Bindings work in both normal and visual modes.

| Key | Action |
|---|---|
| `csr` | Rotate case |
| `css` | → `snake_case` |
| `csk` | → `kebab-case` |
| `csc` | → `camelCase` |
| `csp` | → `PascalCase` |
| `csm` | → `MACRO_CASE` |

## Alignment

| Key | Mode | Action |
|---|---|---|
| `ga` | n, x | EasyAlign |

## Clojure (Conjure / Portal)

| Key | Action |
|---|---|
| `<leader>repl` | Connect Conjure REPL (port-file) |
| `<leader>cv` | Find library versions for word at cursor |
| `<leader>cp` | Portal: add lib |
| `<leader>ct` / `<leader>cu` | Portal: taps on / off |
| `<leader>cT` | `(tap> word-at-cursor)` |
| `<leader>cg` | Portal: get selected |
| `<leader>cj` | JVM PID |
| `<leader>cef` | Eval fn at cursor |
| `<leader>cw` | Enable `*warn-on-reflection*` |
| `<leader>cro` / `<leader>crt` | Run one / all Clojure tests |
| `<leader>crn` | Reload current ns |
| `<leader>crr` | Reset clara rules cache |

## LSP (buffer-local on attach, except `<leader>df`)

| Key | Mode | Action |
|---|---|---|
| `gd` | n | Goto definition |
| `K` | n | Hover |
| `<leader>df` | n, v | Format buffer (conform.nvim, LSP fallback) |
| `<leader>dd` | n | Goto declaration |
| `<leader>dt` | n | Goto type definition |
| `<leader>ds` | n | Signature help |
| `<leader>dn` | n | Rename symbol |
| `<leader>de` | n | Show diagnostic float |
| `<leader>dq` | n | Diagnostics → loclist |
| `<leader>dj` / `<leader>dk` | n | Next / previous diagnostic |
| `<leader>da` | n, v | Code action |
| `<leader>dw` | n | Telescope: workspace diagnostics |
| `<leader>dr` | n | Telescope: references |
| `<leader>di` | n | Telescope: implementations |

## Completion (nvim-cmp, insert mode)

| Key | Action |
|---|---|
| `<C-Space>` | Trigger completion |
| `<C-b>` / `<C-f>` | Scroll docs up / down |
| `<C-e>` | Abort |
| `<CR>` | Confirm currently selected item |

## S-expression navigation (lisp filetypes)

`lua/plugins/sexp.lua` maps `(` and `)` in Clojure, Fennel, Scheme and Lisp buffers.
Brackets in strings, regexes, comments and char literals do not count.
Parinfer does the structural editing.

| Key | Mode | Action |
|---|---|---|
| `(` | n, x, o | Move to the open bracket of the enclosing list (`backward-up-list`) |
| `)` | n, x, o | Move to the close bracket of the enclosing list (`up-list`) |

## Mouse

| Action | Bind |
|---|---|
| Scroll down | `j` |
| Scroll up | `k` |

## Folding

Treesitter-based folding is enabled for any filetype whose parser ships a `folds.scm` query. Parsers auto-install on first open of a filetype — the buffer activates highlighting + folding + indent the moment the install finishes (see `lua/plugins/treesitter.lua`).

All windows start with folds open (`foldenable = false`); use vim's native fold motions when you want them:

| Key | Action |
|---|---|
| `za` | Toggle fold under cursor |
| `zo` / `zc` | Open / close fold under cursor |
| `zR` / `zM` | Open / close *all* folds |
| `zr` / `zm` | Reduce / increase fold level by one |
| `zj` / `zk` | Jump to next / previous fold |
| `[z` / `]z` | Move to start / end of current fold |

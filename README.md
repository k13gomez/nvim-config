# Neovim Configuration for Clojure

## Install dependencies

```bash
$ brew install neovim fd clojure-lsp/brew/clojure-lsp-native
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

On first launch, vim-plug bootstraps itself and runs `:PlugInstall` to fetch every plugin. Restart `nvim` once it finishes.

## Useful links

- [Conjure Docs](https://github.com/Olical/conjure/blob/master/doc/conjure.txt)

---

# Keybindings

`<leader>` = `,` &nbsp;·&nbsp; `<localleader>` = `,` (same key)

The popup at runtime is provided by [which-key.nvim](https://github.com/folke/which-key.nvim) — press a prefix and wait ~300ms.

## General

| Key | Mode | Action |
|---|---|---|
| `<leader>sv` | n | Source vimrc |
| `<leader>tab` | n | New tab |
| `<leader>rt` | n | Retab |
| `<leader>tn` | n | Toggle line numbers |
| `<leader>tp` | n | Toggle paste mode |
| `<leader>ti` | n | Toggle parinfer |
| `<leader>gg` / `<leader>gd` / `<leader>gt` | n | GitGutter on / off / toggle |

## Insert / utilities (`<leader>u…`)

| Key | Action |
|---|---|
| `<leader>uu` | Insert UUID |
| `<leader>ue` | Insert empty UUID |
| `<leader>uh` | Insert random hex hash |
| `<leader>uts` | Insert ISO-8601 timestamp |
| `<leader>ufx` | Pretty-print XML buffer |
| `<leader>ufj` | Pretty-print JSON buffer |
| `<leader>ufl` | Format Lua buffer (stylua) |

## Files & buffers

| Key | Action |
|---|---|
| `<leader>tt` | Toggle neo-tree |
| `\` | Neo-tree: reveal current file |
| `<leader>ff` | Telescope: find files |
| `<leader>fg` | Telescope: live grep |
| `<leader>fb` | Telescope: buffers |
| `<leader>fh` | Telescope: help tags |

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
| `case` | Rotate case |
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

## LSP (buffer-local on attach)

| Key | Mode | Action |
|---|---|---|
| `gd` | n | Goto definition |
| `K` | n | Hover |
| `ff` | n, v | Format buffer |
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

## vim-sexp (Clojure structural editing)

All `<LocalLeader>`-based defaults are remapped under `<leader>w…` so they share the popup with conjure's `<leader>w` group. Navigation / text objects / `<M-…>` swaps are unchanged.

### Navigation

| Key | Mode | Action |
|---|---|---|
| `(` / `)` | n, x, o | Move to prev / next bracket |
| `[[` / `]]` | n, x, o | Move to prev / next top-level form |
| `[e` / `]e` | n, x, o | Select prev / next element |
| `af` / `if` | x, o | Outer / inner list text object |
| `aF` / `iF` | x, o | Outer / inner top-level list |
| `as` / `is` | x, o | Outer / inner string |
| `ae` / `ie` | x, o | Outer / inner element |
| `<M-h>` / `<M-l>` | n, x | Swap element backward / forward |
| `<M-j>` / `<M-k>` | n, x | Swap list forward / backward |

### Wrap list (`<leader>w` + bracket)

| Key | Action |
|---|---|
| `<leader>w(` / `<leader>w)` | Wrap list with `( … )` (head / tail) |
| `<leader>w[` / `<leader>w]` | Wrap list with `[ … ]` |
| `<leader>w{` / `<leader>w}` | Wrap list with `{ … }` |

### Wrap element (`<leader>we` + bracket)

| Key | Action |
|---|---|
| `<leader>we(` / `<leader>we)` | Wrap element with `( … )` |
| `<leader>we[` / `<leader>we]` | Wrap element with `[ … ]` |
| `<leader>we{` / `<leader>we}` | Wrap element with `{ … }` |

### Other structural ops

| Key | Action |
|---|---|
| `<leader>wih` / `<leader>wit` | Insert at list head / tail |
| `<leader>ws` | Splice list |
| `<leader>wv` | Convolute |
| `<leader>wcl` / `<leader>wce` | Clone list / element |
| `<leader>wrl` / `<leader>wre` | Raise list / element |
| `<leader>wph` / `<leader>wpt` | Put at list head / tail |
| `<leader>wpb` / `<leader>wpa` | Put before / after (sexp-aware) |
| `<leader>wxp` | Replace |
| `<leader>wxx` | Replace (no-yank, via black-hole register) |
| `<leader>wac` / `<leader>wat` | Align comments / align comments at top |

See [vim-sexp docs](https://github.com/guns/vim-sexp) for what each op does.

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

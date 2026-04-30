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
| `<leader>gg` | n | GitGutter on |
| `<leader>fl` | n | Format Lua (stylua) |

## Insert helpers

| Key | Action |
|---|---|
| `<leader>uid` | Insert UUID |
| `<leader>eid` | Insert empty UUID |
| `<leader>md5` | Insert random hex hash |
| `<leader>now` | Insert ISO-8601 timestamp |
| `<leader>xml` | Pretty-print XML buffer |
| `<leader>json` | Pretty-print JSON buffer |

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
| `<leader>tap` | `(tap> word-at-cursor)` |
| `<leader>cp` | Portal: add lib |
| `<leader>ct` / `<leader>cu` | Portal: taps on / off |
| `<leader>cg` | Portal: get selected |
| `<leader>tone` / `<leader>tall` | Run one / all Clojure tests |
| `<leader>efn` | Eval fn at cursor |
| `<leader>cj` | JVM PID |
| `<leader>wrf` | Enable `*warn-on-reflection*` |
| `<leader>cv` | Find library versions for word at cursor |
| `<leader>,test` | Run tests in current ns |
| `<leader>rns` | Reload current ns |
| `<leader>rst` | Reset clara rules cache |
| `<leader>hto` | Activate humane-test-output |

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

`<localleader>` = `,` (same as `<leader>`). Custom overrides on top of vim-sexp's defaults:

| Key | Action |
|---|---|
| `<localleader>P` | `sexp_put_before` |
| `<localleader>p` | `sexp_put_after` (n) / `sexp_replace` (x) |
| `<localleader><localleader>p` | `sexp_replace` (n) |
| `<localleader><localleader>P` | `sexp_replace_P` (n) |

See [vim-sexp docs](https://github.com/guns/vim-sexp) for the full set of structural-edit bindings.

## Mouse

| Action | Bind |
|---|---|
| Scroll down | `j` |
| Scroll up | `k` |

# Neovim configuration for Clojure and Elixir

This configuration is kept in sync with [k13gomez/emacs-config](https://github.com/k13gomez/emacs-config) through quantum entanglement.

The theme is tokyonight.nvim (night style by default) with lualine. Press `,fs` to switch the style; the choice is kept across restarts.
Elixir files format on save through elixir-ls. Terraform files format on save through `terraform fmt`.
Plugins come from `vim.pack`, which is built into Neovim 0.12.

## Install dependencies

```bash
$ brew install neovim fd ripgrep tree-sitter-cli rust stylua clojure-lsp/brew/clojure-lsp-native elixir-ls lua-language-server
```

Terraform formatting needs `terraform` on the `PATH`, and Copilot needs Node. The icons need a Nerd Font in the terminal.

## Install configuration

```bash
$ mkdir -p ~/.config
$ git clone git@github.com:k13gomez/nvim-config.git ~/.config/nvim
```

## Launch Neovim

```bash
$ nvim
```

On first launch, `vim.pack` asks to install the plugins. It records each plugin revision in `nvim-pack-lock.json`; keep that file in git. The parinfer-rust plugin is built with `cargo` when it installs or updates. A tree-sitter parser installs the first time a file of its type opens. After that, run `:Copilot setup` once.

## Useful links

- [Conjure docs](https://github.com/Olical/conjure/blob/master/doc/conjure.txt)
- [Telescope docs](https://github.com/nvim-telescope/telescope.nvim)

---

# Keybindings

`<leader>` = `,` &nbsp;·&nbsp; `<localleader>` = `,` (same key)

Press a prefix and wait ~300ms for the which-key popup.
To run any command by name, press `,:`. The mouse is on, and the scroll wheel moves the cursor down and up (`j` / `k`).

## General

| Key | Action |
|---|---|
| `,:` | Search and run commands (Telescope) |
| `,h` | Start screen |
| `,ne` | Empty buffer in new tab |
| `,nt` | Terminal in new tab |
| `,bw` / `,bW` | Write buffer / write all buffers |
| `,bq` / `,bQ` | Quit buffer / quit all |
| `,bx` | Write all and quit (force) |
| `,bX` | Quit all, discarding changes |
| `,qq` | Quit |
| `,qa` | Quit all |
| `,qw` | Write and quit |
| `,qs` | Write all and quit all |
| `,rt` | Retab |
| `,tl` | Toggle line numbers |
| `,ti` | Toggle parinfer |
| `C-l` | Clear search highlight and redraw |

## Insert / utilities (`,u…`)

| Key | Action |
|---|---|
| `,uu` | Insert UUID |
| `,ue` | Insert empty UUID |
| `,uh` | Insert random hex hash |
| `,uts` | Insert ISO-8601 timestamp |
| `,ufx` | Pretty-print XML buffer |
| `,ufj` | Pretty-print JSON buffer |

## Plugins (`,p…`)

| Key | Action |
|---|---|
| `,pu` | Update plugins. Review the changes, then `:w` to apply or `:q` to cancel |
| `,pl` | List the installed plugins (no network) |
| `,pc` | Delete the plugins that are no longer in `lua/bootstrap.lua` |

## Git (gitsigns)

These keys are local to buffers in a git repo. Use `:Git` (fugitive) for the full git interface.

| Key | Action |
|---|---|
| `]c` / `[c` | Next / previous hunk |
| `,Gp` | Preview hunk |
| `,Gs` / `,Gr` | Stage / reset hunk |
| `,Gb` | Blame line |
| `,Gt` | Toggle git signs |

## Files & buffers

| Key | Action |
|---|---|
| `,ff` | Find files |
| `,fg` | Grep (ripgrep) |
| `,fb` | Buffers |
| `,fh` | Help tags |
| `,fs` | Switch the tokyonight style, with live preview (remembered across restarts) |
| `C-t` | In a Telescope picker: open the selection in a new tab |

## File tree (neo-tree)

The tree opens on the right and follows the current file. It closes when it's the last window left.

| Key | Action |
|---|---|
| `,tt` | Toggle the file tree |
| `\` | Reveal the current file in the tree |
| `Space` | In the tree: expand / collapse the node |
| `Esc` | In the tree: close the preview |
| `C-x` | In the tree: clear the filter |

## Tabs

The tabline is always shown. A tab is named `dir/file` after its buffer, or after the title of the terminal in it.

| Key | Action |
|---|---|
| `` ,` `` | Last tab (backtick) |
| `,1` … `,9` | Go to tab N |
| `,0` | Last tab |

## Window resize

Vertical (wider / narrower):

| Key | Δ |
|---|---|
| `,>>` / `,<<` | ±5 |
| `,>>>` / `,<<<` | ±10 |
| `,>>>>` / `,<<<<` | ±20 |

Horizontal (taller / shorter):

| Key | Δ |
|---|---|
| `,,>>` / `,,<<` | ±5 |
| `,,>>>` / `,,<<<` | ±10 |
| `,,>>>>` / `,,<<<<` | ±20 |

After `,>>` or `,<<`, Neovim waits for `timeoutlen` in case another `>` or `<` follows.

## Terminal

Moving to a window with a running shell puts it in terminal mode, ready to type. When the shell exits cleanly, its buffer closes. A failed exit leaves the buffer open so you can read it; press `q` to close it.

| Key | Mode | Action |
|---|---|---|
| `,Tt` | n | Terminal in new tab |
| `,Tv` | n | Terminal in vertical split |
| `,Ts` | n | Terminal in horizontal split |
| `,Tr` | n | Rename terminal (empty = automatic) |
| `Esc` | t | Leave terminal mode |
| `C-w` | t | Window commands from the terminal |
| `C-v` `Esc` | t | Send `Esc` to the shell |

## Case conversion

The `cs` keys work in normal and visual mode.

| Key | Action |
|---|---|
| `csr` | Rotate case |
| `css` | → `snake_case` |
| `csk` | → `kebab-case` |
| `csc` | → `camelCase` |
| `csp` | → `PascalCase` |
| `csm` | → `MACRO_CASE` |

## Editing

| Key | Mode | Action |
|---|---|---|
| `gc{motion}` / `gcc` | n, x | Comment or uncomment |
| `ga{motion}` | n, x | Align on a character (EasyAlign) |
| `(` | n, x, o | Clojure, Fennel, Scheme, Lisp: move to the open bracket of the enclosing list |
| `)` | n, x, o | Clojure, Fennel, Scheme, Lisp: move to the close bracket of the enclosing list |

Brackets inside strings, regexes, comments and char literals don't count for `(` and `)`. Parinfer does the structural editing.

## Clojure (Conjure / Portal)

These keys are local to Clojure buffers. Most are Conjure's defaults. Conjure doesn't start a REPL on its own, so connect to a running one.

Connection and sessions:

| Key | Action |
|---|---|
| `,repl` / `,cf` | Connect to the REPL in the project's port file |
| `,cd` | Disconnect |
| `,sc` / `,sf` | Clone the current session / start a fresh one |
| `,sq` / `,sQ` | Close the current session / all sessions |
| `,sl` | List sessions |
| `,sn` / `,sp` | Next / previous session |
| `,ss` | Select a session |

Evaluation:

| Key | Mode | Action |
|---|---|---|
| `,ee` | n | Eval current form |
| `,er` | n | Eval root form |
| `,ew` | n | Eval word |
| `,ece` | n | Eval current form, result as a comment |
| `,ecr` | n | Eval root form, result as a comment |
| `,ecw` | n | Eval word, result as a comment |
| `,e!` | n | Eval current form and replace it with the result |
| `,em{mark}` | n | Eval the form at a mark |
| `,eb` / `,ef` | n | Eval buffer / file |
| `,ei` | n | Interrupt |
| `,E{motion}` | n | Eval a motion |
| `,E` | v | Eval selection |
| `,cef` | n | Call the fn at cursor with no arguments |

Log:

| Key | Action |
|---|---|
| `,ls` / `,lv` | Show the log in a horizontal / vertical split |
| `,lt` / `,le` | Show the log in a new tab / the current window |
| `,lq` | Close the log windows in this tab |
| `,lr` / `,lR` | Soft / hard reset the log |
| `,ll` | Jump to the latest result in the log |

Navigation, views and macros:

| Key | Action |
|---|---|
| `,gd` | Goto definition |
| `,vs` | View the source of the symbol at cursor |
| `,ve` | View the last exception |
| `,v1` / `,v2` / `,v3` | View the last / 2nd / 3rd result |
| `,vt` | View and clear the tap queue |
| `,x1` / `,xr` / `,xa` | Macroexpand once / `macroexpand` / fully |

Tests and reloading:

| Key | Action |
|---|---|
| `,tc` / `,tn` / `,ta` | Run test at cursor / ns tests / all loaded tests |
| `,tN` | Run the tests in the alternate namespace |
| `,cro` / `,crt` | `clojure.test`: run the test at cursor / all tests in the ns |
| `,crn` | Reload current ns |
| `,rr` / `,ra` | Refresh changed / all namespaces |
| `,rc` | Clear the refresh cache |
| `,crr` | Reset clara rules cache |

Portal and helpers:

| Key | Action |
|---|---|
| `,cp` | Portal: add lib |
| `,ct` / `,cu` | Portal: taps on / off |
| `,cT` | `(tap> word-at-cursor)` |
| `,cg` | Portal: get selected |
| `,cv` | Find library versions for word at cursor |
| `,cj` | JVM PID |
| `,cw` | Enable `*warn-on-reflection*` |

In `deps.edn`, completion offers the versions of a library.

## Elixir (Conjure / mix)

These keys are local to Elixir buffers. The Conjure evaluation and log keys from the Clojure section work here too, sending code to iex.

| Key | Action |
|---|---|
| `,cs` | Start `iex -S mix` |
| `,cS` | Stop iex |
| `,ei` | Interrupt iex |
| `,mt` | mix: test at cursor |
| `,mf` | mix: test current file |
| `,ma` | mix: test all |
| `,mr` | mix: re-run failed tests |
| `,mc` | mix: compile |
| `,md` | mix: `deps.get` |
| `,dl` | Run the elixir-ls test lens on this line |

The `mix` keys run in a 15-line split at the bottom. Once the command finishes, `q` closes the split.

## LSP

The language servers are clojure-lsp, elixir-ls and lua-language-server. All keys except `,df` are set when a server attaches to the buffer. Diagnostics show as signs, without inline text.

| Key | Mode | Action |
|---|---|---|
| `gd` | n | Goto definition |
| `K` | n | Hover |
| `,df` | n, v | Format buffer (conform, LSP fallback) |
| `,dd` | n | Goto declaration |
| `,dt` | n | Goto type definition |
| `,ds` | n | Signature help |
| `,dn` | n | Rename symbol |
| `,de` | n | Show diagnostic at cursor |
| `,dq` | n | Diagnostics → location list |
| `,dj` / `,dk` | n | Next / previous diagnostic |
| `,da` | n, v | Code action |
| `,dw` | n | Workspace diagnostics (Telescope) |
| `,dr` | n | References (Telescope) |
| `,di` | n | Implementations (Telescope) |
| `,dl` | n | Run code lens |

## Completion (nvim-cmp, insert mode)

Completion also works on the `:` command line and in `/` and `?` searches.

| Key | Action |
|---|---|
| `C-Space` | Trigger completion |
| `C-b` / `C-f` | Scroll docs up / down |
| `C-e` | Abort |
| `CR` | Confirm the selected item, or insert a newline if none is selected |

## Copilot

These are copilot.vim's default keys.

| Key | Action |
|---|---|
| `M-\` | Request a suggestion |
| `Tab` | Accept the suggestion |
| `M-]` / `M-[` | Next / previous suggestion |
| `M-Right` | Accept the next word |
| `M-C-Right` | Accept the next line |
| `C-]` | Dismiss the suggestion |

## Folding

Any filetype whose tree-sitter parser has a fold query folds by syntax. Folds start open.

| Key | Action |
|---|---|
| `za` | Toggle fold under cursor |
| `zo` / `zc` | Open / close fold under cursor |
| `zR` / `zM` | Open / close *all* folds |
| `zr` / `zm` | Reduce / increase fold level by one |
| `zj` / `zk` | Jump to next / previous fold |
| `[z` / `]z` | Move to start / end of current fold |

## Start screen (Startify)

The start screen lists recent files and shows how long startup took. `,h` opens it again.

| Key | Action |
|---|---|
| `e` | New empty buffer |
| `q` | Quit |
| A listed number | Open that file |

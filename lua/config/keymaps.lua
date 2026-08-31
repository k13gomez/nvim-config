local map = vim.keymap.set
local text = require("helpers.text")
local clj = require("helpers.clojure")
local ex = require("helpers.elixir")

map("n", "<leader>sv", "<cmd>source $MYVIMRC<cr>", { desc = "Source vimrc" })
map("n", "<leader>tab", "<cmd>tabnew<cr>", { desc = "New tab" })

map("n", "<leader>bw", "<cmd>w<cr>", { desc = "Write buffer" })
map("n", "<leader>bq", "<cmd>q<cr>", { desc = "Quit buffer" })
map("n", "<leader>bW", "<cmd>wa<cr>", { desc = "Write all buffers" })
map("n", "<leader>bQ", "<cmd>qa<cr>", { desc = "Quit all buffers" })
map("n", "<leader>bx", "<cmd>wqa!<cr>", { desc = "Write all & quit all (force)" })
map("n", "<leader>bX", "<cmd>qa!<cr>", { desc = "Quit all (force, discard)" })

map("n", "<leader>uh", text.hash, { desc = "Insert random hex hash" })
map("n", "<leader>uu", text.guid, { desc = "Insert UUID" })
map("n", "<leader>ue", text.empty_guid, { desc = "Insert empty UUID" })
map("n", "<leader>uts", text.datetime_now, { desc = "Insert ISO timestamp" })
map("n", "<leader>ufx", text.pretty_xml, { desc = "Pretty-print XML" })
map("n", "<leader>ufj", text.pretty_json, { desc = "Pretty-print JSON" })

map("n", "<leader>tt", "<cmd>Neotree toggle position=right<cr>", { desc = "Toggle neo-tree" })
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Help tags" })

map("n", "<leader>tn", function()
  vim.opt.number = not vim.opt.number:get()
end, { desc = "Toggle line numbers" })
map("n", "<leader>tp", function()
  vim.opt.paste = not vim.opt.paste:get()
end, { desc = "Toggle paste mode" })

local parinfer_on = false
map("n", "<leader>ti", function()
  parinfer_on = not parinfer_on
  vim.cmd(parinfer_on and "ParinferOn" or "ParinferOff")
end, { desc = "Toggle parinfer" })

map("n", "<leader>>>", "<cmd>vertical resize +5<cr>", { desc = "Wider +5" })
map("n", "<leader><<", "<cmd>vertical resize -5<cr>", { desc = "Narrower -5" })
map("n", "<leader>>>>", "<cmd>vertical resize +10<cr>", { desc = "Wider +10" })
map("n", "<leader><<<", "<cmd>vertical resize -10<cr>", { desc = "Narrower -10" })
map("n", "<leader>>>>>", "<cmd>vertical resize +20<cr>", { desc = "Wider +20" })
map("n", "<leader><<<<", "<cmd>vertical resize -20<cr>", { desc = "Narrower -20" })
map("n", "<leader>,>>", "<cmd>horizontal resize +5<cr>", { desc = "Taller +5" })
map("n", "<leader>,<<", "<cmd>horizontal resize -5<cr>", { desc = "Shorter -5" })
map("n", "<leader>,>>>", "<cmd>horizontal resize +10<cr>", { desc = "Taller +10" })
map("n", "<leader>,<<<", "<cmd>horizontal resize -10<cr>", { desc = "Shorter -10" })
map("n", "<leader>,>>>>", "<cmd>horizontal resize +20<cr>", { desc = "Taller +20" })
map("n", "<leader>,<<<<", "<cmd>horizontal resize -20<cr>", { desc = "Shorter -20" })

map("n", "<leader>repl", "<cmd>ConjureCljConnectPortFile<cr>", { desc = "Connect Conjure REPL" })
map("n", "<leader>gg", "<cmd>GitGutterEnable<cr>", { desc = "GitGutter on" })
map("n", "<leader>gd", "<cmd>GitGutterDisable<cr>", { desc = "GitGutter off" })
map("n", "<leader>gt", "<cmd>GitGutterToggle<cr>", { desc = "GitGutter toggle" })
map("n", "<leader>rt", "<cmd>retab<cr>", { desc = "Retab" })

map("n", "case", "<cmd>CaseMasterRotateCase<cr>", { silent = true, desc = "Rotate case" })
map("v", "case", "<cmd>CaseMasterRotateCaseVisual<cr>", { silent = true, desc = "Rotate case (visual)" })
map("n", "css", "<cmd>CaseMasterConvertToSnake<cr>", { silent = true, desc = "→ snake_case" })
map("n", "csk", "<cmd>CaseMasterConvertToKebab<cr>", { silent = true, desc = "→ kebab-case" })
map("n", "csc", "<cmd>CaseMasterConvertToCamel<cr>", { silent = true, desc = "→ camelCase" })
map("n", "csp", "<cmd>CaseMasterConvertToPascal<cr>", { silent = true, desc = "→ PascalCase" })
map("n", "csm", "<cmd>CaseMasterConvertToMacro<cr>", { silent = true, desc = "→ MACRO_CASE" })
map("v", "css", "<cmd>CaseMasterConvertToSnake<cr>", { silent = true, desc = "→ snake_case" })
map("v", "csk", "<cmd>CaseMasterConvertToKebab<cr>", { silent = true, desc = "→ kebab-case" })
map("v", "csc", "<cmd>CaseMasterConvertToCamel<cr>", { silent = true, desc = "→ camelCase" })
map("v", "csp", "<cmd>CaseMasterConvertToPascal<cr>", { silent = true, desc = "→ PascalCase" })
map("v", "csm", "<cmd>CaseMasterConvertToMacro<cr>", { silent = true, desc = "→ MACRO_CASE" })

map("x", "ga", "<Plug>(EasyAlign)", { remap = true, desc = "EasyAlign" })
map("n", "ga", "<Plug>(EasyAlign)", { remap = true, desc = "EasyAlign" })

map("n", "<leader>`", function()
  vim.cmd("tabn " .. (vim.g.lasttab or 1))
end, { desc = "Last tab" })
for i = 1, 9 do
  map("n", "<leader>" .. i, i .. "gt", { desc = "Tab " .. i })
end
map("n", "<leader>0", "<cmd>tablast<cr>", { desc = "Last tab" })

map("", "<ScrollWheelDown>", "j")
map("", "<ScrollWheelUp>", "k")

map("n", "<leader>cv", clj.find_library_versions, { desc = "Find library versions" })
map("n", "<leader>cp", clj.add_lib_portal, { desc = "Portal: add lib" })
map("n", "<leader>ct", clj.add_tap_expression, { desc = "Portal: taps on" })
map("n", "<leader>cT", clj.tap_expression, { desc = "tap> word at cursor" })
map("n", "<leader>cu", clj.remove_tap_expression, { desc = "Portal: taps off" })
map(
  "n",
  "<leader>cg",
  "<cmd>ConjureEval (do (require 'portal.api) (portal.api/selected))<cr>",
  { desc = "Portal: get selected" }
)
map("n", "<leader>cro", clj.run_test, { desc = "Run one Clojure test" })
map("n", "<leader>crt", clj.run_tests, { desc = "Run all Clojure tests" })
map("n", "<leader>cef", clj.eval_fn, { desc = "Clojure Eval fn at cursor" })
map("n", "<leader>cj", clj.get_pid, { desc = "JVM PID" })
map("n", "<leader>cw", clj.warn_on_reflection, { desc = "*warn-on-reflection* on" })

map("n", "<leader>mt", ex.test_at_cursor, { desc = "Mix: test at cursor" })
map("n", "<leader>mf", ex.test_file, { desc = "Mix: test current file" })
map("n", "<leader>ma", ex.test_all, { desc = "Mix: test all" })
map("n", "<leader>mr", ex.test_failed, { desc = "Mix: re-run failed tests" })
map("n", "<leader>mc", ex.compile, { desc = "Mix: compile" })
map("n", "<leader>md", ex.deps_get, { desc = "Mix: deps.get" })

map("n", "<leader>ufl", function()
  require("stylua-nvim").format_file()
end, { desc = "Format Lua (stylua)" })
map("n", "<leader>crn", "<cmd>ConjureEval (require (ns-name *ns*) :reload)<cr>", { desc = "Reload current ns" })
map(
  "n",
  "<leader>crr",
  "<cmd>ConjureEval (do (rules.core/reset-rules!) (rules.core/reset-loader!))<cr>",
  { desc = "Reset clara rules" }
)

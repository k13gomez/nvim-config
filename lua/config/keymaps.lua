local map = vim.keymap.set
local text = require("helpers.text")
local clj = require("helpers.clojure")

map("n", "<leader>sv", "<cmd>source $MYVIMRC<cr>", { desc = "Source vimrc" })
map("n", "<leader>tab", "<cmd>tabnew<cr>", { desc = "New tab" })

map("n", "<leader>md5", text.hash, { desc = "Insert random hex hash" })
map("n", "<leader>uid", text.guid, { desc = "Insert UUID" })
map("n", "<leader>eid", text.empty_guid, { desc = "Insert empty UUID" })
map("n", "<leader>now", text.datetime_now, { desc = "Insert ISO timestamp" })
map("n", "<leader>xml", text.pretty_xml, { desc = "Pretty-print XML" })
map("n", "<leader>json", text.pretty_json, { desc = "Pretty-print JSON" })

map("n", "<leader>tt", "<cmd>Neotree toggle position=right<cr>", { desc = "Toggle neo-tree" })
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Help tags" })

map("n", "<leader>ll", "<cmd>set number<cr>", { desc = "Show line numbers" })
map("n", "<leader>nl", "<cmd>set nonumber<cr>", { desc = "Hide line numbers" })
map("n", "<leader>pp", "<cmd>set paste<cr>", { desc = "Paste mode on" })
map("n", "<leader>np", "<cmd>set nopaste<cr>", { desc = "Paste mode off" })

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
map("n", "<leader>par", "<cmd>ParinferOn<cr>", { desc = "Parinfer on" })
map("n", "<leader>nopar", "<cmd>ParinferOff<cr>", { desc = "Parinfer off" })
map("n", "<leader>gg", "<cmd>GitGutterEnable<cr>", { desc = "GitGutter on" })
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

map("n", "<leader>lib", clj.find_library_versions, { desc = "Find library versions" })
map("n", "<leader>tap", clj.tap_expression, { desc = "tap> word at cursor" })
map("n", "<leader>port", clj.add_lib_portal, { desc = "Add Portal lib" })
map("n", "<leader>ptap", clj.add_tap_expression, { desc = "Portal: enable taps" })
map(
  "n",
  "<leader>pget",
  "<cmd>ConjureEval (do (require 'portal.api) (portal.api/selected))<cr>",
  { desc = "Portal: get selected" }
)
map("n", "<leader>rtap", clj.remove_tap_expression, { desc = "Portal: disable taps" })
map("n", "<leader>tone", clj.run_test, { desc = "Run one Clojure test" })
map("n", "<leader>tall", clj.run_tests, { desc = "Run all Clojure tests" })
map("n", "<leader>efn", clj.eval_fn, { desc = "Eval fn at cursor" })
map("n", "<leader>pid", clj.get_pid, { desc = "JVM PID" })
map("n", "<leader>wrf", clj.warn_on_reflection, { desc = "*warn-on-reflection* on" })

map("n", "<leader>lua", function()
  require("stylua-nvim").format_file()
end, { desc = "Format Lua (stylua)" })
map(
  "n",
  "<leader>,test",
  "<cmd>ConjureEval (clojure.test/run-tests)<cr>",
  { desc = "Run tests in ns" }
)
map(
  "n",
  "<leader>rns",
  "<cmd>ConjureEval (require (ns-name *ns*) :reload)<cr>",
  { desc = "Reload current ns" }
)
map(
  "n",
  "<leader>rst",
  "<cmd>ConjureEval (do (rules.core/reset-rules!) (rules.core/reset-loader!))<cr>",
  { desc = "Reset rules" }
)
map(
  "n",
  "<leader>hto",
  "<cmd>ConjureEval (do (require '[pjstadig.humane-test-output]) (pjstadig.humane-test-output/activate!))<cr>",
  { desc = "Humane test output" }
)

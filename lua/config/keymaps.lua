local map = vim.keymap.set
local text = require("helpers.text")
local clj = require("helpers.clojure")

map("n", "<leader>sv", "<cmd>source $MYVIMRC<cr>")
map("n", "<leader>tab", "<cmd>tabnew<cr>")

map("n", "<leader>md5", text.hash)
map("n", "<leader>uid", text.guid)
map("n", "<leader>eid", text.empty_guid)
map("n", "<leader>now", text.datetime_now)
map("n", "<leader>xml", text.pretty_xml)
map("n", "<leader>json", text.pretty_json)

map("n", "<leader>tt", "<cmd>Neotree toggle position=right<cr>")
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>")
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>")
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>")
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>")

map("n", "<leader>ll", "<cmd>set number<cr>")
map("n", "<leader>nl", "<cmd>set nonumber<cr>")
map("n", "<leader>pp", "<cmd>set paste<cr>")
map("n", "<leader>np", "<cmd>set nopaste<cr>")

map("n", "<leader>>>", "<cmd>vertical resize +5<cr>")
map("n", "<leader><<", "<cmd>vertical resize -5<cr>")
map("n", "<leader>>>>", "<cmd>vertical resize +10<cr>")
map("n", "<leader><<<", "<cmd>vertical resize -10<cr>")
map("n", "<leader>>>>>", "<cmd>vertical resize +20<cr>")
map("n", "<leader><<<<", "<cmd>vertical resize -20<cr>")
map("n", "<leader>,>>", "<cmd>horizontal resize +5<cr>")
map("n", "<leader>,<<", "<cmd>horizontal resize -5<cr>")
map("n", "<leader>,>>>", "<cmd>horizontal resize +10<cr>")
map("n", "<leader>,<<<", "<cmd>horizontal resize -10<cr>")
map("n", "<leader>,>>>>", "<cmd>horizontal resize +20<cr>")
map("n", "<leader>,<<<<", "<cmd>horizontal resize -20<cr>")

map("n", "<leader>repl", "<cmd>ConjureCljConnectPortFile<cr>")
map("n", "<leader>par", "<cmd>ParinferOn<cr>")
map("n", "<leader>nopar", "<cmd>ParinferOff<cr>")
map("n", "<leader>gg", "<cmd>GitGutterEnable<cr>")
map("n", "<leader>rt", "<cmd>retab<cr>")

map("n", "case", "<cmd>CaseMasterRotateCase<cr>", { silent = true })
map("v", "case", "<cmd>CaseMasterRotateCaseVisual<cr>", { silent = true })
map("n", "css", "<cmd>CaseMasterConvertToSnake<cr>", { silent = true })
map("n", "csk", "<cmd>CaseMasterConvertToKebab<cr>", { silent = true })
map("n", "csc", "<cmd>CaseMasterConvertToCamel<cr>", { silent = true })
map("n", "csp", "<cmd>CaseMasterConvertToPascal<cr>", { silent = true })
map("n", "csm", "<cmd>CaseMasterConvertToMacro<cr>", { silent = true })
map("v", "css", "<cmd>CaseMasterConvertToSnake<cr>", { silent = true })
map("v", "csk", "<cmd>CaseMasterConvertToKebab<cr>", { silent = true })
map("v", "csc", "<cmd>CaseMasterConvertToCamel<cr>", { silent = true })
map("v", "csp", "<cmd>CaseMasterConvertToPascal<cr>", { silent = true })
map("v", "csm", "<cmd>CaseMasterConvertToMacro<cr>", { silent = true })

map("x", "ga", "<Plug>(EasyAlign)", { remap = true })
map("n", "ga", "<Plug>(EasyAlign)", { remap = true })

map("n", "<leader>`", function()
  vim.cmd("tabn " .. (vim.g.lasttab or 1))
end)
for i = 1, 9 do
  map("n", "<leader>" .. i, i .. "gt")
end
map("n", "<leader>0", "<cmd>tablast<cr>")

map("", "<ScrollWheelDown>", "j")
map("", "<ScrollWheelUp>", "k")

map("n", "<leader>lib", clj.find_library_versions)
map("n", "<leader>tap", clj.tap_expression)
map("n", "<leader>port", clj.add_lib_portal)
map("n", "<leader>ptap", clj.add_tap_expression)
map("n", "<leader>pget", "<cmd>ConjureEval (do (require 'portal.api) (portal.api/selected))<cr>")
map("n", "<leader>rtap", clj.remove_tap_expression)
map("n", "<leader>tone", clj.run_test)
map("n", "<leader>tall", clj.run_tests)
map("n", "<leader>efn", clj.eval_fn)
map("n", "<leader>pid", clj.get_pid)
map("n", "<leader>wrf", clj.warn_on_reflection)

map("n", "<leader>lua", function()
  require("stylua-nvim").format_file()
end)
map("n", "<leader>,test", "<cmd>ConjureEval (clojure.test/run-tests)<cr>")
map("n", "<leader>rns", "<cmd>ConjureEval (require (ns-name *ns*) :reload)<cr>")
map(
  "n",
  "<leader>rst",
  "<cmd>ConjureEval (do (rules.core/reset-rules!) (rules.core/reset-loader!))<cr>"
)
map(
  "n",
  "<leader>hto",
  "<cmd>ConjureEval (do (require '[pjstadig.humane-test-output]) (pjstadig.humane-test-output/activate!))<cr>"
)

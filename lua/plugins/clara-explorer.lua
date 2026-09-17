-- clara-rules-explorer Neovim client, loaded from a local checkout.
-- The repo root comes from CLARA_HOME_EXPLORER (read once at startup).
local clara_root = vim.env.CLARA_HOME_EXPLORER
if not clara_root then
  vim.notify("CLARA_HOME_EXPLORER is not set — clara-explorer not loaded", vim.log.levels.WARN)
  return
end

local clj = require("helpers.clojure")

vim.opt.runtimepath:append(clara_root .. "/editor/neovim")

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("ClaraExplorer", { clear = true }),
  pattern = "clojure",
  callback = function(args)
    local function map(lhs, rhs, desc)
      vim.keymap.set("n", lhs, rhs, { buffer = args.buf, desc = desc })
    end
    map("<leader>cra", clj.analyze_ruleset, "Clara: run ruleset network analysis")
    map("<leader>crl", "<cmd>ClaraExplorerRefresh<cr>", "Clara: refresh analysis")
    map("<leader>crs", "<cmd>ClaraExplorerSwapSession<cr>", "Clara: swap session")
    map("<leader>crS", "<cmd>ClaraExplorerSwapSession!<cr>", "Clara: swap session (re-prompt)")
    map("grp", "<cmd>ClaraExplorerNavigateProducer<cr>", "Clara: navigate to producer")
    map("grc", "<cmd>ClaraExplorerNavigateConsumer<cr>", "Clara: navigate to consumer")
  end,
})

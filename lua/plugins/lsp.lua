local ok_cnl, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
local ok_util, lsputil = pcall(require, "lspconfig.util")
if not (ok_cnl and ok_util) then
  return
end

vim.diagnostic.config({
  virtual_text = false,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.INFO] = " ",
      [vim.diagnostic.severity.HINT] = "",
    },
    numhl = {
      [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
      [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
      [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
      [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
    },
    texthl = {
      [vim.diagnostic.severity.ERROR] = "LspDiagnosticSignError",
      [vim.diagnostic.severity.WARN] = "LspDiagnosticSignWarn",
      [vim.diagnostic.severity.INFO] = "LspDiagnosticSignInfo",
      [vim.diagnostic.severity.HINT] = "LspDiagnosticSignHint",
    },
  },
})

local handlers = {
  ["textDocument/hover"] = function(args)
    vim.lsp.handlers.hover(vim.tbl_extend("force", { border = "single" }, args or {}))
  end,
  ["textDocument/signatureHelp"] = function(args)
    vim.lsp.handlers.signature_help(vim.tbl_extend("force", { border = "single" }, args or {}))
  end,
}

local function on_attach(_client, bufnr)
  vim.bo[bufnr].formatexpr = "v:lua.vim.lsp.formatexpr(#{timeout_ms:1000})"
  local function bopts(desc)
    return { buffer = bufnr, noremap = true, silent = true, desc = desc }
  end
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, bopts("Goto definition"))
  vim.keymap.set("n", "K", vim.lsp.buf.hover, bopts("Hover"))
  vim.keymap.set("n", "<leader>dd", vim.lsp.buf.declaration, bopts("Goto declaration"))
  vim.keymap.set("n", "<leader>dt", vim.lsp.buf.type_definition, bopts("Goto type definition"))
  vim.keymap.set("n", "<leader>ds", vim.lsp.buf.signature_help, bopts("Signature help"))
  vim.keymap.set("n", "<leader>dn", vim.lsp.buf.rename, bopts("Rename symbol"))
  vim.keymap.set("n", "<leader>de", vim.diagnostic.open_float, bopts("Show diagnostic"))
  vim.keymap.set("n", "<leader>dq", vim.diagnostic.setloclist, bopts("Diagnostics → loclist"))
  vim.keymap.set({ "n", "v" }, "ff", function()
    vim.lsp.buf.format({ async = true })
  end, bopts("Format buffer"))
  vim.keymap.set("n", "<leader>dj", function()
    vim.diagnostic.goto_next()
  end, bopts("Next diagnostic"))
  vim.keymap.set("n", "<leader>dk", function()
    vim.diagnostic.goto_prev()
  end, bopts("Previous diagnostic"))
  vim.keymap.set({ "n", "v" }, "<leader>da", vim.lsp.buf.code_action, bopts("Code action"))
  vim.keymap.set("n", "<leader>dw", function()
    require("telescope.builtin").diagnostics()
  end, bopts("Workspace diagnostics"))
  vim.keymap.set("n", "<leader>dr", function()
    require("telescope.builtin").lsp_references()
  end, bopts("References"))
  vim.keymap.set("n", "<leader>di", function()
    require("telescope.builtin").lsp_implementations()
  end, bopts("Implementations"))
end

local capabilities =
  vim.tbl_deep_extend("force", lsputil.default_config.capabilities, cmp_nvim_lsp.default_capabilities())

vim.lsp.config("*", {
  on_attach = on_attach,
  handlers = handlers,
  capabilities = capabilities,
})

vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
    },
  },
})

vim.lsp.enable({ "clojure_lsp", "lua_ls" })

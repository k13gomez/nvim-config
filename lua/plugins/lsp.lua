local cmp_nvim_lsp = require("cmp_nvim_lsp")
local lsputil = require("lspconfig.util")

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
  local opts = { buffer = bufnr, noremap = true, silent = true }
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
  vim.keymap.set("n", "<leader>ld", vim.lsp.buf.declaration, opts)
  vim.keymap.set("n", "<leader>lt", vim.lsp.buf.type_definition, opts)
  vim.keymap.set("n", "<leader>lh", vim.lsp.buf.signature_help, opts)
  vim.keymap.set("n", "<leader>ln", vim.lsp.buf.rename, opts)
  vim.keymap.set("n", "<leader>le", vim.diagnostic.open_float, opts)
  vim.keymap.set("n", "<leader>lq", vim.diagnostic.setloclist, opts)
  vim.keymap.set({ "n", "v" }, "ff", function()
    vim.lsp.buf.format({ async = true })
  end, opts)
  vim.keymap.set("n", "<leader>lj", function()
    vim.diagnostic.goto_next()
  end, opts)
  vim.keymap.set("n", "<leader>lk", function()
    vim.diagnostic.goto_prev()
  end, opts)
  vim.keymap.set({ "n", "v" }, "<leader>la", vim.lsp.buf.code_action, opts)
  vim.keymap.set("n", "<leader>lw", function()
    require("telescope.builtin").diagnostics()
  end, opts)
  vim.keymap.set("n", "<leader>lr", function()
    require("telescope.builtin").lsp_references()
  end, opts)
  vim.keymap.set("n", "<leader>li", function()
    require("telescope.builtin").lsp_implementations()
  end, opts)
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

vim.lsp.enable({ "clojure_lsp", "lua_ls", "terraformls" })

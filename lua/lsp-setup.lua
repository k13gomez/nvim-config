-- Set up nvim-cmp.
local cmp_nvim_lsp = require("cmp_nvim_lsp")
local lsputil = require("lspconfig.util")-- If you want icons for diagnostic errors, you'll need to define them somewhere:

vim.diagnostic.config({
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

-- Set up vim.lsp.config
local handlers = {
  ["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    severity_sort = true,
    update_in_insert = false,
    underline = true,
    virtual_text = false,
  }),
  ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "single" }),
  ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "single" }),
}
local function on_attach(client, bufnr)
  vim.bo[bufnr].formatexpr = "v:lua.vim.lsp.formatexpr(#{timeout_ms:1000})"
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", { noremap = true })
  vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", { noremap = true })
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>ld", "<Cmd>lua vim.lsp.buf.declaration()<CR>", { noremap = true })
  vim.api.nvim_buf_set_keymap(
    bufnr,
    "n",
    "<leader>lt",
    "<cmd>lua vim.lsp.buf.type_definition()<CR>",
    { noremap = true }
  )
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>lh", "<cmd>lua vim.lsp.buf.signature_help()<CR>", { noremap = true })
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>ln", "<cmd>lua vim.lsp.buf.rename()<CR>", { noremap = true })
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>le", "<cmd>lua vim.diagnostic.open_float()<CR>", { noremap = true })
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>lq", "<cmd>lua vim.diagnostic.setloclist()<CR>", { noremap = true })
  vim.api.nvim_buf_set_keymap(
    bufnr,
    "n",
    "ff",
    "<cmd>lua vim.lsp.buf.format({async = true})<CR>",
    { noremap = true, silent = true }
  )
  vim.api.nvim_buf_set_keymap(
    bufnr,
    "v",
    "ff",
    "<cmd>lua vim.lsp.buf.format({async = true})<CR>",
    { noremap = true, silent = true }
  )
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>lj", "<cmd>lua vim.diagnostic.goto_next()<CR>", { noremap = true })
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>lk", "<cmd>lua vim.diagnostic.goto_prev()<CR>", { noremap = true })
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<CR>", { noremap = true })
  vim.api.nvim_buf_set_keymap(
    bufnr,
    "v",
    "<leader>la",
    "<cmd>lua vim.lsp.buf.range_code_action()<CR> ",
    { noremap = true }
  )
  vim.api.nvim_buf_set_keymap(
    bufnr,
    "n",
    "<leader>lw",
    ":lua require('telescope.builtin').diagnostics()<cr>",
    { noremap = true }
  )
  vim.api.nvim_buf_set_keymap(
    bufnr,
    "n",
    "<leader>lr",
    ":lua require('telescope.builtin').lsp_references()<cr>",
    { noremap = true }
  )
  return vim.api.nvim_buf_set_keymap(
    bufnr,
    "n",
    "<leader>li",
    ":lua require('telescope.builtin').lsp_implementations()<cr>",
    { noremap = true }
  )
end

local capabilities =
  vim.tbl_deep_extend("force", lsputil.default_config.capabilities, cmp_nvim_lsp.default_capabilities())

vim.lsp.config("*", {
  on_attach = on_attach,
  handlers = handlers,
  capabilities = capabilities,
})

local servers = { 'clojure_lsp', 'rust_analyzer', 'lua_ls' }

vim.lsp.enable(servers)

local elixir = require("elixir")
local elixirls = require("elixir.elixirls")

elixir.setup({
  nextls = { enable = false },
  elixirls = {
    enable = true,
    settings = elixirls.settings({
      dialyzerEnabled = false,
      enableTestLenses = true,
      suggestSpecs = true,
      fetchDeps = true,
    }),
    capabilities = capabilities,
    handlers = handlers,
    on_attach = function(client, bufnr)
      on_attach(client, bufnr)
      vim.api.nvim_buf_set_keymap(bufnr, "n", "efp", "<Cmd>ElixirFromPipe<CR>", { noremap = true })
      vim.api.nvim_buf_set_keymap(bufnr, "n", "etp", "<Cmd>ElixirToPipe<CR>", { noremap = true })
      vim.api.nvim_buf_set_keymap(bufnr, "v", "eem", "<Cmd>ElixirExpandMacro<CR>", { noremap = true })
      vim.api.nvim_buf_set_keymap(bufnr, "n", "ert", "<Cmd>lua vim.lsp.codelens.run()<CR>", { noremap = true })
    end,
  },
  projectionist = {
    enable = false,
  },
})

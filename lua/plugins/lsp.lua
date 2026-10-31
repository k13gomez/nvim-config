local ok_cnl, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not ok_cnl then
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
      [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
      [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
      [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
      [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
    },
  },
})

local function on_attach(client, bufnr)
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
  vim.keymap.set("n", "<leader>dj", function()
    vim.diagnostic.jump({ count = 1, float = true })
  end, bopts("Next diagnostic"))
  vim.keymap.set("n", "<leader>dk", function()
    vim.diagnostic.jump({ count = -1, float = true })
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
  vim.keymap.set("n", "<leader>dl", vim.lsp.codelens.run, bopts("Run code lens"))

  -- Only elixir-ls is set up with a client-side lens command below, so keep
  -- lens rendering off for the other servers.
  if client.name == "elixirls" then
    vim.lsp.codelens.enable(true, { bufnr = bufnr })
  end
end

vim.lsp.config("*", {
  on_attach = on_attach,
  capabilities = cmp_nvim_lsp.default_capabilities(),
})

-- Teach lua_ls the Neovim runtime, but only inside this config so other Lua projects keep their own settings.
vim.lsp.config("lua_ls", {
  on_init = function(client)
    local root = client.workspace_folders and client.workspace_folders[1]
    if not (root and vim.fs.normalize(root.name) == vim.fn.stdpath("config")) then
      return
    end
    client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua or {}, {
      runtime = { version = "LuaJIT" },
      workspace = { checkThirdParty = false, library = { vim.env.VIMRUNTIME } },
    })
  end,
})

-- "Run test" / "Run tests" / "Run tests in module" lenses. elixir-ls only
-- publishes the command; running it is the client's job, so register a handler
-- (see helpers.elixir.run_test_lens). Trigger with <leader>dl or grx.
vim.lsp.commands["elixir.lens.test.run"] = require("helpers.elixir").run_test_lens

vim.lsp.config("elixirls", {
  settings = {
    elixirLS = {
      dialyzerEnabled = true,
      fetchDeps = true,
      enableTestLenses = true,
    },
  },
})

vim.lsp.enable({ "clojure_lsp", "lua_ls", "elixirls" })

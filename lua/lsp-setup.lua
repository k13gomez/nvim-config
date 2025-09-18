-- Set up nvim-cmp.
local cmp = require("cmp")
local cmp_nvim_lsp = require("cmp_nvim_lsp")
local cmp_clojure_deps = require("cmp-clojure-deps")
local lsputil = require("lspconfig.util")

-- setup sources
cmp_nvim_lsp.setup({})
cmp_clojure_deps.setup({})

local path_options = {
  get_cwd = function(_params)
    return vim.fn.getcwd()
  end,
}

local compare = require("cmp.config.compare")
local lspkind = require("lspkind")

cmp.setup({
  formatting = {
    format = lspkind.cmp_format({
      mode = "symbol", -- show only symbol annotations
      maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
      -- can also be a function to dynamically calculate max width such as
      -- maxwidth = function() return math.floor(0.45 * vim.o.columns) end,
      symbol_map = {
        Text = "󰉿",
        Method = "󰆧",
        Function = "󰊕",
        Constructor = "",
        Field = "󰜢",
        Variable = "󰀫",
        Class = "󰠱",
        Interface = "",
        Module = "",
        Property = "󰜢",
        Unit = "󰑭",
        Value = "󰎠",
        Enum = "",
        Keyword = "󰌋",
        Snippet = "",
        Color = "󰏘",
        File = "󰈙",
        Reference = "󰈇",
        Folder = "󰉋",
        EnumMember = "",
        Constant = "󰏿",
        Struct = "󰙅",
        Event = "",
        Operator = "󰆕",
        TypeParameter = "",
      },
      ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
      show_labelDetails = true, -- show labelDetails in menu. Disabled by default

      -- The function below will be called before any actual modifications from lspkind
      -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
      before = function(entry, vim_item)
        vim_item.dup = { buffer = 0, path = 0, nvim_lsp = 0, conjure = 0 }
        return vim_item
      end,
    }),
  },
  sorting = {
    comparators = {
      compare.exact,
      compare.score,
      compare.order,
      compare.offset,
      compare.recently_used,
      compare.locality,
      compare.kind,
      compare.sort_text,
      compare.length,
    },
  },
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  window = {
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = "clojure-tools-deps", dup = 0 },
    { name = "nvim_lsp", dup = 0 },
    { name = "vsnip" },
    { name = "path", option = path_options, dup = 0 },
    { name = "conjure", dup = 0 },
  }, {
    { name = "buffer", dup = 0 },
  }),
})

-- Set configuration for specific filetype.
cmp.setup.filetype("gitcommit", {
  sources = cmp.config.sources({
    { name = "cmp_git", dup = 0 }, -- You can specify the `cmp_git` source if you were installed it.
  }, {
    { name = "buffer", dup = 0 },
  }),
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ "/", "?" }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = "buffer", dup = 0 },
  },
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "path", option = path_options, dup = 0 },
  }, {
    { name = "cmdline", dup = 0 },
  }),
})

-- If you want icons for diagnostic errors, you'll need to define them somewhere:
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

vim.lsp.config('clojure_lsp', {
  on_attach = on_attach,
  handlers = handlers,
  capabilities = capabilities,
  cmd = { "clojure-lsp" },
  filetypes = { "clojure" },
  root_dir = lsputil.root_pattern("deps.edn", "project.clj", ".git"),
})
vim.lsp.enable('clojure_lsp')

vim.lsp.config('rust_analyzer', {
  on_attach = on_attach,
  handlers = handlers,
  capabilities = capabilities,
  cmd = { "rust-analyzer" },
  filetypes = { "rust" },
  root_dir = lsputil.root_pattern("Cargo.toml"),
  settings = {
    ["rust_analyzer"] = {
      cargo = {
        allFeatures = true,
      },
    },
  },
})
vim.lsp.enable('rust_analyzer')

vim.lsp.config('gopls', {
  on_attach = on_attach,
  handlers = handlers,
  capabilities = capabilities,
  cmd = { "gopls" },
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  root_dir = lsputil.root_pattern("go.work", "go.mod", ".git"),
  settings = {
    gopls = {
      completeUnimported = true,
      usePlaceholders = true,
      analyses = {
        unusedparams = true,
      },
    },
  },
})
vim.lsp.enable('gopls')

vim.lsp.config('lua_ls', {
  on_attach = on_attach,
  handlers = handlers,
  capabilities = capabilities,
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  commands = {
    Format = {
      function()
        require("stylua-nvim").format_file()
      end,
    },
  },
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = "LuaJIT",
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { "vim" },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
})
vim.lsp.enable('lua_ls')

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
    on_attach = function(client, bufnr)
      vim.bo[bufnr].formatexpr = "v:lua.vim.lsp.formatexpr(#{timeout_ms:1000})"
      vim.api.nvim_buf_set_keymap(bufnr, "n", "efp", "<Cmd>ElixirFromPipe<CR>", { noremap = true })
      vim.api.nvim_buf_set_keymap(bufnr, "n", "etp", "<Cmd>ElixirToPipe<CR>", { noremap = true })
      vim.api.nvim_buf_set_keymap(bufnr, "v", "eem", "<Cmd>ElixirExpandMacro<CR>", { noremap = true })
      vim.api.nvim_buf_set_keymap(bufnr, "n", "ert", "<Cmd>lua vim.lsp.codelens.run()<CR>", { noremap = true })

      vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", { noremap = true })
      vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", { noremap = true })
      vim.api.nvim_buf_set_keymap(
        bufnr,
        "n",
        "<leader>ld",
        "<Cmd>lua vim.lsp.buf.declaration()<CR>",
        { noremap = true }
      )
      vim.api.nvim_buf_set_keymap(
        bufnr,
        "n",
        "<leader>lt",
        "<cmd>lua vim.lsp.buf.type_definition()<CR>",
        { noremap = true }
      )
      vim.api.nvim_buf_set_keymap(
        bufnr,
        "n",
        "<leader>lh",
        "<cmd>lua vim.lsp.buf.signature_help()<CR>",
        { noremap = true }
      )
      vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>ln", "<cmd>lua vim.lsp.buf.rename()<CR>", { noremap = true })
      vim.api.nvim_buf_set_keymap(
        bufnr,
        "n",
        "<leader>le",
        "<cmd>lua vim.diagnostic.open_float()<CR>",
        { noremap = true }
      )
      vim.api.nvim_buf_set_keymap(
        bufnr,
        "n",
        "<leader>lq",
        "<cmd>lua vim.diagnostic.setloclist()<CR>",
        { noremap = true }
      )
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
      vim.api.nvim_buf_set_keymap(
        bufnr,
        "n",
        "<leader>lj",
        "<cmd>lua vim.diagnostic.goto_next()<CR>",
        { noremap = true }
      )
      vim.api.nvim_buf_set_keymap(
        bufnr,
        "n",
        "<leader>lk",
        "<cmd>lua vim.diagnostic.goto_prev()<CR>",
        { noremap = true }
      )
      vim.api.nvim_buf_set_keymap(
        bufnr,
        "n",
        "<leader>la",
        "<cmd>lua vim.lsp.buf.code_action()<CR>",
        { noremap = true }
      )
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
    end,
  },
  projectionist = {
    enable = false,
  },
})

vim.lsp.config('terraformls', {})
vim.lsp.enable('terraformls')

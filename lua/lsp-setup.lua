-- Set up nvim-cmp.
local cmp = require('cmp')
local cmp_nvim_lsp = require('cmp_nvim_lsp')
local cmp_clojure_deps = require('cmp-clojure-deps')
local lspconfig = require('lspconfig')

-- setup sources
cmp_nvim_lsp.setup({})
cmp_clojure_deps.setup({})

local path_options = {
  get_cwd = function(_params)
    return vim.fn.getcwd()
  end,
}

local compare = require('cmp.config.compare')

cmp.setup({
    formatting = {
        format = function (entry, vim_item)
            vim_item.dup = { buffer = 0, path = 0, nvim_lsp = 0, conjure = 0 }
            return vim_item
        end
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
        compare.length
      }
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
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
      }),
    sources = cmp.config.sources({
        { name = 'clojure-tools-deps', dup = 0 },
        { name = 'nvim_lsp', dup = 0 },
        { name = 'vsnip' },
        { name = 'path', option = path_options, dup = 0 },
        { name = 'conjure', dup = 0},
      }, {
        { name = 'buffer', dup = 0 },
      })
  })

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
        { name = 'cmp_git', dup = 0 }, -- You can specify the `cmp_git` source if you were installed it.
        }, {
          { name = 'buffer', dup = 0 },
        })
    })

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer', dup = 0 }
    }
  })

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path', option = path_options, dup = 0 }
      }, {
        { name = 'cmdline', dup = 0 }
      })
  })

-- Set up lspconfig.
local error = "LspDiagnosticsSignError"
local warn = "LspDiagnosticsSignWarn"
local info = "LspDiagnosticsSignInfo"
local hint = "LspDiagnosticsSignHint"
vim.fn.sign_define(error, {text = "x", texthl = error})
vim.fn.sign_define(warn, {text = "!", texthl = warn})
vim.fn.sign_define(info, {text = "i", texthl = info})
vim.fn.sign_define(hint, {text = "?", texthl = hint})

local handlers = {
["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  severity_sort = true,
  update_in_insert = false,
  underline = true,
  virtual_text = false
}),
["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {border = "single"}),
["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {border = "single"})
}
local function on_attach(client, bufnr)
vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", {noremap = true})
vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", {noremap = true})
vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>ld", "<Cmd>lua vim.lsp.buf.declaration()<CR>", {noremap = true})
vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>lt", "<cmd>lua vim.lsp.buf.type_definition()<CR>", {noremap = true})
vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>lh", "<cmd>lua vim.lsp.buf.signature_help()<CR>", {noremap = true})
vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>ln", "<cmd>lua vim.lsp.buf.rename()<CR>", {noremap = true})
vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>le", "<cmd>lua vim.diagnostic.open_float()<CR>", {noremap = true})
vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>lq", "<cmd>lua vim.diagnostic.setloclist()<CR>", {noremap = true})
vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>lf", "<cmd>lua vim.lsp.buf.format()<CR>", {noremap = true})
vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>lj", "<cmd>lua vim.diagnostic.goto_next()<CR>", {noremap = true})
vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>lk", "<cmd>lua vim.diagnostic.goto_prev()<CR>", {noremap = true})
vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<CR>", {noremap = true})
vim.api.nvim_buf_set_keymap(bufnr, "v", "<leader>la", "<cmd>lua vim.lsp.buf.range_code_action()<CR> ", {noremap = true})
vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>lw", ":lua require('telescope.builtin').diagnostics()<cr>", {noremap = true})
vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>lr", ":lua require('telescope.builtin').lsp_references()<cr>", {noremap = true})
return vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>li", ":lua require('telescope.builtin').lsp_implementations()<cr>", {noremap = true})
end

local capabilities = vim.tbl_deep_extend(
  'force',
  lspconfig.util.default_config.capabilities,
  cmp_nvim_lsp.default_capabilities()
)

lspconfig.clojure_lsp.setup({on_attach = on_attach, handlers = handlers, capabilities = capabilities})

lspconfig.lua_ls.setup({
    on_attach = on_attach,
    handlers = handlers,
    settings = {
      Lua = {
        runtime = {
          -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
          version = 'LuaJIT',
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = {'vim'},
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

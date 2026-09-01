local ok_cmp, cmp = pcall(require, "cmp")
local ok_cnl, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
local ok_ccd, cmp_clojure_deps = pcall(require, "cmp-clojure-deps")
local ok_cmp_compare, compare = pcall(require, "cmp.config.compare")
local ok_lspkind, lspkind = pcall(require, "lspkind")
if not (ok_cmp and ok_cnl and ok_ccd and ok_cmp_compare and ok_lspkind) then
  return
end

cmp_nvim_lsp.setup({})
cmp_clojure_deps.setup({})

local path_options = {
  get_cwd = function(_params)
    return vim.fn.getcwd()
  end,
}

cmp.setup({
  formatting = {
    format = lspkind.cmp_format({
      mode = "symbol",
      maxwidth = 50,
      symbol_map = {
        Text = "󰉿",
        Method = "󰆧",
        Function = "󰊕",
        Constructor = "",
        Field = "󰜢",
        Variable = "󰀫",
        Class = "󰠱",
        Interface = "",
        Module = "",
        Property = "󰜢",
        Unit = "󰑭",
        Value = "󰎠",
        Enum = "",
        Keyword = "󰌋",
        Snippet = "",
        Color = "󰏘",
        File = "󰈙",
        Reference = "󰈇",
        Folder = "󰉋",
        EnumMember = "",
        Constant = "󰏿",
        Struct = "󰙅",
        Event = "",
        Operator = "󰆕",
        TypeParameter = "",
      },
      ellipsis_char = "...",
      show_labelDetails = true,
      before = function(_entry, vim_item)
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
    expand = function(args)
      vim.snippet.expand(args.body)
    end,
  },
  window = {},
  mapping = cmp.mapping.preset.insert({
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm({ select = false }),
  }),
  sources = cmp.config.sources({
    { name = "clojure-tools-deps", dup = 0 },
    { name = "nvim_lsp", dup = 0 },
    { name = "path", option = path_options, dup = 0 },
    { name = "conjure", dup = 0 },
  }, {
    { name = "buffer", dup = 0 },
  }),
})

cmp.setup.filetype("gitcommit", {
  sources = cmp.config.sources({
    { name = "cmp_git", dup = 0 },
  }, {
    { name = "buffer", dup = 0 },
  }),
})

cmp.setup.cmdline({ "/", "?" }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = "buffer", dup = 0 },
  },
})

cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "path", option = path_options, dup = 0 },
  }, {
    { name = "cmdline", dup = 0 },
  }),
})

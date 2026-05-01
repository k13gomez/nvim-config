local ok_ts, ts = pcall(require, "nvim-treesitter")
local ok_rd, rainbow_delimiters = pcall(require, "rainbow-delimiters")
if not (ok_ts and ok_rd) then
  return
end

ts.setup()

-- start every window with folds open; per-buffer foldmethod/foldexpr below
-- still controls how folds are computed when the user toggles them on.
vim.opt.foldenable = false

local function activate(buf, lang)
  if not vim.treesitter.query.get(lang, "highlights") then
    return
  end
  pcall(vim.treesitter.start, buf, lang)

  if vim.treesitter.query.get(lang, "indents") then
    vim.bo[buf].indentexpr = 'v:lua.require("nvim-treesitter").indentexpr()'
  end

  if vim.treesitter.query.get(lang, "folds") then
    vim.opt_local.foldmethod = "expr"
    vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
  end
end

local installing = {}

local ts_group = vim.api.nvim_create_augroup("TreesitterAutoStart", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = ts_group,
  callback = function(args)
    local buf = args.buf
    local ft = args.match
    local lang = vim.treesitter.language.get_lang(ft)
    if not lang then
      return
    end

    local config = require("nvim-treesitter.config")

    if vim.tbl_contains(config.get_installed("parsers"), lang) then
      activate(buf, lang)
      return
    end

    if not vim.tbl_contains(config.get_available(), lang) then
      return
    end

    if installing[lang] then
      table.insert(installing[lang], { buf = buf, ft = ft })
      return
    end
    installing[lang] = { { buf = buf, ft = ft } }

    ts.install(lang):await(function(err)
      local queued = installing[lang]
      installing[lang] = nil
      if err then
        return
      end
      vim.schedule(function()
        for _, item in ipairs(queued) do
          if vim.api.nvim_buf_is_valid(item.buf) and vim.bo[item.buf].filetype == item.ft then
            activate(item.buf, lang)
          end
        end
      end)
    end)
  end,
})

vim.g.rainbow_delimiters = {
  strategy = {
    [""] = rainbow_delimiters.strategy["global"],
    vim = rainbow_delimiters.strategy["local"],
  },
  query = {
    [""] = "rainbow-delimiters",
    lua = "rainbow-blocks",
  },
  priority = {
    [""] = 110,
    lua = 210,
  },
  highlight = {
    "RainbowDelimiterRed",
    "RainbowDelimiterYellow",
    "RainbowDelimiterBlue",
    "RainbowDelimiterOrange",
    "RainbowDelimiterGreen",
    "RainbowDelimiterViolet",
    "RainbowDelimiterCyan",
  },
}

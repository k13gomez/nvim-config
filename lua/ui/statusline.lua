local ok, lualine = pcall(require, "lualine")
if not ok then
  return
end

vim.opt.showmode = false
vim.opt.showtabline = 2

-- A manual <leader>Tr name wins over the title the shell sets via OSC 2 (see .zshrc title hooks).
local function term_label(buf)
  return vim.b[buf].term_name or vim.b[buf].term_title
end

-- Name each tab "dir/file" from the buffer in its active window, as the old tabline did.
-- Terminal tabs use the terminal's title, unless :LualineRenameTab already named the tab.
local function tab_name(name, tab)
  if vim.t[tab.tabId].tabname then
    return name
  end
  if tab.buftype == "terminal" then
    local buf = vim.fn.tabpagebuflist(tab.tabnr)[vim.fn.tabpagewinnr(tab.tabnr)]
    return term_label(buf) or name
  end
  if tab.file == "" or tab.buftype ~= "" then
    return name
  end
  return vim.fn.fnamemodify(tab.file, ":h:t") .. "/" .. vim.fn.fnamemodify(tab.file, ":t")
end

local function file_name(name)
  if vim.bo.buftype == "terminal" then
    return term_label(0) or name
  end
  return name
end

lualine.setup({
  -- "material" can resolve to lualine's own built-in theme, so use the name only material.nvim ships.
  options = { theme = "material-nvim" },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch", "diff", "diagnostics" },
    lualine_c = { { "filename", path = 2, fmt = file_name } },
    lualine_x = { "filetype", "encoding", "fileformat" },
    lualine_y = { "%l/%L (%p%%)" },
    lualine_z = { { "Col: %v", type = "stl" }, { "[%b][0x%B]", type = "stl" } },
  },
  tabline = {
    lualine_a = {
      { "tabs", mode = 2, max_length = vim.o.columns, show_modified_status = true, fmt = tab_name },
    },
  },
})

-- lualine repaints the tabline on a 1s timer; refresh as soon as a terminal retitles itself.
vim.api.nvim_create_autocmd("TermRequest", {
  group = vim.api.nvim_create_augroup("LualineTermTitle", { clear = true }),
  callback = function(args)
    if args.data.sequence:match("^\27%][02];") then
      lualine.refresh({ place = { "tabline", "statusline" } })
    end
  end,
})

local ok, lualine = pcall(require, "lualine")
if not ok then
  return
end

vim.opt.showmode = false
vim.opt.showtabline = 2

-- Name each tab "dir/file" from the buffer in its active window, as the old tabline did.
local function tab_name(name, tab)
  if tab.file == "" or tab.buftype ~= "" then
    return name
  end
  return vim.fn.fnamemodify(tab.file, ":h:t") .. "/" .. vim.fn.fnamemodify(tab.file, ":t")
end

lualine.setup({
  -- "material" can resolve to lualine's own built-in theme, so use the name only material.nvim ships.
  options = { theme = "material-nvim" },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch", "diff", "diagnostics" },
    lualine_c = { { "filename", path = 2 } },
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

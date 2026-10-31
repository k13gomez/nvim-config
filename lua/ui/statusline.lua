vim.g.currentmode = {
  n = "Normal",
  no = "Normal·Operator Pending",
  v = "Visual",
  V = "V·Line",
  ["\22"] = "V·Block",
  s = "Select",
  S = "S·Line",
  ["\19"] = "S·Block",
  i = "Insert",
  R = "Replace",
  Rv = "V·Replace",
  c = "Command",
  cv = "Vim Ex",
  ce = "Ex",
  r = "Prompt",
  rm = "More",
  ["r?"] = "Confirm",
  ["!"] = "Shell",
  t = "Terminal",
}

vim.opt.laststatus = 2
vim.opt.showmode = false

vim.opt.statusline = table.concat({
  "%0* %n ",
  "%1* %<%F%m%r%h%w ",
  "%3*│",
  "%2* %Y ",
  "%3*│",
  "%2* %{''.(&fenc!=''?&fenc:&enc).''}",
  " (%{&ff})",
  " %{FugitiveStatusline()}",
  "%=",
  "%2* Col: %02v ",
  "%3*│",
  "%1* Line: %02l/%L (%3p%%) ",
  " [%b][0x%B] ",
  "%0* %{toupper(g:currentmode[mode()])} ",
})

local colors = require("material.colors")

local function statusline_bg(bg)
  vim.api.nvim_set_hl(0, "StatusLine", { fg = colors.editor.bg, bg = bg })
end

local group = vim.api.nvim_create_augroup("StatuslineColors", { clear = true })
vim.api.nvim_create_autocmd("InsertEnter", {
  group = group,
  callback = function()
    statusline_bg(colors.main.purple)
  end,
})
vim.api.nvim_create_autocmd("InsertLeave", {
  group = group,
  callback = function()
    statusline_bg(colors.main.blue)
  end,
})
statusline_bg(colors.main.blue)

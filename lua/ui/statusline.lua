vim.g.currentmode = {
  n = "Normal",
  no = "Normal·Operator Pending",
  v = "Visual",
  V = "V·Line",
  ["^V"] = "V·Block",
  s = "Select",
  S = "S·Line",
  ["^S"] = "S·Block",
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

local group = vim.api.nvim_create_augroup("StatuslineColors", { clear = true })
vim.api.nvim_create_autocmd("InsertEnter", {
  group = group,
  callback = function()
    vim.cmd("hi statusline guifg=black guibg=#d7afff ctermfg=black ctermbg=magenta")
  end,
})
vim.api.nvim_create_autocmd("InsertLeave", {
  group = group,
  callback = function()
    vim.cmd("hi statusline guifg=black guibg=#8fbfdc ctermfg=black ctermbg=cyan")
  end,
})
vim.cmd("hi statusline guifg=black guibg=#8fbfdc ctermfg=gray ctermbg=cyan")

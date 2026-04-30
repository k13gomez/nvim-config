local group = vim.api.nvim_create_augroup("UserAutocmds", { clear = true })

vim.api.nvim_create_autocmd("TabLeave", {
  group = group,
  callback = function()
    vim.g.lasttab = vim.fn.tabpagenr()
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  group = group,
  pattern = { "*.tf", "*.tfvars" },
  callback = function()
    vim.lsp.buf.format()
  end,
})

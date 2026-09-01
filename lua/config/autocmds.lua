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

vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = { "elixir", "eelixir", "heex", "surface" },
  callback = function(args)
    vim.bo[args.buf].shiftwidth = 2
    vim.bo[args.buf].tabstop = 2
    vim.bo[args.buf].softtabstop = 2
    vim.bo[args.buf].expandtab = true
  end,
})

-- elixir-ls is slow until the project has compiled, so give it a longer leash
-- than the terraform formatter above.
vim.api.nvim_create_autocmd("BufWritePre", {
  group = group,
  pattern = { "*.ex", "*.exs", "*.heex", "*.eex" },
  callback = function()
    vim.lsp.buf.format({ timeout_ms = 3000 })
  end,
})

-- `mix test` output (helpers/elixir.lua) lands in a terminal split that goes
-- read-only once the job exits. Give finished terminals a plain `q` to dismiss.
vim.api.nvim_create_autocmd("TermClose", {
  group = group,
  callback = function(args)
    vim.keymap.set("n", "q", "<cmd>bdelete!<cr>", {
      buffer = args.buf,
      nowait = true,
      desc = "Close finished terminal",
    })
  end,
})

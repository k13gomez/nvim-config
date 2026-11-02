local group = vim.api.nvim_create_augroup("UserAutocmds", { clear = true })

vim.api.nvim_create_autocmd("TabLeave", {
  group = group,
  callback = function()
    vim.g.lasttab = vim.fn.tabpagenr()
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = { "elixir", "eelixir", "heex", "surface", "json", "jsonc" },
  callback = function(args)
    vim.bo[args.buf].shiftwidth = 2
    vim.bo[args.buf].tabstop = 2
    vim.bo[args.buf].softtabstop = 2
    vim.bo[args.buf].expandtab = true
  end,
})

-- `mix test` output (helpers/elixir.lua) lands in a terminal split that goes
-- read-only once the job exits. Give finished terminals a plain `q` to dismiss.
vim.api.nvim_create_autocmd("TermClose", {
  group = group,
  callback = function(args)
    -- nvim's own TermClose handler has already wiped shells that exited cleanly.
    if not vim.api.nvim_buf_is_valid(args.buf) then
      return
    end
    vim.keymap.set("n", "q", "<cmd>bdelete!<cr>", {
      buffer = args.buf,
      nowait = true,
      desc = "Close finished terminal",
    })
  end,
})

-- Only live shells get auto-insert. The `mix` split must stay in normal mode, or the
-- first key after the job exits would close it before the output can be read.
local function enter_live_shell(buf)
  local name = vim.api.nvim_buf_get_name(buf)
  local running = vim.fn.jobwait({ vim.bo[buf].channel }, 0)[1] == -1
  if running and vim.endswith(name, ":" .. vim.o.shell) then
    vim.cmd.startinsert()
  end
end

vim.api.nvim_create_autocmd("TermOpen", {
  group = group,
  callback = function(args)
    vim.wo.number = false
    vim.wo.relativenumber = false
    vim.wo.signcolumn = "no"
    enter_live_shell(args.buf)
  end,
})

-- Like switching tmux panes: landing on a terminal window resumes the live shell.
vim.api.nvim_create_autocmd({ "BufWinEnter", "WinEnter" }, {
  group = group,
  pattern = "term://*",
  callback = function(args)
    enter_live_shell(args.buf)
  end,
})

local M = {}

function M.render()
  local s = ""
  local current = vim.fn.tabpagenr()
  for i = 1, vim.fn.tabpagenr("$") do
    local winnr = vim.fn.tabpagewinnr(i)
    local buflist = vim.fn.tabpagebuflist(i)
    local bufnr = buflist[winnr]
    local bufname = vim.fn.bufname(bufnr)
    local modified = vim.fn.getbufvar(bufnr, "&mod") == 1

    s = s .. "%" .. i .. "T"
    s = s .. (i == current and "%#TabLineSel#" or "%#TabLine#")
    s = s .. " " .. i .. ":"
    if bufname ~= "" then
      s = s
        .. "["
        .. vim.fn.fnamemodify(bufname, ":h:t")
        .. "/"
        .. vim.fn.fnamemodify(bufname, ":t")
        .. "] "
    else
      s = s .. "[No Name] "
    end
    if modified then
      s = s .. "[+] "
    end
  end
  return s .. "%#TabLineFill#"
end

vim.opt.showtabline = 2
vim.opt.tabline = "%!v:lua.require'ui.tabline'.render()"

return M

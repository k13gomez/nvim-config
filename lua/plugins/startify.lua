local image = require("ui.banner")

local M = {}

local stats

local banner = vim.fn.readfile(vim.fn.stdpath("config") .. "/banner.txt")

function _G.startify_header()
  -- Memoized so a later :Startify keeps showing startup time, not time since launch.
  if not stats then
    local ms = (vim.uv.hrtime() - vim.g.start_time) / 1e6
    stats = string.format("Neovim loaded %d plugins in %.2f ms", #vim.pack.get(), ms)
  end
  local header = image.enabled() and image.blank_lines() or vim.deepcopy(banner)
  vim.list_extend(header, { "", stats })
  return vim.fn["startify#pad"](header)
end

vim.g.startify_custom_header = "v:lua.startify_header()"

local group = vim.api.nvim_create_augroup("StartifyImage", { clear = true })

local function close()
  if #vim.api.nvim_list_tabpages() > 1 and #vim.api.nvim_tabpage_list_wins(0) == 1 then
    vim.cmd.tabclose()
  -- Otherwise what startify's own q does. The start screen buffer is unlisted.
  elseif #vim.fn.getbufinfo({ buflisted = 1 }) > 0 then
    vim.cmd(vim.fn.bufloaded(vim.fn.bufnr("#")) == 1 and "buffer #" or "bnext")
  else
    vim.cmd.quit()
  end
end

-- Startified runs before the start screen is drawn, so the image waits for the next loop.
vim.api.nvim_create_autocmd("User", {
  group = group,
  pattern = "Startified",
  callback = function()
    if vim.t.startify_tab then
      vim.keymap.set("n", "q", close, { buffer = 0, nowait = true, desc = "Close start screen tab" })
    end
    if image.enabled() then
      vim.schedule(image.refresh)
    end
  end,
})

-- Leaving the start screen, resizing or a style switch must remove the old image.
-- Coming back to it, for example when the ,fs picker closes, draws the image again.
vim.api.nvim_create_autocmd({ "BufEnter", "BufLeave", "VimResized", "ColorScheme" }, {
  group = group,
  callback = function(args)
    local buffer_event = args.event == "BufEnter" or args.event == "BufLeave"
    if image.enabled() and (not buffer_event or vim.bo[args.buf].filetype == "startify") then
      vim.schedule(image.refresh)
    end
  end,
})

-- Never replaces the current buffer: go to a start screen already shown, or open one in a new tab.
function M.open()
  if vim.bo.filetype == "startify" then
    return
  end
  for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
      if vim.bo[vim.api.nvim_win_get_buf(win)].filetype == "startify" then
        vim.api.nvim_set_current_win(win)
        return
      end
    end
  end
  vim.cmd.tabnew()
  vim.t.startify_tab = true
  -- Startify reuses the empty buffer from tabnew.
  vim.cmd.Startify()
end

return M

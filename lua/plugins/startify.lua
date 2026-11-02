local image = require("ui.banner")

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

-- Startified runs before the start screen is drawn, so the image waits for the next loop.
vim.api.nvim_create_autocmd("User", {
  group = group,
  pattern = "Startified",
  callback = function()
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

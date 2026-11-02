local stats

local banner = {
  "██╗  ██╗ ██╗██████╗  ██████╗  ██████╗ ███╗   ███╗███████╗███████╗",
  "██║ ██╔╝███║╚════██╗██╔════╝ ██╔═══██╗████╗ ████║██╔════╝╚══███╔╝",
  "█████╔╝ ╚██║ █████╔╝██║  ███╗██║   ██║██╔████╔██║█████╗    ███╔╝",
  "██╔═██╗  ██║ ╚═══██╗██║   ██║██║   ██║██║╚██╔╝██║██╔══╝   ███╔╝",
  "██║  ██╗ ██║██████╔╝╚██████╔╝╚██████╔╝██║ ╚═╝ ██║███████╗███████╗",
  "╚═╝  ╚═╝ ╚═╝╚═════╝  ╚═════╝  ╚═════╝ ╚═╝     ╚═╝╚══════╝╚══════╝",
}

function _G.startify_header()
  -- Memoized so a later :Startify keeps showing startup time, not time since launch.
  if not stats then
    local ms = (vim.uv.hrtime() - vim.g.start_time) / 1e6
    stats = string.format("Neovim loaded %d plugins in %.2f ms", #vim.pack.get(), ms)
  end
  local header = vim.deepcopy(banner)
  vim.list_extend(header, { "", stats })
  return vim.fn["startify#pad"](header)
end

vim.g.startify_custom_header = "v:lua.startify_header()"

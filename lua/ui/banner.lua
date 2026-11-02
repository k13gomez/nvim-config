-- Shows neovimium.png on the start screen as a sixel image.
-- The image size comes from the cell size in pixels. Only tmux reports it, so the image needs tmux with sixel support.
local M = {}

M.rows = 10

local png = vim.fn.stdpath("config") .. "/neovimium.png"
local cache = {}
local enabled

local function tmux(format)
  local env = vim.g.tmux_env or {}
  if not env.TMUX then
    return nil
  end
  local res = vim.system({ "tmux", "display", "-p", format }, { env = env, text = true }):wait()
  return res.code == 0 and vim.trim(res.stdout) or nil
end

function M.enabled()
  if enabled == nil then
    local ui = vim.api.nvim_list_uis()[1]
    enabled = ui ~= nil
      and ui.stdout_tty == true
      and vim.env.TERM_PROGRAM == "tmux"
      and vim.fn.executable("magick") == 1
      and tmux("#{sixel_support}") == "1"
  end
  return enabled
end

function M.blank_lines()
  local lines = {}
  for i = 1, M.rows do
    lines[i] = ""
  end
  return lines
end

-- The PNG is flattened onto the theme background, so a style switch with ,fs still matches.
local function sixel(w, h)
  local bg = vim.api.nvim_get_hl(0, { name = "Normal", link = false }).bg
  local key = table.concat({ w, h, bg or "none" }, ":")
  if not cache[key] then
    local res = vim
      .system({
        "magick",
        png,
        "-background",
        bg and string.format("#%06x", bg) or "none",
        "-flatten",
        "-resize",
        w .. "x" .. h,
        "sixel:-",
      })
      :wait()
    cache[key] = res.code == 0 and res.stdout or ""
  end
  return cache[key]
end

-- startify_header() puts the blank lines, then an empty line, then the load-time line.
local function draw(win)
  local buf = vim.api.nvim_win_get_buf(win)
  -- The 0-based index of the load-time line is also the 1-based number of the line above it.
  local stats = vim.fn.match(vim.api.nvim_buf_get_lines(buf, 0, -1, false), "loaded .* plugins in")
  local cw, ch = (tmux("#{client_cell_width} #{client_cell_height}") or ""):match("^(%d+) (%d+)$")
  if stats <= M.rows or not cw then
    return
  end
  local pos = vim.fn.screenpos(win, stats - M.rows, 1)
  if pos.row == 0 then
    return
  end
  local h = M.rows * tonumber(ch)
  local data = sixel(3 * h, h)
  local info = vim.fn.getwininfo(win)[1]
  local text_width = info.width - info.textoff
  local col = info.wincol + info.textoff + math.max(0, math.floor((text_width - math.ceil(3 * h / cw)) / 2))
  if data ~= "" then
    vim.api.nvim_ui_send(string.format("\0277\027[%d;%dH%s\0278", pos.row, col, data))
  end
end

-- :mode clears the screen, and tmux drops the old image with it.
-- The redraw must finish before the new image is sent, or it paints over the image.
function M.refresh()
  vim.cmd.mode()
  vim.cmd.redraw()
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.bo[vim.api.nvim_win_get_buf(win)].filetype == "startify" then
      draw(win)
    end
  end
end

return M

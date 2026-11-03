-- Shows the banner on the start screen as a sixel image. sixels/ keeps one file for each colorscheme and cell size.
-- A missing file is rendered with ImageMagick, and later starts use it again. git ignores sixels/.
-- The layout needs the cell size in pixels. Only tmux reports it, so the image needs tmux and a terminal with sixel.
local M = {}

-- The image size in pixels. Each file is padded around it to fill whole cells.
local width, height = 930, 310

local config = vim.fn.stdpath("config")
local cache = {}
local cell_width, cell_height
local enabled

local function read(path)
  local file = io.open(path, "rb")
  if not file then
    return nil
  end
  local data = file:read("*a")
  file:close()
  return data
end

-- tmux clears the image's cells to the terminal's default background, which is black.
-- The theme background fills the cells around the image, or a black band shows.
local function render(path, w, h)
  -- With a float focused, such as the ,fs picker, nvim_get_hl gives Normal as mapped by the float's winhighlight.
  -- synIDattr reads the global group.
  local bg = vim.fn.synIDattr(vim.fn.hlID("Normal"), "bg#")
  if bg == "" or vim.fn.executable("magick") == 0 then
    return nil
  end
  vim.fn.mkdir(vim.fs.dirname(path), "p")
  local res = vim
    .system({
      "magick",
      config .. "/neovimium.png",
      "-background",
      bg,
      "-flatten",
      "-resize",
      width .. "x" .. height,
      "-gravity",
      "center",
      "-extent",
      w .. "x" .. h,
      "sixel:" .. path,
    })
    :wait()
  return res.code == 0 and read(path) or nil
end

-- The file name carries the padded size, so a font change gets its own file and old files stay as they are.
-- A file whose header shows another size, such as an empty one left by a failed render, is rendered again.
local function sixel()
  local name = vim.g.colors_name
  if not name or not cell_width then
    return ""
  end
  local w = math.ceil(width / cell_width) * cell_width
  local h = M.rows * cell_height
  local path = string.format("%s/sixels/%s-%dx%d.sixel", config, name, w, h)
  if not cache[path] then
    local data = read(path)
    local file_w, file_h = (data or ""):match('^\027P[^q]*q"1;1;(%d+);(%d+)')
    if tonumber(file_w) ~= w or tonumber(file_h) ~= h then
      data = render(path, w, h)
    end
    cache[path] = data or ""
  end
  return cache[path]
end

-- sixel_support is true when tmux is built with sixel. client_termfeatures lists sixel only if the terminal has it.
function M.enabled()
  if enabled == nil then
    enabled = false
    local ui = vim.api.nvim_list_uis()[1]
    local env = vim.g.tmux_env or {}
    if ui and ui.stdout_tty and vim.env.TERM_PROGRAM == "tmux" and env.TMUX then
      local res = vim
        .system({
          "tmux",
          "display",
          "-p",
          "#{sixel_support} #{client_termfeatures} #{client_cell_width} #{client_cell_height}",
        }, { env = env, text = true })
        :wait()
      local support, features, cw, ch = (res.stdout or ""):match("^(%d) (%S*) (%d+) (%d+)")
      if support == "1" and vim.tbl_contains(vim.split(features, ","), "sixel") then
        cell_width, cell_height = tonumber(cw), tonumber(ch)
        M.rows = math.ceil(height / cell_height)
        enabled = sixel() ~= ""
      end
    end
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

-- startify_header() puts the blank lines, then an empty line, then the load-time line.
local function draw(win)
  local buf = vim.api.nvim_win_get_buf(win)
  -- The 0-based index of the load-time line is also the 1-based number of the line above it.
  local stats = vim.fn.match(vim.api.nvim_buf_get_lines(buf, 0, -1, false), "loaded .* plugins in")
  if stats <= M.rows then
    return
  end
  local pos = vim.fn.screenpos(win, stats - M.rows, 1)
  local data = sixel()
  if pos.row == 0 or data == "" then
    return
  end
  local info = vim.fn.getwininfo(win)[1]
  local text_width = info.width - info.textoff
  local col = info.wincol + info.textoff + math.max(0, math.floor((text_width - math.ceil(width / cell_width)) / 2))
  vim.api.nvim_ui_send(string.format("\0277\027[%d;%dH%s\0278", pos.row, col, data))
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

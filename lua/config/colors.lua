local M = {}

local styles = { "night", "storm", "moon", "day" }
-- Shared with Emacs, tmux (~/.byobu/tokyonight.tmux) and WezTerm, which all follow it.
local state_dir = vim.fn.expand("~/.local/state/tokyonight")
local state_file = state_dir .. "/style"

local function read()
  local ok, lines = pcall(vim.fn.readfile, state_file)
  local style = ok and lines[1]
  return vim.tbl_contains(styles, style) and style or nil
end

local function load()
  return read() or "night"
end

local function save(style)
  vim.fn.mkdir(state_dir, "p")
  vim.fn.writefile({ style }, state_file)
  pcall(vim.system, { "tmux", "source-file", "-q", vim.fn.expand("~/.byobu/tokyonight.tmux") })
end

-- Each tokyonight-<style> colorscheme also sets 'background', so "day" switches to light.
local function apply(style)
  vim.cmd.colorscheme("tokyonight-" .. style)
end

function M.pick_style()
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")

  local before = vim.g.colors_name
  local chosen = false
  local current = (before or ""):gsub("^tokyonight%-", "")

  local picker = pickers.new(require("telescope.themes").get_dropdown({ previewer = false }), {
    prompt_title = "tokyonight style",
    finder = finders.new_table({ results = styles }),
    sorter = conf.generic_sorter({}),
    default_selection_index = math.max(vim.fn.index(styles, current) + 1, 1),
    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(function()
        local style = action_state.get_selected_entry()[1]
        chosen = true
        actions.close(prompt_bufnr)
        apply(style)
        save(style)
      end)
      return true
    end,
  })

  -- Same hooks Telescope's own colorscheme picker wraps for its live preview.
  local set_selection = picker.set_selection
  picker.set_selection = function(self, row)
    set_selection(self, row)
    local entry = action_state.get_selected_entry()
    if entry then
      apply(entry[1])
    end
  end
  local close_windows = picker.close_windows
  picker.close_windows = function(status)
    close_windows(status)
    if not chosen and before then
      vim.cmd.colorscheme(before)
    end
  end

  picker:find()
end

local function follow()
  vim.fn.mkdir(state_dir, "p")
  local watcher = vim.uv.new_fs_event()
  if not watcher then
    return
  end
  watcher:start(state_dir, {}, function(err, filename)
    if err or filename ~= "style" then
      return
    end
    -- A writer truncates before writing, so an event can see an empty file; skip those.
    vim.schedule(function()
      local style = read()
      if style and vim.g.colors_name ~= "tokyonight-" .. style then
        apply(style)
      end
    end)
  end)
end

vim.opt.termguicolors = true
apply(load())
follow()
vim.opt.guifont = "Monaco:h14"

return M

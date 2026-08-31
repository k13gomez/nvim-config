local M = {}

local function project_root()
  local found = vim.fs.find({ "mix.exs" }, { upward = true, path = vim.api.nvim_buf_get_name(0) })
  return found[1] and vim.fs.dirname(found[1]) or vim.fn.getcwd()
end

local function relpath()
  local file = vim.api.nvim_buf_get_name(0)
  if file == "" then
    return nil
  end
  return vim.fs.relpath(project_root(), file) or file
end

local function mix(...)
  local root = project_root()
  local cmd = { "mix", ... }
  vim.cmd("botright 15split")
  vim.api.nvim_win_set_buf(0, vim.api.nvim_create_buf(false, true))
  vim.fn.jobstart(cmd, { term = true, cwd = root })
end

function M.test_at_cursor()
  local file = relpath()
  if not file then
    return
  end
  mix("test", file .. ":" .. vim.fn.line("."))
end

function M.test_file()
  local file = relpath()
  if not file then
    return
  end
  mix("test", file)
end

function M.test_all()
  mix("test")
end

function M.test_failed()
  mix("test", "--failed")
end

function M.compile()
  mix("compile")
end

function M.deps_get()
  mix("deps.get")
end

return M

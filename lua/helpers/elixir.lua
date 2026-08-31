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

local function mix_in(root, ...)
  local cmd = { "mix", ... }
  vim.cmd("botright 15split")
  vim.api.nvim_win_set_buf(0, vim.api.nvim_create_buf(false, true))
  vim.fn.jobstart(cmd, { term = true, cwd = root })
end

local function mix(...)
  mix_in(project_root(), ...)
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

-- elixir-ls publishes its test code lenses as a *client-side* command: the
-- server emits `elixir.lens.test.run` and expects the editor to run the test
-- itself. Nothing registers that command by default, which is why the lenses
-- look inert without a plugin like elixir-tools.nvim. See plugins/lsp.lua for
-- the registration.
--
-- The lens arguments carry filePath/module/describe/testName but no line, and
-- `vim.lsp.codelens.run()` only dispatches a lens whose range starts on the
-- cursor row -- so the cursor row *is* the lens line. Use it for test and
-- describe lenses, the same `file:line` filter vscode-elixir-ls uses. Module
-- lenses sit on `defmodule`, which no test starts at, so filter by tag there
-- (module lenses send a raw atom, hence the `Elixir.`-prefixed value).
function M.run_test_lens(cmd)
  local args = cmd.arguments and cmd.arguments[1]
  if not (args and args.filePath) then
    return
  end
  local line = vim.fn.line(".")
  local root = args.projectDir or project_root()
  local file = vim.fs.relpath(root, args.filePath) or args.filePath

  if args.testName or args.describe then
    mix_in(root, "test", file .. ":" .. line)
  elseif args.module then
    mix_in(root, "test", file, "--only", "module:" .. args.module)
  else
    mix_in(root, "test", file)
  end
end

return M

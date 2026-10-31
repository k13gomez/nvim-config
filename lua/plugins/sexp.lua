-- `(` / `)` move to the enclosing open / close bracket, like Emacs
-- backward-up-list / up-list. Built-in `[(` / `])` know one bracket type and
-- do not skip strings, so this uses searchpair() over all three.

-- Skip brackets inside strings, regexes, comments and char literals such as `\(`.
-- This reads node types, not highlight captures, so it needs only the parser.
-- The names cover the Clojure (str_lit, char_lit), Fennel and Scheme grammars.
local function skip()
  local pos = vim.api.nvim_win_get_cursor(0)
  local ok, node = pcall(vim.treesitter.get_node, { pos = { pos[1] - 1, pos[2] }, ignore_injections = true })
  if not ok or not node then
    return false
  end
  local t = node:type()
  return t:find("str") or t:find("char") or t:find("regex") or t:find("comment") or false
end

local function up(flags)
  return function()
    pcall(function()
      vim.treesitter.get_parser():parse()
    end)
    for i = 1, vim.v.count1 do
      -- `s` sets the ' mark only on the first jump, so `''` returns to the start.
      local f = i == 1 and flags .. "s" or flags
      if vim.fn.searchpair("[([{]", "", "[)\\]}]", f, skip) <= 0 then
        return
      end
    end
  end
end

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("SexpNav", { clear = true }),
  pattern = { "clojure", "fennel", "scheme", "lisp" },
  callback = function(args)
    local opts = { buffer = args.buf }
    vim.keymap.set({ "n", "x", "o" }, "(", up("bW"), vim.tbl_extend("force", opts, { desc = "Backward up list" }))
    vim.keymap.set({ "n", "x", "o" }, ")", up("W"), vim.tbl_extend("force", opts, { desc = "Up list" }))
  end,
})

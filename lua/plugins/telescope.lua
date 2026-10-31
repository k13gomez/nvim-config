local ok_ts, telescope = pcall(require, "telescope")
local ok_ta, actions = pcall(require, "telescope.actions")
local ok_tas, action_state = pcall(require, "telescope.actions.state")
if not (ok_ts and ok_ta and ok_tas) then
  return
end

telescope.setup({
  defaults = {
    mappings = {
      i = {
        ["<CR>"] = function(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          local file = selection and (selection.path or selection.filename)
          if not file then
            return actions.select_default(prompt_bufnr)
          end
          actions.close(prompt_bufnr)
          vim.schedule(function()
            vim.cmd.edit(vim.fn.fnameescape(file))
            if selection.lnum then
              pcall(vim.api.nvim_win_set_cursor, 0, { selection.lnum, math.max((selection.col or 1) - 1, 0) })
            end
          end)
        end,
      },
    },
  },
  pickers = {
    -- Help entries carry a doc filename, so the custom <CR> would open it as a plain file.
    help_tags = { mappings = { i = { ["<CR>"] = actions.select_default } } },
  },
})

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
          actions.close(prompt_bufnr)
          vim.schedule(function()
            vim.cmd.edit(vim.fn.fnameescape(selection.path or selection.filename))
          end)
        end,
      },
    },
  },
})

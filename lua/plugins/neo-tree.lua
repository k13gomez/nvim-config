local ok, neo_tree = pcall(require, "neo-tree")
if not ok then
  return
end

-- Only settings that differ from neo-tree's defaults (see `:h neo-tree-configuration`).
neo_tree.setup({
  close_if_last_window = true,
  popup_border_style = "rounded",
  default_component_configs = {
    git_status = {
      symbols = {
        -- The git status colors on the name already show these.
        added = "",
        modified = "",
      },
    },
  },
  window = {
    position = "right",
    mappings = {
      ["<space>"] = { "toggle_node", nowait = false },
      ["<esc>"] = "revert_preview",
    },
  },
  filesystem = {
    follow_current_file = { enabled = true, leave_dirs_open = true },
    window = {
      mappings = {
        ["<c-x>"] = "clear_filter",
      },
    },
  },
  buffers = {
    follow_current_file = { leave_dirs_open = true },
    show_unloaded = true,
  },
  git_status = {
    window = { position = "float" },
  },
})

vim.keymap.set("n", "\\", "<cmd>Neotree reveal<cr>", { desc = "Reveal file in neo-tree" })

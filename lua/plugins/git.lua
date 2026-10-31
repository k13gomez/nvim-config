local ok, gitsigns = pcall(require, "gitsigns")
if not ok then
  return
end

gitsigns.setup({
  on_attach = function(bufnr)
    local function map(lhs, rhs, desc)
      vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc })
    end
    map("]c", function()
      gitsigns.nav_hunk("next")
    end, "Next hunk")
    map("[c", function()
      gitsigns.nav_hunk("prev")
    end, "Previous hunk")
    map("<leader>Gt", gitsigns.toggle_signs, "Toggle git signs")
    map("<leader>Gp", gitsigns.preview_hunk, "Preview hunk")
    map("<leader>Gs", gitsigns.stage_hunk, "Stage hunk")
    map("<leader>Gr", gitsigns.reset_hunk, "Reset hunk")
    map("<leader>Gb", gitsigns.blame_line, "Blame line")
  end,
})

local ok, wk = pcall(require, "which-key")
if not ok then
  return
end

wk.setup({
  preset = "modern",
  delay = 300,
  win = {
    border = "single",
  },
  spec = {
    { "<leader>f", group = "find" },
    { "<leader>l", group = "lsp" },
    { "<leader>>", group = "resize wider" },
    { "<leader><", group = "resize narrower" },
    { "<leader>,", group = "horiz resize / clojure tests" },
  },
})

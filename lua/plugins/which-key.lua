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
    { "<leader>d", group = "lsp / diagnostics" },
    { "<leader>c", group = "clojure / portal" },
    { "<leader>t", group = "tabs / toggles" },
    { "<leader>>", group = "resize wider" },
    { "<leader><", group = "resize narrower" },
    { "<leader>,", group = "horiz resize / clojure tests" },
  },
})

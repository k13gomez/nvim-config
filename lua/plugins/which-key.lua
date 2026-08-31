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
    { "<leader>b", group = "buffer" },
    { "<leader>f", group = "find" },
    { "<leader>d", group = "lsp / diagnostics" },
    { "<leader>c", group = "clojure / portal" },
    { "<leader>cr", group = "clojure: run / reload / reset" },
    { "<leader>m", group = "elixir / mix" },
    { "<leader>t", group = "tabs / toggles" },
    { "<leader>u", group = "insert / utilities" },
    { "<leader>uf", group = "pretty-print" },
    { "<leader>>", group = "resize wider" },
    { "<leader><", group = "resize narrower" },
    { "<leader>,", group = "horiz resize" },
    { "<leader>l", group = "conjure: log" },
    { "<leader>e", group = "conjure: eval" },
    { "<leader>g", group = "conjure: goto" },
    { "<leader>s", group = "conjure: session" },
    { "<leader>w", group = "conjure: wrap / s-exp" },
    { "<leader>wa", group = "s-exp: align comments" },
    { "<leader>we", group = "s-exp: wrap element" },
    { "<leader>wi", group = "s-exp: insert" },
    { "<leader>wp", group = "s-exp: put" },
    { "<leader>wc", group = "s-exp: clone" },
    { "<leader>wr", group = "s-exp: raise" },
    { "<leader>wx", group = "s-exp: replace" },
    { "<leader>x", group = "conjure: expand" },
  },
})

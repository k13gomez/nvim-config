vim.g["conjure#client#clojure#nrepl#connection#auto_repl#enabled"] = false
vim.g["conjure#client#clojure#nrepl#connection#auto_repl#hidden"] = true
vim.g["conjure#client#clojure#nrepl#connection#auto_repl#cmd"] = nil

-- Conjure's Elixir client starts `iex -S mix` as soon as the first .ex buffer
-- loads. Keep the client (eval mappings + log buffer) but start the REPL
-- explicitly with <localleader>cs, mirroring the Clojure auto_repl setting above.
local ok_elixir, elixir_stdio = pcall(require, "conjure.client.elixir.stdio")
if ok_elixir then
  elixir_stdio["on-load"] = function() end
end

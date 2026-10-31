local ok, conform = pcall(require, "conform")
if not ok then
  return
end

local elixir_fts = { elixir = true, eelixir = true, heex = true }
local terraform_fts = { terraform = true, ["terraform-vars"] = true }

conform.setup({
  formatters_by_ft = {
    lua = { "stylua" },
    terraform = { "terraform_fmt" },
    ["terraform-vars"] = { "terraform_fmt" },
  },
  format_on_save = function(bufnr)
    local ft = vim.bo[bufnr].filetype
    if terraform_fts[ft] then
      return { timeout_ms = 1000 }
    end
    -- elixir-ls is slow until the project has compiled, so give it a longer leash.
    if elixir_fts[ft] then
      return { timeout_ms = 3000, lsp_format = "fallback" }
    end
  end,
})

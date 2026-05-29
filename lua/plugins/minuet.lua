local ok_mn, minuet = pcall(require, "minuet")
local ok_vt, vt = pcall(require, "minuet.virtualtext")
if not ok_mn and ok_vt then
  return
end

-- ensure we don't have any conflicting keymaps
vim.g.parinfer_no_maps = true
vim.g.copilot_no_tab_map = true

local llm_model_name = os.getenv("NVIM_LLM_MODEL_NAME") or "granite-4.1-8b@q4_k_m"
local llm_secret_key = os.getenv("NVIM_LLM_SECRET_KEY") or "none"
local llm_endpoint_url = os.getenv("NVIM_LLM_ENDPOINT_URL") or "http://localhost:1234/v1/completions"
if not (llm_model_name and llm_secret_key and llm_endpoint_url) then
  return
end

minuet.setup({
  throttle = 0,
  debounce = 100,
  provider = "openai_fim_compatible",
  n_completions = 1,
  context_window = 4096,
  context_ratio = 0.75,
  provider_options = {
    openai_fim_compatible = {
      api_key = function()
        return llm_secret_key
      end,
      name = "local",
      end_point = llm_endpoint_url,
      model = llm_model_name,
      stream = true,
      template = {
        prompt = function(context_before_cursor, context_after_cursor)
          return "<|fim_prefix|>"
            .. context_before_cursor
            .. "<|fim_suffix|>"
            .. context_after_cursor
            .. "<|fim_middle|>"
        end,
        suffix = false,
      },
      optional = {
        stop = { "\n\n(", "```", "<|fim_prefix|>", "<|fim_suffix|>", "<|fim_middle|>" },
        stream = true,
        max_tokens = 1024,
        temperature = 0,
      },
    },
  },
  lsp = {
    enabled_ft = { "*" },
    completion = {
      enable = false,
      adjust_indentation = false,
    },
    inline_completion = {
      enable = true,
      enabled_auto_trigger_ft = { "*" },
    },
  },
  virtualtext = {
    auto_trigger_ft = {},
  },
})

vim.keymap.set("i", "<Tab>", function()
  if vim.lsp.inline_completion.get() then
    return ""
  end
  return "<Tab>"
end, {
  expr = true,
  replace_keycodes = true,
  desc = "Minuet: Accept suggestion or insert tab",
})

vim.keymap.set("i", "<Esc>", function()
  if vim.lsp.inline_completion.is_enabled() then
    -- Native inline completion does not currently expose the same clean
    -- "dismiss visible suggestion" action as minuet.virtualtext.
    -- Exiting insert mode dismisses the inline ghost text.
    return "<Esc>"
  end

  return "<Esc>"
end, {
  expr = true,
  replace_keycodes = true,
  desc = "Minuet: Dismiss suggestion or exit insert mode",
})

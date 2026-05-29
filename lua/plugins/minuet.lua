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
  n_completions = 3,
  context_window = 8192,
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
        stop = { "\n\n", "```", "<|fim_prefix|>", "<|fim_suffix|>", "<|fim_middle|>" },
        stream = true,
        max_tokens = 1024,
        temperature = 0.5,
        top_p = 0.90
      },
    },
  },
  lsp = {
    completion = {
      enable = false,
      adjust_indentation = false,
    },
    inline_completion = {
      enable = false,
    },
  },
  virtualtext = {
    auto_trigger_ft = { "*" },
  },
})

-- Accept suggestion or insert Tab
vim.keymap.set("i", "<Tab>", function()
  if vt.action.is_visible() then
    vt.action.accept()
    return ""
  end

  return "<Tab>"
end, {
  expr = true,
  replace_keycodes = true,
  desc = "Minuet: Accept suggestion or insert tab",
})

-- Dismiss suggestion or exit insert mode
vim.keymap.set("i", "<Esc>", function()
  if vt.action.is_visible() then
    vt.action.dismiss()
    return ""
  end

  return "<Esc>"
end, {
  expr = true,
  replace_keycodes = true,
  desc = "Minuet: Dismiss suggestion or exit insert mode",
})

-- Previous suggestion or move cursor left
vim.keymap.set("i", "<Left>", function()
  if vt.action.is_visible() then
    vt.action.prev()
    return ""
  end

  return "<Left>"
end, {
  expr = true,
  replace_keycodes = true,
  desc = "Minuet: Cycle to previous suggestion or move cursor left",
})

-- Next suggestion or move cursor right
vim.keymap.set("i", "<Right>", function()
  if vt.action.is_visible() then
    vt.action.next()
    return ""
  end

  return "<Right>"
end, {
  expr = true,
  replace_keycodes = true,
  desc = "Minuet: Cycle to next suggestion or move cursor right",
})

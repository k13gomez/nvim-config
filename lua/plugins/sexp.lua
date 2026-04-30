-- vim-sexp's <LocalLeader>-based ops are remapped under <Leader>w… so they
-- don't shadow conjure's prefixes (which-key shows them all under "conjure:
-- wrap / s-exp"). Bracket-shaped wraps use the bracket itself; everything
-- else is a 2- or 3-char mnemonic. Default sexp_replace/sexp_put_* values
-- shadow plain p / P / gp / gP — clearing them here also keeps regular paste.
vim.g.sexp_mappings = {
  -- Wrap list (`(` `)` for round, `[` `]` for square, `{` `}` for curly)
  sexp_round_head_wrap_list = "<Leader>w(",
  sexp_round_tail_wrap_list = "<Leader>w)",
  sexp_square_head_wrap_list = "<Leader>w[",
  sexp_square_tail_wrap_list = "<Leader>w]",
  sexp_curly_head_wrap_list = "<Leader>w{",
  sexp_curly_tail_wrap_list = "<Leader>w}",

  -- Wrap element (same brackets, prefixed with `e`)
  sexp_round_head_wrap_element = "<Leader>we(",
  sexp_round_tail_wrap_element = "<Leader>we)",
  sexp_square_head_wrap_element = "<Leader>we[",
  sexp_square_tail_wrap_element = "<Leader>we]",
  sexp_curly_head_wrap_element = "<Leader>we{",
  sexp_curly_tail_wrap_element = "<Leader>we}",

  -- Insert at list head / tail
  sexp_insert_at_list_head = "<Leader>wih",
  sexp_insert_at_list_tail = "<Leader>wit",

  -- Splice / convolute
  sexp_splice_list = "<Leader>ws",
  sexp_convolute = "<Leader>wv",

  -- Clone list / element
  sexp_clone_list = "<Leader>wcl",
  sexp_clone_element = "<Leader>wce",

  -- Raise list / element
  sexp_raise_list = "<Leader>wrl",
  sexp_raise_element = "<Leader>wre",

  -- Put at head / tail / before / after
  sexp_put_at_head = "<Leader>wph",
  sexp_put_at_tail = "<Leader>wpt",
  sexp_put_before = "<Leader>wpb",
  sexp_put_after = "<Leader>wpa",

  -- Replace (xp) / replace via black-hole register (xx)
  sexp_replace = "<Leader>wxp",
  sexp_replace_P = "<Leader>wxx",

  -- Align comments
  sexp_align_comments = "<Leader>wac",
  sexp_align_comments_top = "<Leader>wat",
}

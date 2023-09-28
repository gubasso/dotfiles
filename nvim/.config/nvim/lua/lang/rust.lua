local au = require('core.autocmds')

vim.api.nvim_create_autocmd("FileType", {
  group = au.augroup("rustlang"),
  pattern = { "rust" },
  callback = function()
    local buf = vim.api.nvim_get_current_buf()
    vim.keymap.set(
    'n',
    '<LocalLeader>t',
    '<cmd>wa<CR><cmd>call VimuxRunCommand("clrm; cargo test -p " . expand("%:.:h:h") . " -- --nocapture --test-threads 1")<cr>',
    {
      desc = '(vmux) Rust Run Test (file)',
      buffer = buf,
    })
    vim.keymap.set(
    'n',
    '<LocalLeader>c',
    '<cmd>wa<CR><cmd>call VimuxRunCommand("clrm; cargo clippy --package " . expand("%:.:h:h"))<cr>',
    {
      desc = '(vmux) Rust Cargo Clippy',
      buffer = buf,
    })
    vim.keymap.set(
    'n',
    '<LocalLeader>f',
    '<cmd>wa<CR><cmd>call VimuxRunCommand("clrm; cargo fmt --check")<cr>',
    {
      desc = '(vmux) Rustfm (check)',
      buffer = buf,
    })
    vim.keymap.set(
    'n',
    '<LocalLeader>F',
    '<cmd>wa<CR><cmd>call VimuxRunCommand("clrm; cargo fmt")<cr>',
    {
      desc = '(vmux) Rustfm (check)',
      buffer = buf,
    })
  end,
})

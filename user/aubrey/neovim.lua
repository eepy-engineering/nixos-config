vim.opt.runtimepath:prepend("/home/aubrey/.local/share/nvim/ts-parsers")

require('nvim-treesitter.configs').setup({
  parser_install_dir = "/home/aubrey/.local/share/nvim/ts-parsers",

  highlight = {
    enable = true,
  }
})

require("spade").setup({
  lsp_command = "spade-language-server",
})

vim.lsp.inlay_hint.enable(true)

local telescope = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', telescope.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', telescope.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', telescope.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', telescope.help_tags, { desc = 'Telescope help tags' })

vim.keymap.set('n', '<leader>s', ':write<CR>')
vim.keymap.set('n', '<leader>q', ':q<CR>')

-- run whatever build script is available
vim.keymap.set('n', '<leader>rr', ':write<CR>:!nu build.nu<CR>')
vim.keymap.set('n', '<leader>t', ':RustLsp codeAction<CR>')
vim.keymap.set('n', '<leader>f', ':write<CR>:!rustfmt --edition 2024 %:p<CR>')

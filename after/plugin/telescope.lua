local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.keymap.set('n', '<leader>b', builtin.buffers, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>ps', function()
    builtin.grep_string({ search = vim.fn.input('Grep > ') })
end)

local actions = require 'telescope.actions'
require('telescope').setup {
    pickers = {
        buffers = {
            mappings = {
                i = {
                    ['<C-d>'] = actions.delete_buffer,
                }
            }
        }
    }
}

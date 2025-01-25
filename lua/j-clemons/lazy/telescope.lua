return {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = {'nvim-lua/plenary.nvim'},

    config = function()
        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
        vim.keymap.set('n', '<leader>b', builtin.buffers, {})
        vim.keymap.set('n', '<C-p>', builtin.git_files, {})
        vim.keymap.set('n', '<leader>ps', function()
            builtin.grep_string({ search = vim.fn.input('Grep > ') })
        end)

        local actions = require 'telescope.actions'
        local layout = require 'telescope.actions.layout'
        require('telescope').setup {
            pickers = {
                buffers = {
                    mappings = {
                        i = {
                            ['<C-d>'] = actions.delete_buffer,
                        }
                    }
                }
            },
            defaults = {
                mappings = {
                    i = {
                        ['<C-h>'] = layout.toggle_preview,
                    }
                }
            }
        }

        local function file_name()
            local file_name = vim.fn.expand('%:t')
            return string.match(file_name, '(.*)%.')
        end

        vim.keymap.set('n', '<leader>fr', function()
            -- grep search for the current filename no extension
            builtin.grep_string({ search = file_name() })
        end)

    end

}

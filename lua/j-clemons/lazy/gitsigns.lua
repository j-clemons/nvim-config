return {
    'lewis6991/gitsigns.nvim',

    config = function()
        require('gitsigns').setup {
            on_attach = function(bufnr)
                local gitsigns = require('gitsigns')

                local function map(mode, l, r, opts)
                    opts = opts or {}
                    opts.buffer = bufnr
                    vim.keymap.set(mode, l, r, opts)
                end

                -- Navigation
                map('n', '<leader>n', function()
                    if vim.wo.diff then
                        vim.cmd.normal({'<leader>n', bang = true})
                    else
                        gitsigns.nav_hunk('next')
                    end
                end)

                -- map('n', '<leader>m', function()
                --     if vim.wo.diff then
                --         vim.cmd.normal({'<leader>m', bang = true})
                --     else
                --         gitsigns.nav_hunk('prev')
                --     end
                -- end)
            end
        }
    end
}

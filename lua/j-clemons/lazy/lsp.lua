return {
    'neovim/nvim-lspconfig',
    dependencies = {
        -- LSP Support
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',

        -- Autocompletion
        'hrsh7th/nvim-cmp',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        'saadparwaiz1/cmp_luasnip',
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-nvim-lua',

        -- Snippets
        'L3MON4D3/LuaSnip',
        'rafamadriz/friendly-snippets',
    },

    config = function()
        local cmp = require('cmp')
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = cmp_lsp.default_capabilities()

        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = {
                "gopls",
            },
            handlers = {
                function(server_name) -- default handler (optional)
                    require("lspconfig")[server_name].setup {
                        capabilities = capabilities
                    }
                end,
            }
        })

        local cmp_select = {behavior = cmp.SelectBehavior.Select}

        cmp.setup({
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
               end,
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                ["<C-Space>"] = cmp.mapping.complete(),
            }),
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'luasnip' }, -- For luasnip users.
            }, {
                { name = 'buffer' },
            })
        })

        vim.diagnostic.config({
            virtual_text = true,
        })

        -- Configure dbt-lsp using lspconfig
        local lspconfig = require('lspconfig')

        -- Add dbt-lsp configuration
        local configs = require('lspconfig.configs')
        if not configs.dbt_lsp then
            configs.dbt_lsp = {
                default_config = {
                    cmd = { '/home/jclemons/Projects/dbt-lsp/dbt-language-server' },
                    filetypes = { 'sql', 'yaml' },
                    root_dir = function(fname)
                        return lspconfig.util.find_git_ancestor(fname) or
                               lspconfig.util.find_node_modules_ancestor(fname) or
                               lspconfig.util.path.dirname(fname)
                    end,
                    settings = {},
                },
            }
        end

        -- Setup dbt-lsp with proper on_attach
        lspconfig.dbt_lsp.setup({
            capabilities = capabilities,
            on_attach = function(client, bufnr)
                -- dbt-specific keybinding for schema navigation
                vim.keymap.set('n', '<leader>ds', function()
                    local params = {
                        command = 'dbt.goToSchema',
                        arguments = {
                            {
                                uri = vim.uri_from_bufnr(bufnr),
                                position = {
                                    line = vim.fn.line('.') - 1,  -- LSP uses 0-based indexing
                                    character = vim.fn.col('.') - 1
                                }
                            }
                        }
                    }

                    -- Execute command and handle response
                    client.request('workspace/executeCommand', params, function(err, result)
                        if err then
                            vim.notify('Error executing dbt.goToSchema: ' .. tostring(err), vim.log.levels.ERROR)
                            return
                        end

                        if not result then
                            vim.notify('No schema definition found', vim.log.levels.WARN)
                            return
                        end

                        -- Navigate to the location
                        local location = result
                        if location.uri and location.range then
                            -- Convert file:// URI to local path
                            local file_path = vim.uri_to_fname(location.uri)

                            -- Open the file
                            vim.cmd('edit ' .. vim.fn.fnameescape(file_path))

                            -- Navigate to the specific line and column
                            local line = location.range.start.line + 1  -- Convert back to 1-based indexing
                            local col = location.range.start.character + 1
                            vim.fn.cursor(line, col)

                            vim.notify('Navigated to schema definition')
                        else
                            vim.notify('Invalid location response', vim.log.levels.WARN)
                        end
                    end, bufnr)
                end, { buffer = bufnr, desc = 'Go to dbt schema definition' })
            end,
        })
    end
}

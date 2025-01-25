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

        local opts = {buffer = bufnr, remap = false}
        local dbt_lsp = vim.lsp.start_client {
            name = "dbt-language-server",
            cmd = { "/home/jclemons/Projects/dbt-lsp/dbt-language-server" },
        }

        if not dbt_lsp then
            vim.notify "dbt-language-server not found"
            return
        end

        vim.api.nvim_create_autocmd("FileType", {
            pattern = "sql",
            callback = function()
                vim.lsp.buf_attach_client(0, dbt_lsp)
            end,
        })


        vim.api.nvim_create_autocmd("FileType", {
            pattern = "yaml",
            callback = function()
                vim.lsp.buf_attach_client(0, dbt_lsp)
            end,
        })
    end
}

return {
    'mfussenegger/nvim-dap',
    dependencies = {
        {
            "igorlfs/nvim-dap-view",
            ---@module 'dap-view'
            ---@type dapview.Config
            opts = {
                auto_toggle = true,
            },
        },

        "mason-org/mason.nvim"
    },
    config = function()
        -- MUST install via Mason: codelldb, cpptools

        local dap = require "dap"
        local ui = require "dap-view"
        --
        dap.adapters.codelldb = {
            id = "codelldb",
            type = "executable",
            -- command = vim.fn.exepath("codelldb"), -- Points to the DAP adapter
            command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
        }
        --
        -- dap.configurations.rust = {
        --     {
        --         name = "dbt-lsp",
        --         type = "codelldb",
        --         request = "launch",
        --         program = "/Users/j-clemons/projects/fs/target/debug/dbt-lsp",
        --         cwd = "${workspaceFolder}",
        --         stopOnEntry = false,
        --     },
        -- }

        -- dap.adapters.codelldb = {
        --     type = 'server',
        --     port = '${port}',
        --     executable = {
        --         command = '/path/to/codelldb/extension/adapter/codelldb',  -- UPDATE THIS PATH
        --         args = { '--port', '${port}' },
        --     },
        -- }

        -- dbt-lsp attach configuration
        dap.configurations.rust = {
            {
                name = 'Attach to dbt-lsp',
                type = 'codelldb',
                request = 'attach',
                program = '/Users/j-clemons/projects/fs.git/main/target/debug/dbt-lsp',
                -- program = function()
                --     return vim.fn.getcwd() .. "/target/debug/dbt-lsp"
                -- end,
                pid = function()
                    -- Option 1: Use the find-dbt-lsp-pid script (waits for process)
                    local handle = io.popen('$HOME/scripts/fs/find-dbt-lsp-pid.sh --wait 2>&1')
                    if handle then
                        local result = handle:read('*a'):gsub('%s+', '')
                        local success = handle:close()
                        if success and result:match('^%d+$') then
                            return tonumber(result)
                        end
                        -- Script failed, fall through to interactive picker
                        print('Script output: ' .. result)
                    end

                    -- Option 2: Interactive PID picker (fallback)
                    -- return require('dap.utils').pick_process({ filter = 'dbt-lsp' })
                end,
                cwd = '/Users/j-clemons/projects/fs.git/main',
                -- cwd = '${workspaceFolder}',
                stopOnEntry = false,
                -- Handle SIGURG signal (common in async Rust with tokio)
                initCommands = {
                    'process handle -p true -s false -n false SIGURG',
                },
            },
        }

        vim.keymap.set("n", "<leader>p", dap.toggle_breakpoint)

        vim.keymap.set("n", "<F2>", dap.continue)
        vim.keymap.set("n", "<F3>", dap.step_into)
        vim.keymap.set("n", "<F4>", dap.step_over)
        vim.keymap.set("n", "<F5>", dap.step_out)
        vim.keymap.set("n", "<F6>", dap.step_back)
        vim.keymap.set("n", "<F12>", dap.restart)
        vim.keymap.set("n", "<F1>", dap.terminate)
    end,
}

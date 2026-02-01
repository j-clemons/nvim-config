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

        dap.adapters.codelldb = {
            id = "codelldb",
            type = "executable",
            command = vim.fn.exepath("codelldb"), -- Points to the DAP adapter
        }

        dap.configurations.rust = {
            {
                name = "hello-world",
                type = "codelldb",
                request = "launch",
                program = function()
                    return vim.fn.getcwd() .. "/target/debug/hello-world"
                end,
                cwd = "${workspaceFolder}",
                stopOnEntry = false,
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

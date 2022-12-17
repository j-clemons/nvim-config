require 'nvim-treesitter.install'.compilers = { "clang" }
require 'nvim-treesitter.configs'.setup {
    ensure_installed = { 'help', 'python', 'c', 'lua', 'bash', 'yaml' },

    sync_install = false,

    auto_install = true,

    highlight = {
        enable = true,

        additional_vim_regex_highlighting = false,
    },
}

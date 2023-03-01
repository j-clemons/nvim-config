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

local parser_config = require 'nvim-treesitter.parsers'.get_parser_configs()
parser_config.sqll = {
    install_info = {
        url = '~/projects/tree-sitter-sql',
        files = {'src/parser.c'},
        branch = 'main',
    },
    filetype = 'sql',
}

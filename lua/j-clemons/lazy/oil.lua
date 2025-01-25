return {
  'stevearc/oil.nvim',
  opts = {},
  -- Optional dependencies
  dependencies = { { "echasnovski/mini.icons", opts = {} } },
  -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
  -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
  lazy = false,

  config = function()
      vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
      vim.keymap.set("n", "<leader>pv", "<CMD>Oil<CR>", { desc = "Open parent directory" })
      require("oil").setup({
          default_file_explorer = true,
          columns = {
              "icon",
              -- "permissions",
              -- "size",
              -- "mtime",
          },
          -- Buffer-local options to use for oil buffers
          buf_options = {
              buflisted = false,
              bufhidden = "hide",
          },
          use_default_keymaps = true,
          view_options = {
              -- Show files and directories that start with "."
              show_hidden = true,
              -- This function defines what is considered a "hidden" file
              is_hidden_file = function(name, bufnr)
                  local m = name:match("^%.")
                  return m ~= nil
              end,
              -- This function defines what will never be shown, even when `show_hidden` is set
              is_always_hidden = function(name, bufnr)
                  return false
              end,
              -- Sort file names with numbers in a more intuitive order for humans.
              -- Can be "fast", true, or false. "fast" will turn it off for large directories.
              natural_order = "fast",
              -- Sort file and directory names case insensitive
              case_insensitive = false,
              sort = {
                  -- sort order can be "asc" or "desc"
                  -- see :help oil-columns to see which columns are sortable
                  { "type", "asc" },
                  { "name", "asc" },
              },
          },
      })
  end
}

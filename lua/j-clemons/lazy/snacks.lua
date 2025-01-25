return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
      bigfile = { enabled = false },
      dashboard = { enabled = false },
      indent = { enabled = false },
      input = { enabled = false },
      picker = { enabled = false },
      notifier = { enabled = true },
      quickfile = { enabled = true },
      scroll = { enabled = false },
      statuscolumn = { enabled = false },
      words = { enabled = false },
  },
  keys = {
      { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
      { "<leader>h",  function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
  }
}

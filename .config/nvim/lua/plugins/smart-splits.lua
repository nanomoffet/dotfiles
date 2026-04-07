return {
  "mrjones2014/smart-splits.nvim",
  lazy = false,
  opts = {
    -- Use zellij as the multiplexer so Ctrl+h/j/k/l navigate to adjacent
    -- zellij panes when at the edge of nvim splits.
    multiplexer_backend = "zellij",
  },
  keys = {
    -- Resizing splits (these keymaps also accept a count, e.g. `10<A-h>`)
    { "<A-h>", function() require("smart-splits").resize_left() end, desc = "Resize Split Left" },
    { "<A-j>", function() require("smart-splits").resize_down() end, desc = "Resize Split Down" },
    { "<A-k>", function() require("smart-splits").resize_up() end, desc = "Resize Split Up" },
    { "<A-l>", function() require("smart-splits").resize_right() end, desc = "Resize Split Right" },
    -- Moving between nvim splits / zellij panes
    { "<C-h>", function() require("smart-splits").move_cursor_left() end, desc = "Move Cursor Left" },
    { "<C-j>", function() require("smart-splits").move_cursor_down() end, desc = "Move Cursor Down" },
    { "<C-k>", function() require("smart-splits").move_cursor_up() end, desc = "Move Cursor Up" },
    { "<C-l>", function() require("smart-splits").move_cursor_right() end, desc = "Move Cursor Right" },
    -- Swapping buffers between windows
    { "<leader><C-h>", function() require("smart-splits").swap_buf_left() end, desc = "Swap Buffer Left" },
    { "<leader><C-j>", function() require("smart-splits").swap_buf_down() end, desc = "Swap Buffer Down" },
    { "<leader><C-k>", function() require("smart-splits").swap_buf_up() end, desc = "Swap Buffer Up" },
    { "<leader><C-l>", function() require("smart-splits").swap_buf_right() end, desc = "Swap Buffer Right" },
  },
}

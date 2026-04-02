return {
  "mrjones2014/smart-splits.nvim",
  lazy = false,
  keys = {
    -- recommended mappings
    -- resizing splits
    -- these keymaps will also accept a range,
    -- for example `10<A-h>` will `resize_left` by `(10 * config.default_amount)`
    { "<A-h>", "<cmd>SmartResizeLeft", desc = "Resize Split Left" },
    { "<A-j>", "<cmd>SmartResizeDown", desc = "Resize Split Down" },
    { "<A-k>", "<cmd>SmartResizeUp", desc = "Resize Split Up" },
    { "<A-l>", "<cmd>SmartResizeRight", desc = "Resize Split Right" },
    -- moving between splits
    { "<leader><C-h>", "<cmd>SmartCursorMoveLeft", desc = "Move Cursor Left" },
    { "<leader><C-j>", "<cmd>SmartCursorMoveDown", desc = "Move Cursor Down" },
    { "<leader><C-k>", "<cmd>SmartCursorMoveUp", desc = "Move Cursor Up" },
    { "<leader><C-l>", "<cmd>SmartCursorMoveRight", desc = "Move Cursor Right" },
    { "<leader><C-\\>", "<cmd>SmartCursorMovePrevious", desc = "Move Cursor Previous" },
    -- swapping buffers between windows,
    { "<leader><C-h>", "<cmd>SmartSwapLeft", desc = "Swap Buffer Left" },
    { "<leader><C-j>", "<cmd>SmartSwapDown", desc = "Swap Buffer Down" },
    { "<leader><C-k>", "<cmd>SmartSwapUp", desc = "Swap Buffer Up" },
    { "<leader><C-l>", "<cmd>SmartSwapRight", desc = "Swap Buffer Right" },
  },
}

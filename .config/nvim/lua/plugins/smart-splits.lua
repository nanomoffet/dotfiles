return {
  "mrjones2014/smart-splits.nvim",
  lazy = false,
  keys = {
    -- recommended mappings
    -- resizing splits
    -- these keymaps will also accept a range,
    -- for example `10<A-h>` will `resize_left` by `(10 * config.default_amount)`
    { "n", "<A-h>", "<cmd>SmartResizeLeft", desc = "Resize Split Left" },
    { "n", "<A-j>", "<cmd>SmartResizeDown", desc = "Resize Split Down" },
    { "n", "<A-k>", "<cmd>SmartResizeUp", desc = "Resize Split Up" },
    { "n", "<A-l>", "<cmd>SmartResizeRight", desc = "Resize Split Right" },
    -- moving between splits
    { "n", "<leader><C-h>", "<cmd>SmartCursorMoveLeft", desc = "Move Cursor Left" },
    { "n", "<leader><C-j>", "<cmd>SmartCursorMoveDown", desc = "Move Cursor Down" },
    { "n", "<leader><C-k>", "<cmd>SmartCursorMoveUp", desc = "Move Cursor Up" },
    { "n", "<leader><C-l>", "<cmd>SmartCursorMoveRight", desc = "Move Cursor Right" },
    { "n", "<leader><C-\\>", "<cmd>SmartCursorMovePrevious", desc = "Move Cursor Previous" },
    -- swapping buffers between windows,
    { "n", "<leader><C-h>", "<cmd>SmartSwapLeft", desc = "Swap Buffer Left" },
    { "n", "<leader><C-j>", "<cmd>SmartSwapDown", desc = "Swap Buffer Down" },
    { "n", "<leader><C-k>", "<cmd>SmartSwapUp", desc = "Swap Buffer Up" },
    { "n", "<leader><C-l>", "<cmd>SmartSwapRight", desc = "Swap Buffer Right" },
  },
}

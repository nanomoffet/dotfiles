return {
  "norcalli/nvim-colorizer.lua",
  config = true,
  lazy = true,
  cmd = {
    "ColorizerToggle",
    "ColorizerAttachToBuffer",
    "ColorizerReloadAllBuffers",
    "ColorizerDetachFromBuffer",
  },
  opts = {
    "css",
    "javascriptreact",
    "html",
  },
  keys = {
    {
      "<leader>ct",
      "<cmd>ColorizerToggle<CR>",
      desc = "Toggle color highlighting",
    },
  },
  event = "BufReadPost",
}

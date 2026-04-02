return {
  "VPavliashvili/json-nvim",
  ft = "json", -- only load for json filetype
  keys = {
    { "<leader>jff", "<cmd>JsonFormatFile<cr>", desc = "Format JSON" },
    { "<leader>jmf", "<cmd>JsonMinifyFile<cr>", desc = "Minify JSON" },
    { "<leader>jef", "<cmd>JsonEscapeFile<cr>", desc = "Escape JSON" },
    { "<leader>juf", "<cmd>JsonUnescapeFile<cr>", desc = "Unescape JSON" },
    { "<leader>jcc", "<cmd>JsonKeysToCamelCase<cr>", desc = "Camel Case JSON Keys" },
  },
}

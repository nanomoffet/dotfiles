return {
  "VPavliashvili/json-nvim",
  ft = "json", -- only load for json filetype
  keys = {
    { "n", "<leader>jff", "<cmd>JsonFormatFile<cr>", desc = "Format JSON" },
    { "n", "<leader>jmf", "<cmd>JsonMinifyFile<cr>", desc = "Minify JSON" },
    { "n", "<leader>jef", "<cmd>JsonEscapeFile<cr>", desc = "Escape JSON" },
    { "n", "<leader>juf", "<cmd>JsonUnescapeFile<cr>", desc = "Unescape JSON" },
    { "n", "<leader>jcc", "<cmd>JsonKeysToCamelCase<cr>", desc = "Camel Case JSON Keys" },
  },
}

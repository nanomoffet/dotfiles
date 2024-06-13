return {
  "nvim-pack/nvim-spectre",
  build = false,
  cmd = "Spectre",
  opts = { open_cmd = "noswapfile vnew" },
  -- stylua: ignore
  keys = {
    { "<leader>sw", function() require("spectre").open_visual({select_word = true}) end, desc = "Search curent word (Spectre)" },
    { "<leader>sp", function() require("spectre").open_file_search({select_word=true}) end, desc = "Search on current file (Spectre)" },
  },
}

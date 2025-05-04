return {
  {
    "nvim-lualine/lualine.nvim",
    -- https://www.lazyvim.org/plugins/ui#lualinenvim
    opts = {
      sections = {
        lualine_c = {
          { LazyVim.lualine.pretty_path({ length = 8 }) },
        },
      },
    },
  },
}

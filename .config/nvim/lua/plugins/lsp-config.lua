return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      gopls = {
        settings = {
          gopls = {
            buildFlags = { "-tags=build integration" },
          },
        },
      },
      lua_ls = {
        settings = {
          lua = {
            runtime = {
              version = "5.4",
            },
          },
        },
      },
    },
  },
}

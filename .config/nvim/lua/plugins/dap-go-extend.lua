return {
  "leoluz/nvim-dap-go",

  opts = {
    dap_configurations = {
      {
        type = "go",
        name = "DB Service",
        mode = "remote",
        request = "attach",
        port = 40000,
        substitutePath = {
          {
            from = "${workspaceFolder}",
            to = "/app/${workspaceFolder}",
          },
        },
      },
    },
  },
}

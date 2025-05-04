return {
  "leoluz/nvim-dap-go",

  opts = {
    dap_configurations = {
      {
        type = "go",
        name = "DB Service",
        mode = "remote",
        request = "attach",
        substitutePath = {
          {
            from = "${workspaceFolder}",
            to = "/app/${workspaceFolder}",
          },
        },
      },
    },
    delve = {
      port = 2345,
    },
  },
}

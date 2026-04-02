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
            to = "/app",
          },
        },
      },
      {
        type = "go",
        name = "Ingestor",
        mode = "remote",
        request = "attach",
        port = 40001,
        substitutePath = {
          {
            from = "${workspaceFolder}",
            to = "/app",
          },
        },
      },
      {
        type = "go",
        name = "Canonical Processor",
        mode = "remote",
        request = "attach",
        port = 40002,
        substitutePath = {
          {
            from = "${workspaceFolder}",
            to = "/app",
          },
        },
      },
      {
        type = "go",
        name = "Canonical Publisher",
        mode = "remote",
        request = "attach",
        port = 40003,
        substitutePath = {
          {
            from = "${workspaceFolder}",
            to = "/app",
          },
        },
      },
      {
        type = "go",
        name = "Encoder Planner",
        mode = "remote",
        request = "attach",
        port = 40004,
        substitutePath = {
          {
            from = "${workspaceFolder}",
            to = "/app",
          },
        },
      },
      {
        type = "go",
        name = "Encoder Worker",
        mode = "remote",
        request = "attach",
        port = 40005,
        substitutePath = {
          {
            from = "${workspaceFolder}",
            to = "/app",
          },
        },
      },
      {
        type = "go",
        name = "Job Coordinator",
        mode = "remote",
        request = "attach",
        port = 40006,
        substitutePath = {
          {
            from = "${workspaceFolder}",
            to = "/app",
          },
        },
      },
      {
        type = "go",
        name = "Job Watcher",
        mode = "remote",
        request = "attach",
        port = 40007,
        substitutePath = {
          {
            from = "${workspaceFolder}",
            to = "/app",
          },
        },
      },
      {
        type = "go",
        name = "Technical Processor",
        mode = "remote",
        request = "attach",
        port = 40008,
        substitutePath = {
          {
            from = "${workspaceFolder}",
            to = "/app",
          },
        },
      },
      {
        type = "go",
        name = "Technical Publisher",
        mode = "remote",
        request = "attach",
        port = 40009,
        substitutePath = {
          {
            from = "${workspaceFolder}",
            to = "/app",
          },
        },
      },
    },
  },
}

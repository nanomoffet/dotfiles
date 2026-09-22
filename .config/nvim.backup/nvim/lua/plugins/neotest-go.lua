return {
  "nvim-neotest/neotest",
  optional = true,
  dependencies = {
    "fredrikaverpil/neotest-golang",
  },
  opts = {
    adapters = {
      ["neotest-golang"] = {
        -- Here we can set options for neotest-golang, e.g.
        -- go_test_args = { "-v", "-race", "-count=1", "-timeout=60s" },
        go_test_args = { "-count=1", "-tags=build integration" },
        go_list_args = { "-tags=integration" },
        dap_go_opts = {
          delve = {
            build_flags = { "-tags=build integration" },
          },
        },
        experimental = {
          test_table = true,
        },
        dap_go_enabled = true, -- requires leoluz/nvim-dap-go
      },
    },
  },
}

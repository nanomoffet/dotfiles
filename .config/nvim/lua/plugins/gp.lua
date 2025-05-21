return {
  "robitx/gp.nvim",
  config = function()
    local conf = {
      -- For customization, refer to Install > Configuration in the Documentation/Readme
      providers = {
        googleai = {
          endpoint = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-pro-preview-05-06:streamGenerateContent?key={{secret}}",
          model = "",
          secret = { "bws", "secret", "get", "BWS_SECRETS_KEY", "--access-token", "BWS_ACCESS_TOKEN" },
        },
      },
    }
    require("gp").setup(conf)

    -- Setup shortcuts here (see Usage > Shortcuts in the Documentation/Readme)
  end,
}

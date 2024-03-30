local colorscheme = require("lazyvim.plugins.colorscheme")
return {
  { "nyoom-engineering/oxocarbon.nvim" },

  -- config to load oxocarbon
  {
    "LazyVim/LazyVim",
    opts = {
      --colorscheme = "oxocarbon",
      colorscheme = "tokyonight",
    },
  },
}

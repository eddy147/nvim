return {
  { "nyoom-engineering/oxocarbon.nvim" },
  { "rebelot/kanagawa.nvim" },

  -- config to load oxocarbon
  {
    "LazyVim/LazyVim",
    opts = {
      --colorscheme = "oxocarbon",
      colorscheme = "kanagawa",
      lazy = true,
    },
  },
}

return {
  {
    -- Controls the bottom bar in Neovim.
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts.sections.lualine_c[4] = {
        -- Show more nested folders before collapsing it into '...'.
        LazyVim.lualine.pretty_path({ length = 8 }),
      }
    end,
  },
}

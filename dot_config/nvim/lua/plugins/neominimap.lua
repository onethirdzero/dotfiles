return {
  "Isrothy/neominimap.nvim",
  version = "v3.x.x",
  lazy = false,
  init = function()
    -- Use 'split' instead of 'float' so that the minimap
    -- doesn't hide content in the editing buffer.
    vim.g.neominimap = {
      auto_enable = true,
      layout = "split",
      split = {
        minimap_width = 20,
        fix_width = true,
        direction = "right",
      },
    }
  end,
}

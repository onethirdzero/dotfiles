return {
  "Isrothy/neominimap.nvim",
  version = "v3.x.x",
  lazy = false,
  init = function()
    vim.g.neominimap = {
      auto_enable = true,

      -- Use 'split' instead of 'float' so that the minimap
      -- doesn't hide content in the editing buffer.
      layout = "split",

      -- Scroll the minimap marker instead of scrolling
      -- the minimap around the marker.
      current_line_position = "percent",

      -- Compress the minimap vertically.
      y_multiplier = 2,

      -- Update the minimap less frequently (in ms).
      delay = 3000,

      split = {
        minimap_width = 20,
        fix_width = true,
        direction = "right",
      },

      diagnostic = {
        -- Make diagnostic issues less glaring.
        mode = "sign",
      },

      git = {
        -- Make Git changes more obvious.
        mode = "line",
        priority = 250,
      },
    }
  end,
}

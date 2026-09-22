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

        -- Avoid having to close a Vim window twice when editing a Git commit message.
        close_if_last_window = true,
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

  -- Make 'lines' mode less glaring.
  config = function()
    vim.api.nvim_set_hl(0, "NeominimapGitAddLine", { bg = "#47765e" })
    vim.api.nvim_set_hl(0, "NeominimapGitChangeLine", { bg = "#7f7150" })
    vim.api.nvim_set_hl(0, "NeominimapGitDeleteLine", { bg = "#7f545c" })
  end,
}

return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          explorer = {
            ignored = true,
            hidden = true,
          },
          files = {
            hidden = true,
          },
        },
      },
    },
    init = function()
      vim.api.nvim_create_autocmd("User", {
        -- Wait until all plugins have loaded, specifically the Snacks plugin.
        pattern = "VeryLazy",

        -- Make hidden and ignored files in the Snacks explorer more visible.
        callback = function()
          vim.api.nvim_set_hl(0, "SnacksPickerPathHidden", { link = "Comment" })
          vim.api.nvim_set_hl(0, "SnacksPickerPathIgnored", { link = "Comment" })
        end,
      })
    end,
  },
}

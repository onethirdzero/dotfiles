return {
  {
    "folke/snacks.nvim",
    opts = {
      image = { enabled = true },
      picker = {
        sources = {
          explorer = {
            ignored = true,
            hidden = true,
            layout = {
              layout = {
                width = 0.25,
                min_width = 20,
                max_width = 60,
              },
            },
          },
          files = {
            hidden = true,
            ignored = true,
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

          -- Snacks has no toggle for inline images. Make the finder report
          -- no images in buffers where they are turned off, so the existing
          -- images are closed on the next update.
          local doc = Snacks.image.doc
          local find_visible = doc.find_visible
          doc.find_visible = function(buf, cb)
            if vim.b[buf].snacks_image_off then
              return cb({})
            end
            return find_visible(buf, cb)
          end

          Snacks.toggle({
            name = "Inline Images",
            get = function()
              return not vim.b.snacks_image_off
            end,
            set = function(state)
              vim.b.snacks_image_off = not state
              -- Snacks re-runs its inline update on this event.
              vim.api.nvim_exec_autocmds("BufWinEnter", { buffer = 0 })
            end,
          }):map("<leader>uj")
        end,
      })
    end,
  },
}

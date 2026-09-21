return {
  {
    "saghen/blink.cmp",
    opts = {
      completion = {
        list = {
          max_items = 30,
        },
      },
      sources = {
        -- Avoid having Blink show up too often.
        min_keyword_length = 2,

        -- By Default, LazyVim pulls these sources into Blink for suggestions:
        -- - lsp
        -- - path -> file paths
        -- - snippets -> code templates
        -- - buffer -> words from all visible buffers
        -- We'll keep only the ones helpful to us.
        default = { "lsp" },
      },
    },
  },
}

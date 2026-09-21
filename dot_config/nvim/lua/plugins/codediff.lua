return {
  "esmuellert/codediff.nvim",
  cmd = "CodeDiff",
  opts = {
    diff = {
      layout = "inline",

      -- Make highlights more visible.
      highlights = {
        line_insert = "#294d3a",
        line_delete = "#57323a",
        char_insert = "#3b7654",
        char_delete = "#8a4652",
      },

      -- Add gutter signs in side-by-side view.
      gutter_signs = {
        insert_text = "＋",
        delete_text = "－",
        highlight_numbers = true,
        changed_priority = 100,
        unchanged_priority = nil,
      },
    },
  },
}

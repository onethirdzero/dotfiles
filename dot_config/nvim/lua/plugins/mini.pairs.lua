return {
  {
    "nvim-mini/mini.pairs",
    opts = {
      modes = {
        -- Disable auto parentheses matching in /, ?, or : prompts.
        -- Without this, typing "(" in those prompts causes Vim
        -- to add ")", which is often not needed.
        -- Matching will still happen in file editing.
        command = false,
      },
    },
  },
}

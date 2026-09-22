return {
  {
    "mfussenegger/nvim-lint",
    optional = true,

    -- nvim-lint starts golangci-lint from the repo root, where might not be a go.mod.
    -- This causes it to raise false positives - eg. failed imports, etc.
    -- This fix makes it look for the nearest go.mod for every buffer opened on a Go file.
    -- Relevant issues:
    -- https://github.com/mfussenegger/nvim-lint/issues/900
    -- https://github.com/mfussenegger/nvim-lint/issues/921
    opts = function(_, opts)
      opts.linters = opts.linters or {}

      opts.linters.golangcilint = function()
        local linter = vim.deepcopy(require("lint.linters.golangcilint"))
        local filename = vim.api.nvim_buf_get_name(0)
        local directory = vim.fs.dirname(filename)
        local go_mod = vim.fs.find("go.mod", {
          path = directory,
          upward = true,
        })[1]

        if go_mod then
          linter.cwd = vim.fs.dirname(go_mod)

          -- Lint the package, not the individual file.
          -- Note: This assumes we can pass 'directory' as the last arg to the linter,
          -- for it to become the lint target, but that could change in a later plugin version.
          linter.args[#linter.args] = directory
        end

        return linter
      end
    end,
  },
}

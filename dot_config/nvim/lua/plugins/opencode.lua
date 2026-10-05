return {
  "nickjvandyke/opencode.nvim",
  config = function()
    --- Find an existing tmux pane running opencode in the current working directory.
    --- Returns the tmux pane target (e.g. "0:1.2") if found, nil otherwise.
    ---@return string?
    local function find_opencode_pane()
      local cwd = vim.fn.getcwd()
      local panes = vim.fn.systemlist({
        "tmux",
        "list-panes",
        "-a",
        "-F",
        "#{pane_id}\t#{pane_current_command}\t#{pane_current_path}",
      })
      for _, pane in ipairs(panes) do
        local pane_id, command, pane_cwd = pane:match("^(%S+)\t(%S+)\t(.+)$")
        if pane_id and command and pane_cwd then
          -- Match opencode or opencode-nightly running in the same directory
          if command:match("^opencode") and pane_cwd == cwd then
            return pane_id
          end
        end
      end
      return nil
    end

    --- Get the most recent session ID for the current directory, if any.
    ---@return string?
    local function last_session_id()
      local out = vim.fn.systemlist({
        "opencode",
        "session",
        "list",
        "--format",
        "json",
        "-n",
        "1",
      })
      if vim.v.shell_error ~= 0 then
        return nil
      end
      local ok, sessions = pcall(vim.json.decode, table.concat(out, "\n"))
      if ok and sessions[1] and sessions[1].id then
        return sessions[1].id
      end
      return nil
    end

    --- Ensure an OpenCode pane exists in the current directory (start one if not).
    --- Opens the last session for this directory when resuming.
    local function ensure_pane()
      if not find_opencode_pane() then
        local args = { "tmux", "split-window", "-h", "-c", vim.fn.getcwd() }
        local sid = last_session_id()
        if sid then
          vim.list_extend(args, { "opencode", "--session", sid })
        else
          vim.list_extend(args, { "opencode" })
        end
        vim.fn.jobstart(args, { detach = true })
      end
    end

    ---@type opencode.Opts
    vim.g.opencode_opts = {
      server = {
        start = function()
          -- opencode.nvim connects to an existing OpenCode server if it's already running.
          -- Otherwise, start one in a separate pane.
          ensure_pane()
        end,
      },
    }

    -- Keybinds.

    -- Ensure an OpenCode pane exists, then interact via the API.
    vim.keymap.set({ "n", "x" }, "<C-a>", function()
      ensure_pane()
      require("opencode").ask("@this: ")
    end, { desc = "Ask OpenCode…" })
    vim.keymap.set({ "n", "x" }, "<C-x>", function()
      ensure_pane()
      require("opencode").select()
    end, { desc = "Select OpenCode…" })
  end,
}

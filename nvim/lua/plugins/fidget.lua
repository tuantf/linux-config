return {
  {
    "j-hui/fidget.nvim",
    config = function()
      require("fidget").setup({
        notification = {
          poll_rate = 10,                   -- How frequently to update and render notifications
          filter = vim.log.levels.INFO,     -- Minimum notifications level
          history_size = 128,               -- Number of removed messages to retain in history
          override_vim_notify = true,       -- Automatically override vim.notify() with Fidget
          window = {
            winblend = 100,                 -- Background color opacity in the notification window
            border = "none",                -- Border around the notification window
            max_width = 0,                  -- Maximum width of the notification window
            x_padding = 0,                  -- Padding from right edge of window boundary
            y_padding = 0,                  -- Padding from bottom edge of window boundary
            avoid = {}                      -- Filetypes the notification window should avoid, e.g., { "aerial", "NvimTree", "neotest-summary" }
          },
          view = {
            stack_upwards = true,           -- Display notification items from bottom to top
            align="annote",
            icon_separator = " ",           -- Separator between group name and icon
            group_separator = "──────────", -- Separator between notification groups
            group_separator_hl = "Comment", -- Highlight group used for group separator
            render_message = function(msg, cnt)
              return cnt == 1 and msg or string.format("(%dx) %s", cnt, msg)
            end,
          },
        },
      })
    end,
  },
}

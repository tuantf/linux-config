return {
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts = {
        options = {
          icons_enabled = false,
          section_separators = { left = "", right = "" },
          component_separators = { left = "\\", right = "" },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = {
            { "branch", icons_enabled = true, icon = "\u{e0a0}" },
          },
          lualine_c = {
            {
              'filename',
              file_status = true,
              newfile_status = false,
              path = 4,
              shorting_target = 40,
              symbols = {
                modified = '[M]',
                readonly = '[R]',
                unnamed = '[U]',
                newfile = '[N]',
              }
            },
          },
          lualine_x = {
            {
              'diagnostics',
              sources = { 'nvim_lsp', 'nvim_diagnostic', 'coc' },
              sections = { 'error', 'warn', 'info' },
              diagnostics_color = {
                error = 'DiagnosticError',
                warn  = 'DiagnosticWarn',
                info  = 'DiagnosticInfo',
              },
              symbols = {error = 'E', warn = 'W', info = 'I'},
              colored = true,
              update_in_insert = false,
              always_visible = true,
            },
          },
          lualine_y = {
            { "progress", padding = { left = 1, right = 0 } },
            { "location", padding = { left = 0, right = 1 } },
          },
          lualine_z = {
            function()
              return "" .. os.date("%R")
            end,
          },
        },
      }
      return opts
    end,
  },
}

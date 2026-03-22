return {
  {
    "nvim-mini/mini.starter",
    version = "*",
    config = function()
      local quotes = {
        "Small steps today beat perfect plans tomorrow...",
        "Start messy, clarity comes from motion...",
        "The next hour is yours, spend it on what matters...",
        "Done is a door, perfect is a wall...",
        "Show up. Narrow focus. Ship something...",
        "Energy follows the first keystroke...",
        "One clear task beats ten vague intentions...",
        "Progress is permission to continue...",
        "Boredom is a signal to begin, not to stop...",
        "What you avoid is usually smaller than you think...",
      }

      local function greeting()
        local hour = tonumber(os.date("%H")) or 12
        local part = hour < 12 and "morning" or hour < 17 and "afternoon" or "evening"
        return ("Good %s, tuantm!"):format(part)
      end

      require("mini.starter").setup({
        header = function()
          local quote = quotes[math.random(#quotes)]
          return quote .. "\n" .. greeting()
        end,
      })
    end,
  },
}

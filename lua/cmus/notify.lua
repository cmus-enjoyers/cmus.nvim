---@type table<string, string>
local defaultOptions = {
  title = "cmus.nvim",
}

---@param options table | nil options table to convert
---@return table<string, string>
local function convertOptionsToSafe(options)
  if options then
    options.title = options.title or defaultOptions.title
  end

  return options or defaultOptions
end

---@param text string Message text
---@param level string | nil Message log level
---@param options table | nil Custom notification options
return function(text, level, options)
  return vim.notify(
    text,
    level,
    convertOptionsToSafe(options)
  )
end

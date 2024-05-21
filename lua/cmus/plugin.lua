local scan = require "plenary.scandir"
local notify = require "cmus.notify"

M = {}

function M.scan(path)
  return scan.scan_dir(
    path,
    { depth = 1, hidden = true, add_dirs = true }
  )
end

local defaultOpts = {}

--- @param filePath string - path to file that will be played using cmus-remote
function M.play(filePath)
  local succes =
    os.execute("/usr/bin/cmus-remote -f " .. filePath)

  if not succes then
    notify("Cannot play " .. filePath, vim.log.levels.ERROR)
    return false
  end

  notify("Playing " .. filePath, vim.log.levels.INFO)

  return true
end

---@param str string
function M.escapeSpaces(str)
  return string.gsub(str, "% ", "\\ ")
end

function M.entry_maker(entry)
  return {
    value = M.escapeSpaces(entry),
    display = entry,
    ordinal = entry,
  }
end

--- @param opts table - cmus.nvim options
--- @return nil
function M.setup(opts)
  opts = opts or defaultOpts

  local pickers = require "telescope.pickers"
  local finders = require "telescope.finders"
  local conf = require("telescope.config").values
  local actions = require "telescope.actions"
  local action_state = require "telescope.actions.state"

  require "cmus.cmds"()

  local music =
    M.scan "/home/vktrenokh/music/vk_____________treenokh"

  if not music then
    notify("cannot open music folder", vim.log.levels.ERROR)
    return
  end

  pickers
    .new({}, {
      prompt_title = "Cmus song picker",
      finder = finders.new_table {
        results = music,
        entry_maker = M.entry_maker,
      },
      sorter = conf.generic_sorter {},
      attach_mappings = function(prompt_bufnr, map)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)

          local selection =
            action_state.get_selected_entry()

          M.play(selection.value)
        end)
        return true
      end,
    })
    :find()
end

return M

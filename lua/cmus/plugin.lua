local scan = require("plenary.scandir")

M = {}

function M.scan(path)
	return scan.scan_dir(path, { depth = 1, hidden = true, add_dirs = true })
end

local defaultOpts = {}

--- @param filePath string - path to file that will be played using cmus-remote
function M.play(filePath)
	local succes = os.execute("/usr/bin/cmus-remote -f ~/music/" .. filePath)

	if not succes then
		vim.notify("Cannot play " .. filePath, vim.log.levels.ERROR)
		return false
	end

	vim.notify("Playing " .. filePath, vim.log.levels.INFO)

	return true
end

function M.entry_maker(entry)
	return {
		value = entry:gsub("% ", "\\ "),
		display = entry,
		ordinal = entry,
	}
end

--- @param opts table - cmus.nvim options
--- @return nil
function M.setup(opts)
	opts = opts or defaultOpts

	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local conf = require("telescope.config").values
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")

	local music = M.scan("/home/vktrenokh/music/vk_____________treenokh")

	if not music then
		vim.notify("cannot open music folder", vim.log.levels.ERROR)
		return
	end

	pickers
		.new({}, {
			prompt_title = "Cmus song picker",
			finder = finders.new_table({
				results = music,
				entry_maker = M.entry_maker,
			}),
			sorter = conf.generic_sorter({}),
			attach_mappings = function(prompt_bufnr, map)
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)
					local selection = action_state.get_selected_entry()

					for k, v in pairs(selection) do
						vim.notify(v .. k, vim.log.levels.INFO)
					end

					M.play(selection[2])
				end)
				return true
			end,
		})
		:find()
end

M.setup({})
return M

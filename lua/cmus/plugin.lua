M = {}

local defaultOpts = {}

local a

--- @param input string - string to split
--- @param sep string - string separator
function M.split(input, sep)
	if sep == nil then
		sep = "%s"
	end

	local t = {}

	for str in string.gmatch(input, "([^" .. sep .. "]+)") do
		table.insert(t, str)
	end

	return t
end

--- @param opts table - cmus.nvim options
--- @return nil
function M.setup(opts)
	opts = opts or defaultOpts

	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local conf = require("telescope.config").values
	local actions = require("telescope.actions")
	local action_state = require("telescope.")

	local music = io.popen("dir ~/music/vk_____________treenokh/")

	if not music then
		vim.notify("cannot open music folder", vim.log.levels.ERROR)
		return
	end

	pickers
		.new({}, {
			prompt_title = "Cmus song picker",
			finder = finders.new_table({
				results = M.split(music:read("a"), "\n"),
			}),
			sorter = conf.generic_sorter({}),
			attach_mappings = function(prompt_bufnr, map)
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)
					local selection = action_state.get_selected_entry()
					vim.api.nvim_put({ selection[1] }, "", false, true)
				end)
				return true
			end,
		})
		:find()
end

M.setup({})
return M

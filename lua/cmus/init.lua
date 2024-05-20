local hasTelescope = pcall(require, "telescope")
local hasPlenary = pcall(require, "plenary")

if not hasTelescope then
	vim.notify("you should have telescope installed", vim.log.levels.ERROR)
	return
end

if not hasPlenary then
	vim.notify("You should have plenary installed", vim.log.levels.ERROR)
	return
end

return require("cmus.plugin")

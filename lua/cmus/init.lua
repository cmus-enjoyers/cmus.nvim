local hasTelescope, telescope = pcall(require, "telescope")

if not hasTelescope then
	vim.notify("you should have telescope installed", vim.log.levels.ERROR)
	return
end

return require("cmus.plugin")

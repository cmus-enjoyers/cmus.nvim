local hasTelescope, telescope = pcall(require, "telescope")

if not hasTelescope then
	vim.notify("you should have telescope installed", vim.log.levels.ERROR)
	return
end

vim.notify("bogdan suka", vim.log.levels.WARN)

return

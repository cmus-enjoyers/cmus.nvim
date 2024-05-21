local cmds = {
  ["CmusStop"] = function()
    os.execute "cmus-remote --pause"
  end,
}

return function()
  for commandName, commandAction in ipairs(cmds) do
    vim.api.nvim_create_user_command(
      commandName,
      commandAction
    )
  end
end

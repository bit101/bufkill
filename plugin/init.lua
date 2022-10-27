require("buffkill")
vim.api.nvim_create_user_command('KillBuffer', killBuffer, {nargs = 0})

require("buffkill")
vim.g.buf_kill_default_choice = "cancel"
vim.g.buf_kill_default_action = "prompt"
vim.api.nvim_create_user_command('KillBuffer', killBuffer, {nargs = 0})

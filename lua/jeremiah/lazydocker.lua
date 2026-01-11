-- Adding shortcut to save current file and open lazydocker
vim.api.nvim_set_keymap('n', '<leader>dd', ':lua ToggleLazyDockerTerminal()<CR>', { noremap = true, silent = true })

-- Function to open a new terminal buffer and run the server
function OpenLazydockerTerminal()
	jeremiah.utils.OpenTerminalTabKind('lazydocker', 'lazydocker')
end

function ToggleLazyDockerTerminal()
	jeremiah.utils.SaveAll()
	local buf = jeremiah.utils.FindTerminalBuffer('lazydocker')
	if buf then
		jeremiah.utils.FocusBufferInTab(buf)
	else
		OpenLazydockerTerminal()
	end
end

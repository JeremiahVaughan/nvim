-- Adding shortcut to save current file and open k9s
vim.api.nvim_set_keymap('n', '<leader>k', ':lua ToggleK9Terminal()<CR>', { noremap = true, silent = true })

-- Function to open a new terminal buffer and run the server
function OpenK9Terminal()
	jeremiah.utils.OpenTerminalTabKind('k9s', 'k9s')
end

function ToggleK9Terminal()
	local buf = jeremiah.utils.FindTerminalBuffer('k9s')
	if buf then
		jeremiah.utils.FocusBufferInTab(buf)
	else
		OpenK9Terminal()
	end
end

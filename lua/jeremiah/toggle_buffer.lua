local BUFF_PREFIX = 'buff_wuslx_'

function get_unique_label(label)
	local tab = vim.api.nvim_get_current_tabpage()
	local tab_id = vim.api.nvim_tabpage_get_number(tab)
	return BUFF_PREFIX .. tab_id .. '_' .. label
end

local function get_current_tab_id()
end

local function open_buf(cmd, label)
	local buf
	if cmd == "" then
		buf = vim.api.nvim_create_buf(false, true)
		vim.api.nvim_set_current_buf(buf)
	else
		vim.cmd(cmd)
		buf = vim.api.nvim_get_current_buf()
	end
	local buff_name = get_unique_label(label)
	vim.api.nvim_buf_set_name(buf, buff_name)
end

function toggle_buff(cmd, label)
	jeremiah.utils.save_all()
	local buf = vim.fn.bufnr(get_unique_label(label))
	if buf == -1 then
		open_buf(cmd, label)
	else
		vim.api.nvim_set_current_buf(buf)
	end
end

vim.api.nvim_set_keymap('n', '<leader>cc', ':lua toggle_buff("te codex", "codex")<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>CC', ':lua toggle_buff("te codex resume", "codex")<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>t', ':lua toggle_buff("te", "term")<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>j', ':lua toggle_buff("", "scratch")<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>k', ':lua toggle_buff("te k9s", "k9s")<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>gg', ':lua toggle_buff("te lazygit", "lazygit")<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>dd', ':lua toggle_buff("te lazydocker", "lazydocker")<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>m', ':lua toggle_buff("te htop", "htop")<CR>', { noremap = true, silent = true })

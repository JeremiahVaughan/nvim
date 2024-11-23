vim.api.nvim_set_keymap('n', '<leader>j', ':lua OpenQuickScratch("s")<CR>', { noremap = true, silent = true })

function OpenQuickScratch()
    vim.cmd('e /tmp/scratch')
end


-- In case grep is used in the command line, ensuring it is set to ripgrep
vim.opt.grepprg = 'rg --vimgrep --case-sensitive'
vim.api.nvim_create_user_command(
  "G",
  function()
    local pat = vim.fn.getreg("/")               -- current search pattern
    if pat == "" then
      vim.notify("Search register is empty", vim.log.levels.WARN)
      return
    end
    local rg_opts = {}   -- extra flags for rg

    -- ripgrep can't search in-memory buffers
	jeremiah.utils.SaveAll()

    -- translate leading Vim regex modifiers
    if pat:sub(1, 2) == "\\V" then         -- very nomagic → literal search
      pat = pat:sub(3)
      table.insert(rg_opts, "-F")
    end
    pat = pat:gsub("\\/", "/")
    local cmd = ("grep %s %s"):format(
      table.concat(rg_opts, " "),
      vim.fn.shellescape(pat)
    )
    -- Run :grep {pat} .   ( '.' = current dir; grepprg runs ripgrep )
    vim.cmd(cmd)
    vim.cmd.copen()
  end,
  { desc = "ripgrep for current search pattern" }
)

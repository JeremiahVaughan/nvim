
-- In case grep is used in the command line, ensuring it is set to ripgrep
local ignorePatterns = { "--glob", "!.git/*", "--glob", "!**/vendor/*", "!**/target/*"}
local ignoreStr = table.concat(ignorePatterns, " ")

vim.api.nvim_create_user_command(
  "G",
  function()
    local pat = vim.fn.getreg("/")               -- current search pattern
    if pat == "" then
      vim.notify("Search register is empty", vim.log.levels.WARN)
      return
    end
    local rg_opts = { "--vimgrep", "--case-sensitive" }
    -- ripgrep can't search in-memory buffers
	jeremiah.utils.SaveAll()

    -- translate leading Vim regex modifiers
    if pat:sub(1, 2) == "\\V" then         -- very nomagic → literal search
      pat = pat:sub(3)
      table.insert(rg_opts, "-F")
    end
    pat = pat:gsub("\\/", "/")
    local cmd = ("rg %s %s %s ."):format(
      table.concat(rg_opts, " "),
      ignoreStr,
      vim.fn.shellescape(pat)
    )
    -- Run :grep {pat} .   ( '.' = current dir; grepprg runs ripgrep )

    -- for debugging uncomment
    -- print("RG CMD:", cmd)

    local handle = io.popen(cmd)
    if not handle then
      vim.notify("Failed to run rg", vim.log.levels.ERROR)
      return
    end

    local output = handle:read("*a")
    handle:close()

    local qf = {}
    for line in output:gmatch("[^\r\n]+") do
      local filename, lnum, col, text = line:match("^(.-):(%d+):(%d+):(.*)$")
      if filename then
        table.insert(qf, {
          filename = filename,
          lnum = tonumber(lnum),
          col = tonumber(col),
          text = text,
        })
      end
    end

    if #qf == 0 then
      vim.notify("No matches found for pattern: " .. pat, vim.log.levels.INFO)
    else
      vim.fn.setqflist(qf, "r")
      vim.cmd.copen()
    end
  end,
  { desc = "ripgrep for current search pattern" }
)

vim.opt.grepprg = "rg --vimgrep --hidden " .. ignoreStr

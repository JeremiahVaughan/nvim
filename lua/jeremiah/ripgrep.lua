
-- In case grep is used in the command line, ensuring it is set to ripgrep
local ignorePatterns = {
  "--glob", "!.git/**",
  "--glob", "!**/vendor/**",
  "--glob", "!**/target/**",
}

local function build_rg_args(base_args)
  local args = vim.deepcopy(base_args)
  vim.list_extend(args, ignorePatterns)
  return args
end

local function shell_join(args)
  return table.concat(vim.tbl_map(vim.fn.shellescape, args), " ")
end

vim.api.nvim_create_user_command(
  "G",
  function()
    local pat = vim.fn.getreg("/")               -- current search pattern
    if pat == "" then
      vim.notify("Search register is empty", vim.log.levels.WARN)
      return
    end
    local rg_args = build_rg_args({ "rg", "--vimgrep", "--case-sensitive" })
    -- ripgrep can't search in-memory buffers
	jeremiah.utils.SaveAll()

    -- translate leading Vim regex modifiers
    if pat:sub(1, 2) == "\\V" then         -- very nomagic → literal search
      pat = pat:sub(3)
      table.insert(rg_args, "-F")
    end
    pat = pat:gsub("\\/", "/")
    table.insert(rg_args, pat)
    table.insert(rg_args, ".")
    -- Run :grep {pat} .   ( '.' = current dir; grepprg runs ripgrep )

    -- for debugging uncomment
    -- print("RG CMD:", shell_join(rg_args))

    local output = vim.fn.systemlist(rg_args)
    local exit_code = vim.v.shell_error
    if exit_code > 1 then
      vim.notify("Failed to run rg: " .. table.concat(output, "\n"), vim.log.levels.ERROR)
      return
    end

    local qf = {}
    for _, line in ipairs(output) do
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

vim.opt.grepprg = shell_join(build_rg_args({ "rg", "--vimgrep", "--hidden" }))

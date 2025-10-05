local M = {}

function M.setup()
  vim.api.nvim_create_user_command("CopyAbsolutePath", function()
    local absolute_path = vim.fn.expand("%:p")
    if absolute_path == "" then
      print("No file name")
      return
    end

    -- Copy to the system clipboard so other apps can use it
    vim.fn.setreg("+", absolute_path)
    vim.fn.setreg("*", absolute_path)

    print("Copied path: " .. absolute_path)
  end, {})
end

return M

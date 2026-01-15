local TERMS_TAB_VAR = "jeremiah_terms_tab"

local function set_win_guard(win, enabled)
    vim.api.nvim_win_set_option(win, "winfixbuf", enabled)
end

local function open_term_in_win(win)
    set_win_guard(win, false)
    vim.api.nvim_set_current_win(win)
    vim.cmd("term")
    set_win_guard(win, true)
end

local function ensure_four_way_layout()
    vim.cmd("only")
    vim.cmd("vsplit")
    vim.cmd("wincmd h")
    vim.cmd("split")
    vim.cmd("wincmd l")
    vim.cmd("split")
end

local function find_terms_tab()
    for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
        local ok, val = pcall(vim.api.nvim_tabpage_get_var, tab, TERMS_TAB_VAR)
        if ok and val == true then
            return tab
        end
    end

    return nil
end

local function open_terms_in_tab(tab)
    vim.api.nvim_set_current_tabpage(tab)
    local wins = vim.api.nvim_tabpage_list_wins(tab)
    if #wins ~= 4 then
        ensure_four_way_layout()
        wins = vim.api.nvim_tabpage_list_wins(tab)
    end

    for _, win in ipairs(wins) do
        open_term_in_win(win)
    end
end

vim.api.nvim_create_user_command("TERMS", function()
    local tab = find_terms_tab()
    if tab then
        open_terms_in_tab(tab)
        return
    end

    vim.cmd("tabnew")
    local new_tab = vim.api.nvim_get_current_tabpage()
    vim.api.nvim_tabpage_set_var(new_tab, TERMS_TAB_VAR, true)
    ensure_four_way_layout()
    open_terms_in_tab(new_tab)
end, {})

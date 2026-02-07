local M = {
    {
        "nvim-telescope/telescope.nvim",
        event = "VimEnter",
        dependencies = {
            "nvim-lua/plenary.nvim",
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
                cond = function()
                    return vim.fn.executable("make") == 1
                end,
            },
            "nvim-telescope/telescope-ui-select.nvim",
            {
                "nvim-tree/nvim-web-devicons",
                enabled = vim.g.have_nerd_font,
            },
        },
        config = function()
            local actions = require("telescope.actions")
            local tele_builtin = require("telescope.builtin")

            local function search_visual_selection()
                local previous_selection = vim.fn.getreg('"')
                vim.cmd('normal! "vy')
                local selected_text = vim.fn.getreg('"')
                vim.fn.setreg('"', previous_selection)

                if selected_text:find("\n") then
                    vim.notify("Telescope live_grep cannot search selections containing newlines.", vim.log.levels.ERROR)
                    return
                end

                tele_builtin.live_grep({ default_text = selected_text })
            end

            vim.api.nvim_set_keymap("n", "<leader>sf", ":Telescope find_files<CR>", { noremap = true, silent = true })
            vim.api.nvim_set_keymap("n", "<leader>sg", ":Telescope live_grep<CR>", { noremap = true, silent = true })
            vim.api.nvim_set_keymap("n", "<leader>ss", ":Telescope grep_string<CR>", { noremap = true, silent = true })
            vim.api.nvim_set_keymap("n", "<leader>sb", ":Telescope buffers<CR>", { noremap = true, silent = true })
            vim.api.nvim_set_keymap("n", "<leader>sr", ":Telescope registers<CR>", { noremap = true, silent = true })
            vim.api.nvim_set_keymap("n", "<leader>sc", ":Telescope command_history<CR>", { noremap = true, silent = true })
            vim.api.nvim_set_keymap("n", "<leader>sqf", ":Telescope quickfix<CR>", { noremap = true, silent = true })
            vim.api.nvim_set_keymap("n", "<leader>sqh", ":Telescope quickfixhistory<CR>", { noremap = true, silent = true })
            vim.api.nvim_set_keymap("n", "<leader>sp", ":Telescope search_history<CR>", { noremap = true, silent = true })
            vim.api.nvim_set_keymap("n", "<Leader>sk", ":Telescope keymaps<CR>", { noremap = true, silent = true })
            vim.api.nvim_set_keymap("n", "<Leader>sd", ":Telescope diagnostics<CR>", { noremap = true, silent = true })
            vim.keymap.set("v", "<leader>s", search_visual_selection)

            require("telescope").setup({
                defaults = {
                    mappings = {
                        i = {
                            ["<C-c>"] = actions.close,
                        },
                    },
                    find_command = { "rg", "--files", "--hidden", "--glob", "!.git/*" },
                    vimgrep_arguments = {
                        "rg",
                        "--color=never",
                        "--no-heading",
                        "--with-filename",
                        "--line-number",
                        "--column",
                        "--smart-case",
                        "--hidden",
                        "--glob",
                        "!.git/*",
                    },
                    file_ignore_patterns = {
                        "node_modules", -- heaviest object in the known universe
                        "%.jpg",
                        "%.png",
                        "%.git\\",
                        "%.git/",
                        "debug", -- rust dev artifacts
                        "target", -- rust artifacts
                        "vendor", -- golang keyword
                        "vendoring", -- custom keyword to not conflict with golang keyword but means same thing
                        ".gocache",
                    },
                    layout_strategy = "flex",
                    layout_config = {
                        flex = {
                            flip_columns = 120,
                        },
                        width = 0.95,
                        height = 0.95,
                        preview_cutoff = 120,
                    },
                },
                pickers = {
                    find_files = {
                        hidden = true,
                    },
                },
            })

            pcall(require("telescope").load_extension, "fzf")
            pcall(require("telescope").load_extension, "ui-select")

            vim.keymap.set("n", "<leader>sn", function()
                tele_builtin.find_files({ cwd = vim.fn.stdpath("config") })
            end, { desc = "[S]earch [N]eovim files" })

            vim.keymap.set("n", "<leader>st", function()
                tele_builtin.find_files({ cwd = vim.fn.stdpath("config") .. "/lua/jeremiah/templates" })
            end, { desc = "[S]earch [T]emplate files" })
        end,
    },
}

return M

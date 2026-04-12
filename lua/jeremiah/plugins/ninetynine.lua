local M = {
    {
        "ThePrimeagen/99",
        lazy = false,
        config = function()
            local ok, _99 = pcall(require, "99")
            if not ok then
                vim.notify("Failed to load ThePrimeagen/99", vim.log.levels.ERROR)
                return
            end

            local providers = require("99.providers")

            local CrushProvider = setmetatable({}, { __index = providers.BaseProvider })
            local LocalModelProvider = setmetatable({}, { __index = providers.BaseProvider })
            local helper_executable = vim.loop.os_homedir() .. "/go/bin/nvim-helper"
            local local_model_host = "http://192.168.1.173:11434"
            local local_model_names = {
                "gemma4:e2b",
                "gemma4:e4b",
                "gemma4:26b",
                "gemma4:31b",
            }
            local local_model_preprompt = table.concat({
                "Return only code that can be written directly to the target file.",
                "Do not include Markdown fences.",
                "Do not include explanations, commentary, or surrounding prose.",
                "Do not prefix the answer with a language name.",
            }, "\n")

            function CrushProvider._build_command(_, query, context)
                return {
                    "crush",
                    "run",
                    query,
                }
            end

            function CrushProvider._get_provider_name()
                return "CrushProvider"
            end

            function LocalModelProvider._build_command(_, query, context)
                return {
                    helper_executable,
                    "local-model",
                    "--host",
                    local_model_host,
                    "--model",
                    context.model,
                    "--prompt",
                    local_model_preprompt .. "\n\n" .. query,
                    "--output",
                    context.tmp_file,
                }
            end

            function LocalModelProvider._get_provider_name()
                return "LocalModel"
            end

            function LocalModelProvider._get_default_model()
                return local_model_names[1]
            end

            function LocalModelProvider.fetch_models(callback)
                callback(vim.deepcopy(local_model_names), nil)
            end

            local function with_telescope_extension(method)
                local has_extension, telescope_99 = pcall(require, "99.extensions.telescope")
                if not has_extension then
                    vim.notify("99 telescope extension is unavailable", vim.log.levels.WARN)
                    return
                end

                telescope_99[method]()
            end

            local cwd = vim.uv.cwd()
            local basename = vim.fs.basename(cwd)

            _99.Providers.CrushProvider = CrushProvider
            _99.Providers.LocalModel = LocalModelProvider

            _99.setup({
                provider = CrushProvider,
                logger = {
                    level = _99.DEBUG,
                    path = "/tmp/" .. basename .. ".99.debug",
                    print_on_error = true,
                },
                tmp_dir = "./tmp",
                md_files = {
                    "AGENT.md",
                },
                completion = {
                    custom_rules = {
                        vim.fn.stdpath("config") .. "/crush/skills",
                    },
                    source = "native",
                },
                auto_add_skills = true,
            })

            vim.keymap.set("n", "<leader>9s", function()
                _99.search()
            end, { desc = "99 search" })

            vim.keymap.set("v", "<leader>9v", function()
                _99.visual()
            end, { desc = "99 visual" })

            vim.keymap.set("n", "<leader>9x", function()
                _99.stop_all_requests()
            end, { desc = "99 stop requests" })

            vim.keymap.set("n", "<leader>9o", function()
                _99.open()
            end, { desc = "99 open last result" })

            vim.keymap.set("n", "<leader>9l", function()
                _99.view_logs()
            end, { desc = "99 view logs" })

            vim.keymap.set("n", "<leader>9m", function()
                with_telescope_extension("select_model")
            end, { desc = "99 select model" })

            vim.keymap.set("n", "<leader>9p", function()
                with_telescope_extension("select_provider")
            end, { desc = "99 select provider" })
        end,
    },
}

return M

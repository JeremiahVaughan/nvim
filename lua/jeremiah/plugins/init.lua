local plugin_modules = {
    "jeremiah.plugins.sops",
    "jeremiah.plugins.commentary",
    "jeremiah.plugins.flatten",
    "jeremiah.plugins.dadbod",
    "jeremiah.plugins.ninetynine",
    "jeremiah.plugins.ccc",
    "jeremiah.plugins.oil",
    "jeremiah.plugins.telescope",
    "jeremiah.plugins.treesitter",
    "jeremiah.plugins.harpoon",
    "jeremiah.plugins.gitsigns",
    "jeremiah.plugins.emoji",
    -- "jeremiah.plugins.himalaya",
	-- uncomment to enable leetcode
    "jeremiah.plugins.leetcode",
}

local plugins = {}

for _, module_name in ipairs(plugin_modules) do
    local ok, module_plugins = pcall(require, module_name)
    if ok then
        for _, spec in ipairs(module_plugins) do
            table.insert(plugins, spec)
        end
    else
        vim.notify(string.format("Failed to load plugin module '%s': %s", module_name, module_plugins), vim.log.levels.ERROR)
    end
end

return plugins

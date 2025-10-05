local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)
local plugins = require("jeremiah.plugins")

require("lazy").setup(plugins, {
    rocks = {
        -- Disable Lua dependency stuff since external dependencies are not needed right now and hopefully won't be
        -- Installing these was a HUGE pain in past experience and I'm not looking to become a Lua ecosystem expert
        enabled = false,
        hererocks = false,
    },
}
)

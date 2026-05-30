local M = {}

if vim.g.neovide then
  if (vim.uv or vim.loop).os_uname().sysname == "Linux" then
    vim.o.guifont = "JetBrainsMono Nerd Font Mono:h13"
  end
  vim.opt.linespace = 0
end

vim.opt.cursorline = true
vim.opt.termguicolors = true -- without this option set to true, alacritty does not show color when nvim is ran over ssh

-- Completion suggestions for directories so they don't turn up as very dark blue
vim.g.terminal_color_4 = "#7aa2f7"
vim.g.terminal_color_12 = "#7aa2f7"

-- Line number colors
vim.api.nvim_set_hl(0, 'LineNrAbove', { fg = '#75aaff' })
vim.api.nvim_set_hl(0, 'LineNrBelow', { fg = '#008518' })

-- Base background and UI accents
vim.api.nvim_set_hl(0, 'Normal', { bg = '#002b36', fg = '#839496' })
vim.api.nvim_set_hl(0, 'CursorLine', { bg = '#073642' })
vim.api.nvim_set_hl(0, 'Comment', { fg = '#586e75', italic = true })
vim.api.nvim_set_hl(0, 'StatusLine', { bg = '#073642', fg = '#93a1a1' })
vim.api.nvim_set_hl(0, 'Visual', { bg = '#586e75' })
vim.api.nvim_set_hl(0, 'TermCursor', { link = 'Cursor' })
vim.api.nvim_set_hl(0, 'TermCursorNC', { bg = '#d33682', fg = '#fdf6e3' })
vim.api.nvim_set_hl(0, 'Pmenu', { bg = '#073642', fg = '#93a1a1' })
vim.api.nvim_set_hl(0, 'PmenuSel', { bg = '#586e75', fg = '#fdf6e3' })
vim.api.nvim_set_hl(0, 'TelescopeSelection', { bg = '#073642', fg = '#93a1a1', bold = true })
vim.api.nvim_set_hl(0, 'TelescopeSelectionCaret', { fg = '#d33682' })

-- Treesitter core groups
vim.api.nvim_set_hl(0, '@type', { fg = '#2aa198' })
vim.api.nvim_set_hl(0, '@function', { fg = '#268bd2' })
vim.api.nvim_set_hl(0, '@variable', { fg = '#839496' })
vim.api.nvim_set_hl(0, '@string', { fg = '#859900' })
vim.api.nvim_set_hl(0, '@number', { fg = '#b58900' })
vim.api.nvim_set_hl(0, '@constant', { fg = '#cb4b16' })
vim.api.nvim_set_hl(0, '@boolean', { fg = '#b58900', bold = true })
vim.api.nvim_set_hl(0, '@constant.builtin', { fg = '#cb4b16', bold = true })
vim.api.nvim_set_hl(0, '@function.builtin', { fg = '#268bd2' })
vim.api.nvim_set_hl(0, '@function.call', { fg = '#268bd2' })
vim.api.nvim_set_hl(0, '@keyword', { fg = '#d33682', bold = true })
vim.api.nvim_set_hl(0, '@keyword.conditional.ternary', { fg = '#93a1a1' })
vim.api.nvim_set_hl(0, '@operator', { fg = '#93a1a1' })
vim.api.nvim_set_hl(0, '@property', { fg = '#cb4b16' })
vim.api.nvim_set_hl(0, '@punctuation.bracket', { fg = '#93a1a1' })
vim.api.nvim_set_hl(0, '@punctuation.delimiter', { fg = '#93a1a1' })
vim.api.nvim_set_hl(0, '@punctuation.special', { fg = '#93a1a1' })
vim.api.nvim_set_hl(0, '@tag', { fg = '#2aa198', bold = true })
vim.api.nvim_set_hl(0, '@tag.attribute', { fg = '#93a1a1' })
vim.api.nvim_set_hl(0, '@tag.builtin', { fg = '#b58900', bold = true })
vim.api.nvim_set_hl(0, '@tag.delimiter', { fg = '#93a1a1' })
vim.api.nvim_set_hl(0, '@type.builtin', { fg = '#2aa198' })
vim.api.nvim_set_hl(0, '@type.definition', { fg = '#2aa198' })
vim.api.nvim_set_hl(0, '@variable.member', { fg = '#cb4b16' })

-- CSS and Sass highlights
vim.api.nvim_set_hl(0, 'cssBackgroundProp', { fg = '#93a1a1' })
vim.api.nvim_set_hl(0, 'cssBorderProp', { fg = '#93a1a1' })
vim.api.nvim_set_hl(0, 'cssBoxProp', { fg = '#93a1a1' })
vim.api.nvim_set_hl(0, 'cssColor', { fg = '#cb4b16' })
vim.api.nvim_set_hl(0, 'cssColorProp', { fg = '#93a1a1' })
vim.api.nvim_set_hl(0, 'cssFlexibleBoxAttr', { fg = '#859900' })
vim.api.nvim_set_hl(0, 'cssFlexibleBoxProp', { fg = '#93a1a1' })
vim.api.nvim_set_hl(0, 'cssFontAttr', { fg = '#859900' })
vim.api.nvim_set_hl(0, 'cssFontProp', { fg = '#93a1a1' })
vim.api.nvim_set_hl(0, 'cssMediaProp', { fg = '#93a1a1' })
vim.api.nvim_set_hl(0, 'cssMultiColumnAttr', { fg = '#859900' })
vim.api.nvim_set_hl(0, 'cssPositioningAttr', { fg = '#859900' })
vim.api.nvim_set_hl(0, 'cssPositioningProp', { fg = '#93a1a1' })
vim.api.nvim_set_hl(0, 'cssPseudoClass', { fg = '#b58900', bold = true })
vim.api.nvim_set_hl(0, 'cssPseudoClassId', { fg = '#b58900', bold = true })
vim.api.nvim_set_hl(0, 'cssTextAttr', { fg = '#859900' })
vim.api.nvim_set_hl(0, 'cssTextProp', { fg = '#93a1a1' })
vim.api.nvim_set_hl(0, 'cssUIAttr', { fg = '#859900' })
vim.api.nvim_set_hl(0, 'cssUIProp', { fg = '#93a1a1' })
vim.api.nvim_set_hl(0, 'cssUnitDecorators', { fg = '#859900' })
vim.api.nvim_set_hl(0, 'cssValueLength', { fg = '#b58900' })
vim.api.nvim_set_hl(0, 'cssValueNumber', { fg = '#b58900' })
vim.api.nvim_set_hl(0, 'sassAmpersand', { fg = '#b58900', bold = true })
vim.api.nvim_set_hl(0, 'sassClass', { fg = '#b58900', bold = true })
vim.api.nvim_set_hl(0, 'sassDefinition', { fg = '#93a1a1' })
vim.api.nvim_set_hl(0, 'sassProperty', { fg = '#93a1a1' })

return M

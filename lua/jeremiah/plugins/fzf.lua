local M = {
  -- Optional for icons.
  { "nvim-tree/nvim-web-devicons" },

  {
    "linrongbin16/fzfx.nvim",
    -- Optional to avoid break changes between major versions.
    version = "v8.*",
    dependencies = { "nvim-tree/nvim-web-devicons", 'junegunn/fzf' },
    config = function()
      require("fzfx").setup()
    end,
  },
}
-- ======== files ========

-- by args
vim.keymap.set(
  "n",
  "<leader>f",
  "<cmd>FzfxFiles<cr>",
  { silent = true, noremap = true, desc = "Find files" }
)
-- by visual select
vim.keymap.set(
  "x",
  "<leader>f",
  "<cmd>FzfxFiles visual<CR>",
  { silent = true, noremap = true, desc = "Find files" }
)
-- by cursor word
vim.keymap.set(
  "n",
  "<leader>wf",
  "<cmd>FzfxFiles cword<cr>",
  { silent = true, noremap = true, desc = "Find files by cursor word" }
)
-- by yank text
vim.keymap.set(
  "n",
  "<leader>pf",
  "<cmd>FzfxFiles put<cr>",
  { silent = true, noremap = true, desc = "Find files by yank text" }
)
-- by resume
vim.keymap.set(
  "n",
  "<leader>rf",
  "<cmd>FzfxFiles resume<cr>",
  { silent = true, noremap = true, desc = "Find files by resume last" }
)

-- ======== live grep ========

-- live grep
vim.keymap.set(
  "n",
  "<leader>l",
  "<cmd>FzfxLiveGrep<cr>",
  { silent = true, noremap = true, desc = "Live grep" }
)
-- by visual select
vim.keymap.set(
  "x",
  "<leader>l",
  "<cmd>FzfxLiveGrep visual<cr>",
  { silent = true, noremap = true, desc = "Live grep" }
)
-- by cursor word
vim.keymap.set(
  "n",
  "<leader>wl",
  "<cmd>FzfxLiveGrep cword<cr>",
  { silent = true, noremap = true, desc = "Live grep by cursor word" }
)
-- by yank text
vim.keymap.set(
  "n",
  "<leader>pl",
  "<cmd>FzfxLiveGrep put<cr>",
  { silent = true, noremap = true, desc = "Live grep by yank text" }
)
-- by resume
vim.keymap.set(
  "n",
  "<leader>rl",
  "<cmd>FzfxLiveGrep resume<cr>",
  { silent = true, noremap = true, desc = "Live grep by resume last" }
)

-- ======== buffers ========

-- by args
vim.keymap.set(
  "n",
  "<leader>bf",
  "<cmd>FzfxBuffers<cr>",
  { silent = true, noremap = true, desc = "Find buffers" }
)

-- ======== git files ========

-- by args
vim.keymap.set(
  "n",
  "<leader>gf",
  "<cmd>FzfxGFiles<cr>",
  { silent = true, noremap = true, desc = "Find git files" }
)

-- ======== git live grep ========

-- by args
vim.keymap.set(
  "n",
  "<leader>gl",
  "<cmd>FzfxGLiveGrep<cr>",
  { silent = true, noremap = true, desc = "Git live grep" }
)
-- by visual select
vim.keymap.set(
  "x",
  "<leader>gl",
  "<cmd>FzfxGLiveGrep visual<cr>",
  { silent = true, noremap = true, desc = "Git live grep" }
)
-- by cursor word
vim.keymap.set(
  "n",
  "<leader>wgl",
  "<cmd>FzfxGLiveGrep cword<cr>",
  { silent = true, noremap = true, desc = "Git live grep by cursor word" }
)
-- by yank text
vim.keymap.set(
  "n",
  "<leader>pgl",
  "<cmd>FzfxGLiveGrep put<cr>",
  { silent = true, noremap = true, desc = "Git live grep by yank text" }
)
-- by resume
vim.keymap.set(
  "n",
  "<leader>rgl",
  "<cmd>FzfxGLiveGrep resume<cr>",
  { silent = true, noremap = true, desc = "Git live grep by resume last" }
)

-- ======== git changed files (status) ========

-- by args
vim.keymap.set(
  "n",
  "<leader>gs",
  "<cmd>FzfxGStatus<cr>",
  { silent = true, noremap = true, desc = "Find git changed files (status)" }
)

-- ======== git branches ========

-- by args
vim.keymap.set(
  "n",
  "<leader>br",
  "<cmd>FzfxGBranches<cr>",
  { silent = true, noremap = true, desc = "Search git branches" }
)

-- ======== git commits ========

-- by args
vim.keymap.set(
  "n",
  "<leader>gc",
  "<cmd>FzfxGCommits<cr>",
  { silent = true, noremap = true, desc = "Search git commits" }
)

-- ======== git blame ========

-- by args
vim.keymap.set(
  "n",
  "<leader>gb",
  "<cmd>FzfxGBlame<cr>",
  { silent = true, noremap = true, desc = "Search git blame" }
)

-- ======== lsp diagnostics ========

-- -- by args
-- vim.keymap.set(
--   "n",
--   "<leader>dg",
--   "<cmd>FzfxLspDiagnostics<cr>",
--   { silent = true, noremap = true, desc = "Search lsp diagnostics" }
-- )

-- -- ======== lsp symbols ========

-- -- lsp definitions
-- vim.keymap.set(
--   "n",
--   "gd",
--   "<cmd>FzfxLspDefinitions<cr>",
--   { silent = true, noremap = true, desc = "Goto lsp definitions" }
-- )

-- -- lsp type definitions
-- vim.keymap.set(
--   "n",
--   "gt",
--   "<cmd>FzfxLspTypeDefinitions<cr>",
--   { silent = true, noremap = true, desc = "Goto lsp type definitions" }
-- )

-- -- lsp references
-- vim.keymap.set(
--   "n",
--   "gr",
--   "<cmd>FzfxLspReferences<cr>",
--   { silent = true, noremap = true, desc = "Goto lsp references" }
-- )

-- -- lsp implementations
-- vim.keymap.set(
--   "n",
--   "gi",
--   "<cmd>FzfxLspImplementations<cr>",
--   { silent = true, noremap = true, desc = "Goto lsp implementations" }
-- )

-- -- lsp incoming calls
-- vim.keymap.set(
--   "n",
--   "gI",
--   "<cmd>FzfxLspIncomingCalls<cr>",
--   { silent = true, noremap = true, desc = "Goto lsp incoming calls" }
-- )

-- -- lsp outgoing calls
-- vim.keymap.set(
--   "n",
--   "gO",
--   "<cmd>FzfxLspOutgoingCalls<cr>",
--   { silent = true, noremap = true, desc = "Goto lsp outgoing calls" }
-- )

-- ======== vim commands ========

-- by args
vim.keymap.set(
  "n",
  "<leader>cm",
  "<cmd>FzfxCommands<cr>",
  { silent = true, noremap = true, desc = "Search vim commands" }
)

-- ======== vim key maps ========

-- by args
vim.keymap.set(
  "n",
  "<leader>km",
  "<cmd>FzfxKeyMaps<cr>",
  { silent = true, noremap = true, desc = "Search vim keymaps" }
)

-- ======== vim marks ========

-- by args
vim.keymap.set(
  "n",
  "<leader>mk",
  "<cmd>FzfxMarks<cr>",
  { silent = true, noremap = true, desc = "Search vim marks" }
)

-- ======== file explorer ========

-- by args
vim.keymap.set(
  "n",
  "<leader>xp",
  "<cmd>FzfxFileExplorer<cr>",
  { silent = true, noremap = true, desc = "File explorer" }
)

return M

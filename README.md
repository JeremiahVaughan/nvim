1. Clone this repo:
    - Windows:
        `git clone https://github.com/JeremiahVaughan/nvim-struggle ~/AppData/Local/nvim`
    - Linux:
        `git clone https://github.com/JeremiahVaughan/nvim-struggle ~/.config/nvim`
    - Mac:
        `~/.config/nvim`
2. Install nvim-qt:
    - https://github.com/equalsraf/neovim-qt
3. Install ripgrep for fuzzy search
    - https://github.com/BurntSushi/ripgrep#installation
4. Install make for :make command to work
    - Windows:
        - `choco install make`
5. If on windows install 'git bash'
6. Install staticcheck for more golang static checkness
    - https://github.com/dominikh/go-tools?tab=readme-ov-file 
7. Install zig to avoid compilation issues
    - https://ziglang.org/learn/getting-started/#installing-zig
8. Install nerd-fonts-hack for Hack Nerd Font Mono
    - `https://github.com/ryanoasis/nerd-fonts`
9. Open nvim:
    - `nvim-qt`
10. You will see an install error, its ok, it just means something needs to be installed before it can be used so just need to install
11. Restart nvim
12. Run this to ensure everything is working properly
    - `:checkhealth`
13. Install LazyGit
    - `https://github.com/jesseduffield/lazygit`
14. Install Delta-diff for better diff indicators for LazyGit
15. Install jq
    - `https://jqlang.github.io/jq/download/`
    - `https://github.com/dandavison/delta`
17. Install LazyDocker
    - `https://github.com/jesseduffield/lazydocker`
18. Install k9s
    - `https://k9scli.io/topics/install`
19. Install bat (currently using this for my snippets generator)
    - `https://github.com/sharkdp/bat?tab=readme-ov-file#installation`
20. Ensure the latest version of curl is installed, because leetcode.nvim requires it.
    - `https://curl.se/windows/`
    - Ensure the bin folder is on the path and before all other paths (system too) to ensure that the new version of curl is found before the old one is.

Note:
- nvim-qt is available on mac too: https://github.com/equalsraf/neovim-qt
- .ideavimrc is also saved in this directory for convenience. Move this to the HOME directory and restart Jetbrains for it to take effect.
- If you run into trouble you can read the init logs with:
    - `:messages`

Good References:
    - https://github.com/nvim-treesitter/nvim-treesitter/wiki/Windows-support


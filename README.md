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
14. Install LazyDocker
    - `https://github.com/jesseduffield/lazydocker`
15. Install Delta-diff for better diff indicators for LazyGit
16. Install jq
    - `https://jqlang.github.io/jq/download/`
    - `https://github.com/dandavison/delta`
17. Install k9s
    - `https://k9scli.io/topics/install`
18. Install bat (currently using this for my snippets generator)
    - `https://github.com/sharkdp/bat?tab=readme-ov-file#installation`
19. Ensure the latest version of curl is installed, because leetcode.nvim requires it.
    - `https://curl.se/windows/`
    - Ensure the bin folder is on the path and before all other paths (system too) to ensure that the new version of curl is found before the old one is.

20. For copy paste to work on remote ssh sessions
    - Mac: `use Iterm2`
    - Mac other:
        - copy the file `.alacritty.toml` in the root of this project to `$HOME/.alacritty.toml`
            or
        - copy the file `.wezterm.lua` in the root of this project to `$HOME/.wezterm.lua`
    - Windows:
        - copy the file `.alacritty.toml` in the root of this project to `%APPDATA%\alacritty\alacritty.toml`
            or
        - copy the file `.wezterm.lua` in the root of this project to `$HOME/.wezterm.lua`
21. Install delve for debugging
    - `go install github.com/go-delve/delve/cmd/dlv@latest`
22. The rest.nvim plugin requires these to be installed
    - All of this:
        - Specific C compiler
            - `sudo apt update && sudo apt install gcc -y`
        - Dev Version of Lua
            - Linux:
                - `sudo apt install liblua5.1-0-dev`
            - Windows:
                - `choco install lua`
        - Lua Rocks
            - `https://luarocks.org`
            - Windows:
                - Binary download:
                    - `https://luarocks.github.io/luarocks/releases/`
    - Or this:
        - hererocks:
            - `https://pypi.org/project/hererocks/`
23. If you plan on using terragrunt, enable provider cache so you disk doesn't bloat:
    - `export TERRAGRUNT_PROVIDER_CACHE=1`
    - Ref: `https://terragrunt.gruntwork.io/docs/features/provider-cache/`
24. Install starship:
    - From: https://starship.rs
    - Windows:
        - Set execution policy:
        `ExecutionPolicy RemoteSigned -scope CurrentUser`
        - Add this file to this location:
            - File: Microsoft.PowerShell_profile.ps1
            - Location: $profile
25. Set your open API key
    - export OPENAI_API_KEY=<key here>
26. Install simple-chat-gpt:
    `go install github.com/JeremiahVaughan/simple-chat-gpt@v1.1.2`


Note:
- nvim-qt is available on mac too: https://github.com/equalsraf/neovim-qt
- .ideavimrc is also saved in this directory for convenience. Move this to the HOME directory and restart Jetbrains for it to take effect.
- If you run into trouble you can read the init logs with:
    - `:messages`

Good References:
    - https://github.com/nvim-treesitter/nvim-treesitter/wiki/Windows-support


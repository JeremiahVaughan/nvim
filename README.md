Main goal of my setup: Be platform agnostic, so it should be a very similar experience regardless of linux, mac, or windows

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
9. Install wezterm
10. Open nvim:
    - `nvim`
11. You will see an install error, its ok, it just means something needs to be installed before it can be used so just need to install
12. Restart nvim
13. Run this to ensure everything is working properly
    - `:checkhealth`
14. Install LazyGit
    - `https://github.com/jesseduffield/lazygit`
15. Install LazyDocker
    - `https://github.com/jesseduffield/lazydocker`
16. Install Delta-diff for better diff indicators for LazyGit
17. Install jq
    - `https://jqlang.github.io/jq/download/`
    - `https://github.com/dandavison/delta`
18. Install k9s
    - `https://k9scli.io/topics/install`
19. Install bat (currently using this for my snippets generator)
    - `https://github.com/sharkdp/bat?tab=readme-ov-file#installation`
20. Ensure the latest version of curl is installed, because leetcode.nvim requires it.
    - `https://curl.se/windows/`
    - Ensure the bin folder is on the path and before all other paths (system too) to ensure that the new version of curl is found before the old one is.

21. For copy paste to work on remote ssh sessions
    - Mac: `use Iterm2`
    - Mac other:
        - copy the file `.alacritty.toml` in the root of this project to `$HOME/.alacritty.toml`
            or
        - copy the file `.wezterm.lua` in the root of this project to `$HOME/.wezterm.lua`
    - Windows:
        - copy the file `.alacritty.toml` in the root of this project to `%APPDATA%\alacritty\alacritty.toml`
            or
        - copy the file `.wezterm.lua` in the root of this project to `$HOME/.wezterm.lua`
22. Install delve for debugging
    - `go install github.com/go-delve/delve/cmd/dlv@latest`
23. The rest.nvim plugin requires these to be installed
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
24. If you plan on using terragrunt, enable provider cache so you disk doesn't bloat:
    - `export TERRAGRUNT_PROVIDER_CACHE=1`
    - Ref: `https://terragrunt.gruntwork.io/docs/features/provider-cache/`
25. Install starship:
    - From: https://starship.rs
    - Windows:
        - Set execution policy:
        `ExecutionPolicy RemoteSigned -scope CurrentUser`
        - Add this file to this location:
            - File: Microsoft.PowerShell_profile.ps1
            - Location: $profile
26. Set your open API key
    - export OPENAI_API_KEY=<key here>
27. Install simple-chat-gpt:
    `go install github.com/JeremiahVaughan/simple-chat-gpt@latest`
28. Install git-tool:
    `go install github.com/JeremiahVaughan/git-tool@latest`
29. Restore Vimium from backup
30. Move karabiner or auto hotkey config into the correct directory
31. Install htop for monitoring resources (its like top but much easier to read)
    - Unix: `brew install htop`
    - Windows: `choco install ntop.portable`
32. Install Flameshot and bind screen shot and snip to control+x
33. Ensure the chrome web extension `Tab Limit` is installed and set to 4 tabs
34. Install http lsp:
    - `go install github.com/JeremiahVaughan/http-lsp@latest`
    


Note:
- nvim-qt is available on mac too: https://github.com/equalsraf/neovim-qt
- .ideavimrc is also saved in this directory for convenience. Move this to the HOME directory and restart Jetbrains for it to take effect.
- If you run into trouble you can read the init logs with:
    - `:messages`

Good References:
    - https://github.com/nvim-treesitter/nvim-treesitter/wiki/Windows-support


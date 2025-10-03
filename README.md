Main goal of my setup: Be platform agnostic, so it should be a very similar experience regardless of linux, mac, or windows

1. Clone this repo:
    - Windows:
        `git clone https://github.com/JeremiahVaughan/nvim ~/AppData/Local/nvim`
    - Linux:
        `git clone https://github.com/JeremiahVaughan/nvim ~/.config/nvim`
    - Mac:
        `~/.config/nvim`
2. Install nvim 
    - compile from source for latest version
    - `https://github.com/neovim/neovim`
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
8. Install webi cli: 
    - `https://webinstall.dev/webi/`
9. Install nerd-fonts-hack for Hack Nerd Font Mono
    - `https://github.com/ryanoasis/nerd-fonts`
    - use webi: `webi nerdfont`
10. Install wezterm
11. Install alacritty
12. Open nvim:
    - If You will see an install error, its ok, it just means something needs to be installed before it can be used so just need to install
    - Restart nvim
    - Run this to ensure everything is working properly
        - `:checkhealth`
13. Install LazyGit
    - `https://github.com/jesseduffield/lazygit`
    - emplace config file:  
        - windows: `%APPDATA%\lazygit\config.yml`
        - linux: `~/.config/lazygit/config.yml`
14. Install LazyDocker
    - `https://github.com/jesseduffield/lazydocker`
15. Install jq
    - `https://jqlang.github.io/jq/download/`
16. Install delta for better diff indicators for LazyGit
    - `https://github.com/dandavison/delta`
17. Install k9s
    - `https://k9scli.io/topics/install`
18. Install bat (currently using this for my snippets generator)
    - `https://github.com/sharkdp/bat?tab=readme-ov-file#installation`

19. For copy paste to work on remote ssh sessions
    - Mac: `use Iterm2`
    - Mac other:
        - copy the file `.alacritty.toml` in the root of this project to `$HOME/.alacritty.toml`
            or
        - copy the file `.wezterm.lua` in the root of this project to `$HOME/.wezterm.lua`
    - Windows:
        - copy the file `.alacritty.toml` in the root of this project to `%APPDATA%\alacritty\alacritty.toml`
            or
        - copy the file `.wezterm.lua` in the root of this project to `$HOME/.wezterm.lua`
20. The rest.nvim plugin requires these to be installed
    - All of this:
        - Specific C compiler
            - `sudo apt update && sudo apt install gcc -y`
21. If you plan on using terragrunt, enable provider cache so you disk doesn't bloat:
    - `export TERRAGRUNT_PROVIDER_CACHE=1`
    - Ref: `https://terragrunt.gruntwork.io/docs/features/provider-cache/`
22. Install starship:
    - From: https://starship.rs
        - put ./starship/starship.toml at ~/.config/starship.toml
    - Windows:
        - Add ./starship/Microsoft.PowerShell_profile.ps1 to the $profile location ($profile is meant to be run in powershell):
        - put ./starship/starship.toml at ~/.config/starship.toml
23. Restore Vimium from backup
24. Install htop for monitoring resources (its like top but much easier to read)
    - Unix: `brew install htop`
    - Windows: `choco install ntop.portable`
25. Install Flameshot and bind screen shot and snip to control+x
    - Screenshot setup reference: https://github.com/flameshot-org/flameshot/issues/3712#issuecomment-2380547929
    - Shortcut name: Screen Shot
    - Shortcut value: /home/piegarden/.config/nvim/screenshot.sh
    - Shortcut key map: ctrl+x
26. Ensure the chrome web extension `Tab Limit` is installed and set to 4 tabs
27. Emplace .gitconfig file at ~/
28. Ubuntu assessibility options:
    - Turn off those slow animations
    - Opt in for large text
    - Enabled "Night Light" -> Settings -> Displays -> Night Light
    - Setup up finger print reader
29. Install for dadbod plugin
    - Windows:
        - `choco install psql`
        - `https://dev.mysql.com/downloads/installer/`
            - Ensure you have the correct version of mysql client installed for the corresponding server, otherwise you will get a password auth error of all things
30. Install One Password TUI
    - Install one password CLI: `https://developer.1password.com/docs/cli/get-started/#install`
    - `go install github.com/JeremiahVaughan/one-password-tui@latest`
31. Install fd
   `webi fd` 
32. On windows install du (it is already installed on linux)
    `choco install du`
33. Install shellcheck for working with sh scripts:
    `https://github.com/koalaman/shellcheck`
34. Install dive for exploring docker images
    - `https://github.com/wagoodman/dive`
    - Windows: add env var: DOCKER_HOST=npipe:////./pipe/docker_engine
    - Ensure you use `dive <image id>` with private repositories
35. Set docker build kit as enabled: export DOCKER_BUILDKIT=1
36. Install github cli:
    `webi gh`
37. install i3
    `sudo apt install i3 -y`
    `mkdir -p ~/.config/i3`
    `cp ./i3/config ~/.config/i3/config`
38. install zsh (optional - bash is fine)
    `sudo apt install zsh -y`
    `chsh -s /bin/zsh`
39. Add ssh key
    `nvim id_ed25519`
    `chmod 600 id_ed25519`
40. Create deploy and service folder at home
    `mkdir -p ~/deploy`
    `mkdir -p ~/.local/share/systemd/user`
41. Setup deploy.target in .ssh/config file
42. Install codex
    `brew install codex`
43. Move .ideavimrc to the HOME directory and restart Jetbrains for it to take effect.

    

Note:
- If you run into trouble with nvim you can read the init logs with:
    - `:messages`

Good References:
    - https://github.com/nvim-treesitter/nvim-treesitter/wiki/Windows-support


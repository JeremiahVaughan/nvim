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
5. Install staticcheck for more golang static checkness
    - https://github.com/dominikh/go-tools?tab=readme-ov-file 
6. If working with windows you will need to install Visual Studio community
     1. https://visualstudio.microsoft.com/downloads/?q=build+tools
     2. Choose the workload called "Desktop development with C++"
     3. Click install
     4. Will want to install some fonts too: https://www.nerdfonts.com/font-downloads I am currently used to this one: 
         - `Hack Nerd Font Mono` @ https://github.com/ryanoasis/nerd-fonts`
7. Install mingw for the things visual studio misses: 
    - `choco install mingw`
8. Clone config repo:
    - Windows: 
        - `git clone https://github.com/JeremiahVaughan/nvim-struggle ~/AppData/Local/nvim`
    - Not Windows: 
        - `git clone https://github.com/JeremiahVaughan/nvim-struggle ~/.config/nvim`
9. Open nvim:
    - `nvim-qt`
10. You will see an install error, its ok, it just means something needs to be installed before it can be used so just need to install
11. Install plugins:
    - `:PackerInstall`
12. Restart nvim
13. Install firenvim
    - `https://github.com/glacambre/firenvim?tab=readme-ov-file` 
14. Run this to ensure everything is working properly
    - `:checkhealth`

Note:
- nvim-qt is available on mac too: https://github.com/equalsraf/neovim-qt
- .ideavimrc is also saved in this directory for convenience. Move this to the HOME directory and restart Jetbrains for it to take effect.
- If you run into trouble you can read the init logs with:
    - `:messages`

Good References:
    - https://github.com/nvim-treesitter/nvim-treesitter/wiki/Windows-support



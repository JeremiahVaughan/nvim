Main goal of my setup: Be platform agnostic, so it should be a very similar experience regardless of Linux, macOS, or Windows.

## Setup Checklist

1. Clone this repo:
   - Windows
     ```powershell
     git clone https://github.com/JeremiahVaughan/nvim ~/AppData/Local/nvim
     ```
   - Linux
     ```bash
     git clone https://github.com/JeremiahVaughan/nvim ~/.config/nvim
     ```
   - macOS
     ```bash
     git clone https://github.com/JeremiahVaughan/nvim ~/.config/nvim
     ```

2. Install Neovim.
   - Prefer compiling from source for the latest version.
   - Reference: https://github.com/neovim/neovim

3. Install ripgrep for fuzzy search.
   - Reference: https://github.com/BurntSushi/ripgrep#installation

4. Install `make` for the `:make` command.
   - Windows
     ```powershell
     choco install make
     ```

5. On Windows install Git Bash.

6. Install `staticcheck` for additional Go analysis.
   - Reference: https://github.com/dominikh/go-tools?tab=readme-ov-file

7. Install Zig to avoid compilation issues.
   - Reference: https://ziglang.org/learn/getting-started/#installing-zig

8. Install Webi CLI.
   - Reference: https://webinstall.dev/webi/

9. Install Nerd Fonts Hack (Hack Nerd Font Mono).
   - Reference: https://github.com/ryanoasis/nerd-fonts
   - Or via Webi:
     ```bash
     webi nerdfont
     ```

10. Install WezTerm.

11. Install Alacritty.

12. Open Neovim.
   - If you see an install error, it just means something needs to be installed; handle the dependency and restart Neovim.
   - After restarting, run:
     ```vim
     :checkhealth
     ```

13. Install LazyGit.
   - Reference: https://github.com/jesseduffield/lazygit
   - Emplace config file:
     - Windows
       ```powershell
       Copy-Item .\lazygit\config.yml $env:APPDATA\lazygit\config.yml
       ```
     - Linux
       ```bash
       mkdir -p ~/.config/lazygit
       cp ./lazygit/config.yml ~/.config/lazygit/config.yml
       ```

14. Install LazyDocker.
   - Reference: https://github.com/jesseduffield/lazydocker

15. Install `jq`.
   - Reference: https://jqlang.github.io/jq/download/

16. Install `delta` for improved diffs in LazyGit.
   - Reference: https://github.com/dandavison/delta

17. Install k9s.
   - Reference: https://k9scli.io/topics/install

18. Install `bat` (used by the snippets generator).
   - Reference: https://github.com/sharkdp/bat?tab=readme-ov-file#installation

19. Configure copy/paste for remote SSH sessions.
   - macOS via iTerm2 (recommended).
   - macOS alternative:
     ```bash
     cp ./alacritty.toml "$HOME/.alacritty.toml"
     ```
     or
     ```bash
     cp ./.wezterm.lua "$HOME/.wezterm.lua"
     ```
   - Windows:
     ```powershell
     Copy-Item .\alacritty.toml $env:APPDATA\alacritty\alacritty.toml
     ```
     or
     ```powershell
     Copy-Item .\.wezterm.lua $env:USERPROFILE\.wezterm.lua
     ```

20. Enable the Terraform provider cache when using Terragrunt.
   ```bash
   export TERRAGRUNT_PROVIDER_CACHE=1
   ```
   - Reference: https://terragrunt.gruntwork.io/docs/features/provider-cache/

21. Install Starship.
   - Reference: https://starship.rs
   - Place configs:
     ```bash
     cp ./starship/starship.toml ~/.config/starship.toml
     ```
   - Windows PowerShell profile:
     ```powershell
     Copy-Item .\starship\Microsoft.PowerShell_profile.ps1 $profile
     ```

22. Restore Vimium from backup.

23. Install `htop` for resource monitoring.
   - Unix
     ```bash
     brew install htop
     ```
   - Windows
     ```powershell
     choco install ntop.portable
     ```

24. Install Flameshot and bind screenshot/snipping to `Ctrl+X`.
   - Reference: https://github.com/flameshot-org/flameshot/issues/3712#issuecomment-2380547929
   - Shortcut name: Screen Shot
   - Shortcut value: /home/piegarden/.config/nvim/screenshot.sh
   - Shortcut key map: ctrl+x

25. Ensure the Chrome Tab Limit extension is installed and set to 4 tabs.

26. Emplace `.gitconfig` at `~/`.

27. Ubuntu accessibility adjustments:
   - Disable slow animations.
   - Enable large text.
   - Enable Night Light via Settings → Displays.
   - Configure fingerprint reader.

28. Install database clients for `vim-dadbod`.
   - Windows
     ```powershell
     choco install psql
     ```
   - Reference: https://dev.mysql.com/downloads/installer/
     - Ensure the client version matches the server to avoid password auth errors.

29. Install 1Password TUI.
   - Install 1Password CLI: https://developer.1password.com/docs/cli/get-started/#install
   ```bash
   go install github.com/JeremiahVaughan/one-password-tui@latest
   ```

30. Install `fd`.
   ```bash
   webi fd
   ```

31. On Windows install `du`.
   ```powershell
   choco install du
   ```

32. Install `shellcheck` for shell script linting.
   - Reference: https://github.com/koalaman/shellcheck

33. Install `dive` for inspecting Docker images.
   - Reference: https://github.com/wagoodman/dive
   - Windows: set
     ```powershell
     setx DOCKER_HOST npipe:////./pipe/docker_engine
     ```
   - Use `dive <image-id>` with private repositories.

34. Enable Docker BuildKit.
   ```bash
   export DOCKER_BUILDKIT=1
   ```

35. Install GitHub CLI.
   ```bash
   webi gh
   ```

36. Install i3.
   ```bash
   sudo apt install i3 -y
   mkdir -p ~/.config/i3
   cp ./i3/config ~/.config/i3/config
   ```

37. Install zsh (optional; bash is fine).
   ```bash
   sudo apt install zsh -y
   chsh -s /bin/zsh
   ```

38. Add SSH key.
   ```bash
   nvim id_ed25519
   chmod 600 id_ed25519
   ```

39. Create deploy and service directories.
   ```bash
   mkdir -p ~/deploy
   mkdir -p ~/.local/share/systemd/user
   ```

40. Configure `production` & `staging` in `.ssh/config`.

41. Install Codex (he likes using python as a tool so we add that for him).
   ```bash
   brew install codex
   webi python3
   ```

42. fzf
   ```bash
   webi fzf
   ```

43. install neovide https://neovide.dev/
    - Arch
    ```
    sudo pacman -S neovide
    ```
    - Windows
    ```
    scoop bucket add extras
    scoop install neovide
    Open shortcut location
    Right click shortcut and select properties
    Add  "--wsl --neovim-bin /home/linuxbrew/.linuxbrew/bin/nvim" to the end of the target
    ```




42. Move `.ideavimrc` to the home directory and restart JetBrains.

43. Install the `nvim-helper` CLI used by `<leader>b` and the random log helpers.
   ```bash
   cd ~/.config/nvim/tools/nvim-helper
   go install
   ```
   - Ensure the resulting binary directory (usually `$GOBIN` or `$GOPATH/bin`) is on your `PATH`.
   - Run `make nvim-helper-test` (from the repo root) to execute the helper's unit tests; the command automatically isolates Go's build cache in `/tmp/nvim-gocache`.
   - Run `make base64-test` to execute the Neovim end-to-end check that exercises the mapping against a scratch buffer.
   - Use `:GoUpdate` inside Neovim to run the helper's Go module updater; set `vim.g.go_update_target_version` (defaults to `1.24.7`) to control the enforced `go` directive and populate the quickfix list with updated `go.mod` files.

44. Install sops
    - `https://github.com/getsops/sops/releases`

## Notes
- If Neovim misbehaves, view logs with:
  ```vim
  :messages
  ```

## References
- https://github.com/nvim-treesitter/nvim-treesitter/wiki/Windows-support

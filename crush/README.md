# Install
Emplace the ./config.json file:
```bash
# save/merge any existing configs from $HOME/.local/share/crush/crush.json to ./config.json
mkdir -p $HOME/.local/share/crush
rm $HOME/.local/share/crush/crush.json
ln -s $HOME/.config/nvim/crush/config.json $HOME/.local/share/crush/crush.json
```
Add caveman skill to project
[Reference](https://github.com/JuliusBrussee/caveman/blob/main/caveman.skill)
```bash
# merge any existing skills you want to save from $HOME/.agents/skills to $HOME/.config/nvim/crush/skills
rm -rf $HOME/.agents/skills
# codex reads from here so making it the same location for crush as well to keep things simple
mkdir -p $HOME/.agents
ln -s $HOME/.config/nvim/crush/skills $HOME/.agents/skills
```

# Usage
Not sure why but apparently there is no way to use a skill by default.
So at the start of every session tell the agent:
```txt
use caveman
```

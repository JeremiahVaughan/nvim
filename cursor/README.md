link to skills
```bash
# merge any existing skills you want to save from $HOME/.cursor/skills to $HOME/.config/nvim/crush/skills
rm -rf $HOME/.cursor/skills
mkdir -p $HOME/.cursor
ln -s $HOME/.config/nvim/crush/skills $HOME/.cursor/skills
```

# Usage
Ensure you create a cursor rule per project
```bash
cat <<EOF > .cursorrules
use caveman skill always
EOF
```
Even though I added that rule, cursor is not following it be default. So guess I have to mention to 'use caveman skill' each time I start a new session


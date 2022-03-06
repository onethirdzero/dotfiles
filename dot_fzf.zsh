# Setup fzf
# ---------
if [[ ! "$PATH" == */home/jordan/.fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/home/jordan/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/jordan/.fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/home/jordan/.fzf/shell/key-bindings.zsh"

# User config.

# Also include hidden files.
# https://github.com/junegunn/fzf#respecting-gitignore
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'

export FZF_DEFAULT_OPTIONS="--no-mouse --height 30% --layout=reverse --info=inline"

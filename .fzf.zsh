# Setup fzf
# ---------
if [[ ! "$PATH" == */home/whe/.fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/home/whe/.fzf/bin"
fi

export FZF_DEFAULT_OPTS="--layout reverse"
# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/whe/.fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/home/whe/.fzf/shell/key-bindings.zsh"

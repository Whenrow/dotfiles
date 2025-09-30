# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
export ZSH="/home/whe/.oh-my-zsh"

export EDITOR="nvim"
# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"
# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(fzf colored-man-pages zsh-autosuggestions forgit postgres extract vi-mode)

source $ZSH/oh-my-zsh.sh

# source $HOME/.completions.zsh
# source $HOME/.key-bindings.zsh
export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
--layout reverse"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

# Path
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/lua-lsp/bin:$PATH"
export PATH="$PATH:$HOME/.erg/bin"
export ERG_PATH="$HOME/.erg"

# Forgit options
export FORGIT_COPY_CMD='xclip -selection clipboard'
export FORGIT_LOG_GRAPH_ENABLE='false'
export forgit_rebase=grbs

# miSc options
export SUDO_ASKPASS=/usr/bin/ssh-askpass
export VI_MODE_SET_CURSOR=true
export ODOO_RC="$HOME/.config/odoorc"
# export COMMUNITY_PATH="$HOME/src/odoo"

function fkill () {
    pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')

    if test -n "$pid"; then
        echo $pid | xargs kill -9
    fi
}
source ~/.zsh_alias

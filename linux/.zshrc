# Set tab title
print -Pn "\e]1;%n@%m\a"

# load the vcs_info plugin
autoload -Uz vcs_info
precmd() { vcs_info }

# Format the vcs_info_msg_0_ variable
zstyle ':vcs_info:git:*' formats '%F{magenta}{%b}'

# Initialize command prompt
setopt PROMPT_SUBST
PROMPT=$'\n''%(!.%F{red}%n:.)%F{cyan}%~${vcs_info_msg_0_} %F{yellow}%(!.#.>)%f '
# PROMPT=$'\n''%(!.%F{red}%n:.)%F{cyan}%~ %F{yellow}%(!.#.>)%f '

# Custom command alias if exists
[ -f ~/.bash_aliases ] && . ~/.bash_aliases

# Useful completions
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}' # ignore case
zstyle ':completion:*' menu select                     # select as menu
zstyle ':completion:*' special-dirs true               # complete for .. path

# Global
export PATH=$PATH:$HOME/local/bin


# Set tab title
print -Pn "\e]1;%n@%m\a"

# Initialize command prompt
export PS1=$'\n'"%(!.%F{red}%n:.)%F{cyan}%~ %F{yellow}%(!.#.>)%f "

# Custom command alias if exists
[ -f ~/.bash_aliases ] && . ~/.bash_aliases

# Useful completions
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}' # ignore case
zstyle ':completion:*' menu select                     # select as menu
zstyle ':completion:*' special-dirs true               # complete for .. path

# Append path
export PATH=$PATH:$HOME/local/bin


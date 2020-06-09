# Method from: https://github.com/olivierverdier/zsh-git-prompt

# Allow for functions in the prompt.
setopt PROMPT_SUBST

autoload -U add-zsh-hook
add-zsh-hook chpwd chpwd_update_git_vars
add-zsh-hook preexec preexec_update_git_vars
add-zsh-hook precmd precmd_update_git_vars

## Function definitions
function preexec_update_git_vars() {
  case "$2" in
    git*|hub*|gh*|stg*)
    __EXECUTED_GIT_COMMAND=1
    ;;
  esac
}

function precmd_update_git_vars() {
  if [ -n "$__EXECUTED_GIT_COMMAND" ] || [ ! -n "$ZSH_THEME_GIT_PROMPT_CACHE" ]; then
    update_current_git_vars
    unset __EXECUTED_GIT_COMMAND
  fi
}

function chpwd_update_git_vars() {
  update_current_git_vars
}

function update_current_git_vars() {
  unset __CURRENT_GIT_STATUS
  _GIT_STATUS=`git status --porcelain --branch &> /dev/null | $HOME/local/bin/gitprompt`
  __CURRENT_GIT_STATUS=("${(@s: :)_GIT_STATUS}")
  GIT_BRANCH=$__CURRENT_GIT_STATUS[1]
  GIT_CONFLICTS=$__CURRENT_GIT_STATUS[5]
  GIT_CHANGED=$__CURRENT_GIT_STATUS[6]
  GIT_UNTRACKED=$__CURRENT_GIT_STATUS[7]
}

git_super_status() {
  precmd_update_git_vars
  if [ -n "$__CURRENT_GIT_STATUS" ]; then
    STATUS="%F{blue}(%F{red}$GIT_BRANCH"
    if [ "$GIT_CONFLICTS" -ne "0" ]; then
      STATUS="$STATUS%F{magenta}!"
    fi
    if [ "$GIT_CHANGED" -ne "0" ]; then
      STATUS="$STATUS%F{yellow}*"
    fi
    if [ "$GIT_UNTRACKED" -ne "0" ]; then
      STATUS="$STATUS%F{yellow}+"
    fi
    STATUS="$STATUS%F{blue})"
    echo "$STATUS"
  fi
}


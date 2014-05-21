# Aliases
alias g='git'
compdef g=git
alias ga='git add'
compdef _git ga=git-add
alias gaa='git add --all'
alias gl='git log -n 30 --graph --pretty=format:"$fg[red]%h$reset_color - $fg[yellow]%d$reset_color %s $fg[green](%cr)$reset_color $fg[blue]<%an>"'
alias gs='git status'
compdef _git gst=git-status
alias gd='git diff'
compdef _git gd=git-diff
alias gdc='git diff --cached'
compdef _git gdc=git-diff
alias gul='git pull origin $(current_branch)'
compdef _git gl=git-pull
alias gup='git push origin $(current_branch)'
compdef _git gp=git-push
alias gc='git commit -m'
compdef _git gcmsg=git-commit
alias gco='git checkout'
compdef _git gco=git-checkout
alias gb='git branch'
compdef _git gb=git-branch
alias gcp='git cherry-pick'
alias grh='git reset HEAD'
alias grhh='git reset HEAD --hard'

#
function current_branch() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || \
  ref=$(git rev-parse --short HEAD 2> /dev/null) || return
  echo ${ref#refs/heads/}
}

function current_repository() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || \
  ref=$(git rev-parse --short HEAD 2> /dev/null) || return
  echo $(git remote -v | cut -d':' -f 2)
}


# Pretty log messages
function _git_log_prettily(){
  if ! [ -z $1 ]; then
    git log --pretty=$1
  fi
}
alias glp="_git_log_prettily"
compdef _git glp=git-log

# these alias ignore changes to file
alias gignore='git update-index --assume-unchanged'
alias gunignore='git update-index --no-assume-unchanged'
# list temporarily ignored files
alias gignored='git ls-files -v | grep "^[[:lower:]]"'




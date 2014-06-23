# get stashed items
function git_stashed_items() {
  if git stash list > /dev/null 2>&1; then
    count=${$(command git stash list | wc -l | tr -d ' ' 2>/dev/null)}
    if [[ $count -gt 0 ]]; then
      echo "$ZSH_THEME_GIT_STASHED_PREFIX$count$ZSH_THEME_GIT_STASHED$ZSH_THEME_GIT_STASHED_SUFFIX"
    fi
  fi
}

# get the difference between the local and remote branches
git_remote_status() {
    remote=${$(command git rev-parse --verify ${hook_com[branch]}@{upstream} --symbolic-full-name 2>/dev/null)/refs\/remotes\i/}
    if [[ -n ${remote} ]] ; then
        ahead=$(command git rev-list ${hook_com[branch]}@{upstream}..HEAD 2>/dev/null | wc -l)
        behind=$(command git rev-list HEAD..${hook_com[branch]}@{upstream} 2>/dev/null | wc -l)

        if [ $ahead -eq 0 ] && [ $behind -gt 0 ] 
        then
            echo "$ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE"
        elif [ $ahead -gt 0 ] && [ $behind -eq 0 ] 
        then
            echo "$ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE"
        elif [ $ahead -gt 0 ] && [ $behind -gt 0 ] 
        then
            echo "$ZSH_THEME_GIT_PROMPT_DIVERGED_REMOTE"
        fi
    fi
}

# get the name of the branch we are on
function git_prompt_info() {
  if [[ "$(git config --get oh-my-zsh.hide-status)" != "1" ]]; then
    ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
    ref=$(command git rev-parse --short HEAD 2> /dev/null) || return
    echo "$ZSH_THEME_GIT_PROMPT_PREFIX$(parse_git)$ZSH_THEME_GIT_PROMPT_SUFFIX"
  fi
}

# Checks if working tree is dirty
parse_git() {
  local SUBMODULE_SYNTAX=''
  local GIT_STATUS=''
  local CLEAN_MESSAGE='nothing to commit (working directory clean)'
  if [[ "$(command git config --get oh-my-zsh.hide-status)" != "1" ]]; then
    if [[ $POST_1_7_2_GIT -gt 0 ]]; then
          SUBMODULE_SYNTAX="--ignore-submodules=dirty"
    fi

    if [[ "$DISABLE_UNTRACKED_FILES_DIRTY" == "true" ]]; then
        GIT_STATUS=$(command git status -s ${SUBMODULE_SYNTAX} -uno 2> /dev/null | tail -n1)
    else
        GIT_STATUS=$(command git status -s ${SUBMODULE_SYNTAX} 2> /dev/null | tail -n1)
    fi

    if [[ -n $GIT_STATUS ]]; then
      echo "$ZSH_THEME_GIT_PROMPT_DIRTY_PREFIX${ref#refs/heads/}$ZSH_THEME_GIT_PROMPT_DIRTY" 
    else
      echo "$ZSH_THEME_GIT_PROMPT_CLEAN_PREFIX${ref#refs/heads/}$ZSH_THEME_GIT_PROMPT_CLEAN"
    fi
  else
    echo "$ZSH_THEME_GIT_PROMPT_CLEAN_PREFIX${ref#refs/heads/}$ZSH_THEME_GIT_PROMPT_CLEAN"
  fi
}

# get last commit info
function git_last_commit() {
  if git rev-parse --git-dir > /dev/null 2>&1; then

    # Only proceed if there is actually a commit.
    if [[ $(command git log 2> /dev/null | grep -c "^fatal: bad default revision") == 0 ]]; then
      # Get the last commit.
      last_commit=$(git log --pretty=format:'%at' -1 2> /dev/null)
      now=$(date +%s)
      seconds_since_last_commit=$((now-last_commit))

      # Totals
      minutes=$((seconds_since_last_commit / 60))
      hours=$((seconds_since_last_commit/3600))

      # Sub-hours and sub-minutes
      days=$((seconds_since_last_commit / 86400))
      sub_hours=$((hours % 24))
      sub_minutes=$((minutes % 60))

      if [ $hours -gt 24 ]; then
          commit_age="${days}d"
      elif [ $minutes -gt 60 ]; then
          commit_age="${sub_hours}h${sub_minutes}m"
      else
          commit_age="${minutes}m"
      fi

      echo "$ZSH_THEME_GIT_LAST_COMMIT$(git_last_commit_info) - $commit_age ago%{$reset_color%}"
   fi
  fi
}

# Formats prompt string for current git commit short SHA
function git_last_commit_info() {
  SHA=$(command git rev-parse --short HEAD 2> /dev/null) &&
  MSG=$(command git log --format=%B -n 1 HEAD 2> /dev/null) &&
  echo "($SHA) $MSG[0,${COLUMNS} - 150]... "
}


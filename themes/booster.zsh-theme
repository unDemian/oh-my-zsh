# Booster ZSH Theme
#
# v0.0.1
# @author Andrei Demian
#

# COLORS
###########################################################################################

# Prompt colors
ZSH_THEME_PROMPT_CURRENT="%{$fg[blue]%}"
ZSH_THEME_PROMPT_USER="%{$FG[236]%}"
ZSH_THEME_PROMPT_CARRET=" %{$FG[105]%}"

# Carret Color
if [[ $USER == "root" ]]; then
  CARETCOLOR="red"
else
  CARETCOLOR="white"
fi

# LS colors, made with http://geoff.greer.fm/lscolors/
export LSCOLORS="exfxcxdxbxegedabagacad"
export LS_COLORS='di=34;40:ln=35;40:so=32;40:pi=33;40:ex=31;40:bd=34;46:cd=34;43:su=0;41:sg=0;46:tw=0;42:ow=0;43:'
export GREP_COLOR='1;33'

# Color & Style for git prompt
ZSH_THEME_GIT_PROMPT_PREFIX=" %{$reset_color%}⭠ "
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg[blue]%}%{$reset_color%}"
ZSH_THEME_GIT_LAST_COMMIT="%{$reset_color%}"

ZSH_THEME_GIT_PROMPT_DIRTY="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY_PREFIX="%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN_PREFIX="%{$fg[green]%}"

# Color & Style for git stashed items
ZSH_THEME_GIT_STASHED_PREFIX="%{$fg[yellow]%}☲ "
ZSH_THEME_GIT_STASHED=" stashed items %{$reset_color%}"
ZSH_THEME_GIT_STASHED_SUFFIX="    ----"

# Colors & Style for git remote status
ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE="%{$fg[red]%}    ⇉ Branch is AHEAD    %{$reset_color%}"
ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE="%{$fg[red]%}    ⇇ Branch is BEHIND    %{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIVERGED_REMOTE="%{$fg[red]%}    ⇄ Branch is DIVERGED    %{$reset_color%}"

# PROMPT
###########################################################################################

# Prompt variables
local separator=${(l:${COLUMNS}-55::-:)}
local current_dir="$ZSH_THEME_PROMPT_CURRENT%~"

# Prompt methods
function user_host() {
  if [[ -n $SSH_CONNECTION ]]; then
    me="$ZSH_THEME_PROMPT_USER%n@%m%{$reset_color%} "  
  else
    me=""  
  fi
  echo "$me"
}

# Prompt
PROMPT='
${separator} $(git_remote_status) $(git_stashed_items)
$(user_host)${current_dir}$(git_prompt_info)$ZSH_THEME_PROMPT_CARRET%(!.#.»)%{$reset_color%} '

RPROMPT='$(git_last_commit)'


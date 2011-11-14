# -----------------------------------------------------------------------------
#    FILE                  : araxia.zsh-theme
#    DESCRIPTION           : oh-my-zsh theme file
#    AUTHOR                : Seth Milliken <seth_github@araxia.net>
#    VERSION               : 1.1
#    PLUGINS               : vcs vi-mode shell
#    TERMINAL CAPABILITIES : unicode 256color
#    SCREENSHOT            :
#    FEATURES              : - demonstrates vcs plugin, including counts of each
#                          :     type of dirty file
#                          : - demonstrates use of shell plugin to facilitate
#                          :     easily themeable, more readable standard prompt
#                          :     elements
#                          : - demonstrates use of plugin configuration with
#                          :     associate arrays
#                          : - demonstrates entirely declarative configuration
#                          :     (all code lives in plugins to promote reuse and
#                          :     separation of concerns)
#                          : - demonstrates append technique of incrementally
#                          :      setting variables (to make configuration more
#                          :      readable and elements easier to move around)
#                          : - simple vi-mode indicator
#                          :     (prompt character changes to red)
#                          : - can toggle vi-mode off
#                          : - includes indicator of exit status of previous command
#                          : - includes indicator of shell-depth
#                          : - includes indicator of command number (for ease of
#                          :      using shell history functionality)
#                          : - can toggle between single and multiline
# -----------------------------------------------------------------------------

## Prompt # {{{
PROMPT=''
if [[ -n "$USE_MULTILINE_PROMPT" ]]; then
PROMPT+='⎛⎛ '
else
PROMPT+='$(command_number)'
PROMPT+='$(shell_depth)'
fi
PROMPT+='$(user_host_info)'
PROMPT+='$(rvm_info)'
PROMPT+='$(jobs_info)'
PROMPT+='$(vcs_status_prompt) '
if [[ -n "$USE_MULTILINE_PROMPT" ]]; then
PROMPT+="
"
PROMPT+='⎝⎝ $(command_number)'
PROMPT+='$(shell_depth)'
PROMPT+=" ⤷ "
fi
PROMPT+='$(path_info)'
if [[ -n "$USE_VI_MODE" ]]; then
PROMPT+='$(vi_mode_prompt_info)'
fi
PROMPT+='$(prompt_character)'

RPROMPT=''
RPROMPT+='$(exit_status)'
RPROMPT+='$(prompt_displayed_time)'

# }}} prompt

## SHELL Plugin Customization # {{{
SHELL_PLUGIN[user_info_prefix]="%b%F{208}"
SHELL_PLUGIN[user_info_suffix]="%f"

SHELL_PLUGIN[host_info_prefix]="%F{039}"
SHELL_PLUGIN[host_info_suffix]="%f"

if [[ -n "$USE_MULTILINE_PROMPT" ]]; then
SHELL_PLUGIN[user_host_info_prefix]=" "
SHELL_PLUGIN[user_host_info_suffix]=" ）"
else
SHELL_PLUGIN[user_host_info_prefix]="[ "
SHELL_PLUGIN[user_host_info_suffix]=" ]"
fi

SHELL_PLUGIN[command_number_prefix]=""
if [[ -n "$USE_MULTILINE_PROMPT" ]]; then
SHELL_PLUGIN[command_number_prefix]+=" "
fi
SHELL_PLUGIN[command_number_prefix]+="%{$bg[white]%}%{$fg_bold[grey]%} "
SHELL_PLUGIN[command_number_suffix]=" %{$reset_color%}"

SHELL_PLUGIN[jobs_info_prefix]="%{$bg[green]%}%{$fg[grey]%} "
SHELL_PLUGIN[jobs_info_suffix]=" %{$reset_color%}"

if [[ -n "$USE_MULTILINE_PROMPT" ]]; then
SHELL_PLUGIN[path_info_prefix]=" [ %F{178}"
SHELL_PLUGIN[path_info_suffix]="%f ]"
else
SHELL_PLUGIN[path_info_prefix]="[ %F{178}"
SHELL_PLUGIN[path_info_suffix]="%f ]"
fi

# }}} # shell
## VCS Plugin Customization # {{{

VCS_PLUGIN[no_vcs_symbol]="☾☽"
VCS_PLUGIN[separator]=" ⋮ "
VCS_PLUGIN[ahead_behind_suffix]=$VCS_PLUGIN[separator]

# Wrap VCS status
VCS_PLUGIN[prompt_prefix]="☾ "
VCS_PLUGIN[prompt_suffix]=" ☽"
VCS_PLUGIN[dirt_status_verbosity]="full"
VCS_PLUGIN[untracked_is_dirty]=
VCS_PLUGIN[include_dirty_counts]=true

# Change default modified character to `▹`: mnemonic "delta"
#VCS_PLUGIN[time_verbose]=true
VCS_PLUGIN[modified_symbol]="%{$fg_bold[green]%}"
VCS_PLUGIN[modified_symbol]+="▹"
VCS_PLUGIN[modified_symbol]+="%{$reset_color%}"

# Colors vary depending on time lapsed since last commit
VCS_PLUGIN[time_since_commit_neutral]="%{$fg[white]%}"
VCS_PLUGIN[time_since_commit_short]="%{$fg[green]%}"
VCS_PLUGIN[time_short_commit_medium]="%{$fg[yellow]%}"
VCS_PLUGIN[time_since_commit_long]="%{$fg[red]%}"

# Mercurial tweak
VCS_PLUGIN[rev_prefix]="%{$fg[green]%} "
VCS_PLUGIN[rev_suffix]="%{$reset_color%}"

# }}} vcs
## Rvm Customization # {{{
typeset -gA RVM_PLUGIN

RVM_PLUGIN[prefix]="%{$bg[red]%}"
RVM_PLUGIN[prefix]+="%{$fg[white]%}"
RVM_PLUGIN[prefix]+=" "
RVM_PLUGIN[suffix]=" "
RVM_PLUGIN[suffix]+="%{$reset_color%}"

function rvm_info() {
  local result=''
  local output=$(rvm-prompt i g 2> /dev/null)
  if [[ -n $output ]]; then
    result+="$RVM_PLUGIN[prefix]"
    result+=$output
    result+="$RVM_PLUGIN[suffix]"
  fi
  echo $result
}

# }}} vi-mode
## vi-mode Customization # {{{
MODE_INDICATOR="%{$fg_bold[red]%}"
#MODE_INDICATOR="%{$fg_bold[red]%}❮%{$reset_color%}%{$fg[red]%}❮❮%{$reset_color%}" # fancier alternate for RPROMPT inclusion

# }}} vi-mode

# vim: ft=zsh:fdm=marker

# -----------------------------------------------------------------------------
#    FILE                  : araxia.zsh-theme
#    DESCRIPTION           : oh-my-zsh theme file
#    AUTHOR                : Seth Milliken <seth_github@araxia.net>
#    VERSION               : 1.2
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
#                          : - can toggle between single-line, multi-line, and
#                          :   simplified prompts
# -----------------------------------------------------------------------------

typeset -gA RVM_PLUGIN
typeset -gA VENV_PLUGIN

## VCS Plugin Customization # {{{

if [[ -z "$USE_SIMPLIFIED_PROMPT" ]]; then
# Change default modified character to `▹`: mnemonic "delta"
VCS_PLUGIN[modified_symbol]="%{$fg_bold[green]%}"
VCS_PLUGIN[modified_symbol]+="▹"
VCS_PLUGIN[modified_symbol]+="%{$reset_color%}"
fi

# Mercurial tweak
VCS_PLUGIN[rev_prefix]="%{$fg[green]%} "
VCS_PLUGIN[rev_suffix]="%{$reset_color%}"

# }}} vcs
## vi-mode Customization # {{{
if [[ -z "$USE_SIMPLIFIED_PROMPT" ]]; then
MODE_INDICATOR="%{$fg_bold[red]%}❮%{$reset_color%}%{$fg[red]%}❮❮%{$reset_color%}" # fancier alternate for RPROMPT inclusion
else
MODE_INDICATOR="%{$bg[white]%}%{$fg_bold[red]%} NORMAL%{$reset_color%}"
fi
# }}} vi-mode
## Prompt # {{{

# Multi-line prompt
multi=''
multi+='⎛⎛ '
multi+='$(user_host_info)'
multi+='$(venv_info)'
multi+='$(rvm_info)'
multi+='$(jobs_info)'
multi+='$(vcs_status_prompt) '
multi+="
"
multi+='⎝⎝ $(command_number)'
multi+='$(shell_depth)'
multi+=" ⤷ "
multi+='$(path_info)'
if [[ -n "$USE_VI_MODE" ]]; then
multi+='$(vi_mode_prompt_info)'
fi
multi+='$(prompt_character)'


# Single-line prompt
single+='$(command_number)'
single+='$(shell_depth)'
single+='$(user_host_info)'
single+='$(rvm_info)'
single+='$(jobs_info)'
single+='$(vcs_status_prompt) '
single+='$(path_info)'
if [[ -n "$USE_VI_MODE" ]]; then
single+='$(vi_mode_prompt_info)'
fi
single+='$(prompt_character)'

# Simplified prompt
simple=''
simple+='$(user_host_info)'
simple+='$(rvm_info)'
simple+='$(jobs_info)'
simple+='$(path_info)'
simple+='$(vcs_status_prompt) '
simple+="
"
if [[ -n "$USE_VI_MODE" ]]; then
simple+='$(vi_mode_prompt_info)'
fi
simple+='$(command_number)'
simple+='$(prompt_character)'

RPROMPT=''
RPROMPT+='$(exit_status)'
RPROMPT+='$(prompt_displayed_time)'

RVM_PLUGIN[color]="%{$bg[red]%}%{$fg[white]%}"
VENV_PLUGIN[color]="%{$bg[blue]%}%{$fg[white]%}"

if [[ -n "$USE_SINGLELINE_PROMPT" ]]; then
    SHELL_PLUGIN[user_host_info_prefix]="[ "
    SHELL_PLUGIN[user_host_info_suffix]=" ]"

    SHELL_PLUGIN[host_info_prefix]="%F{039}"
    SHELL_PLUGIN[host_info_suffix]="%f"

    SHELL_PLUGIN[user_info_prefix]="%b%F{208}"
    SHELL_PLUGIN[user_info_suffix]="%f"

    SHELL_PLUGIN[path_info_prefix]="[ %F{178}"
    SHELL_PLUGIN[path_info_suffix]="%f ]"

    SHELL_PLUGIN[jobs_info_prefix]="%{$bg[green]%}%{$fg[black]%} "
    SHELL_PLUGIN[jobs_info_suffix]=" %{$reset_color%}"

    PROMPT=$single
else
    SHELL_PLUGIN[host_info_prefix]="%F{039}"
    SHELL_PLUGIN[host_info_suffix]="%f"

    SHELL_PLUGIN[user_info_prefix]="%b%F{208}"
    SHELL_PLUGIN[user_info_suffix]="%f"

    SHELL_PLUGIN[command_number_prefix]=" "
    SHELL_PLUGIN[command_number_prefix]+="%{$bg[white]%}%{$fg_bold[grey]%} "
    SHELL_PLUGIN[command_number_suffix]=" %{$reset_color%}"

    SHELL_PLUGIN[jobs_info_prefix]="%{$bg[green]%}%{$fg[black]%} "
    SHELL_PLUGIN[jobs_info_suffix]=" %{$reset_color%}"

    SHELL_PLUGIN[path_info_prefix]=" [ %F{178}"
    SHELL_PLUGIN[path_info_suffix]="%f ]"

    SHELL_PLUGIN[user_host_info_prefix]=" "
    SHELL_PLUGIN[user_host_info_suffix]=" ）"
    PROMPT=$multi
fi
if [[ -n "$USE_DECOLORIZED_PROMPT" ]]; then
    RVM_PLUGIN[color]="%{$bg[white]%}%{$fg[black]%}"
    SHELL_PLUGIN[user_host_info_prefix]="[ "
    SHELL_PLUGIN[user_host_info_suffix]=" ]"

    SHELL_PLUGIN[user_info_prefix]=""
    SHELL_PLUGIN[user_info_suffix]=""

    SHELL_PLUGIN[host_info_prefix]=""
    SHELL_PLUGIN[host_info_suffix]=""

    SHELL_PLUGIN[path_info_prefix]=" %{$fg[white]%}"
    SHELL_PLUGIN[path_info_suffix]="%{$reset_color%} "

    RPROMPT=''
fi
if [[ -n "$USE_SIMPLIFIED_PROMPT" ]]; then

    PROMPT=$simple
fi

# }}} prompt
## Rvm Customization # {{{
# Defaults
RVM_PLUGIN[prefix]="$RVM_PLUGIN[color]"
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

# }}} rvm
## Python venv Customization # {{{
# Defaults
VENV_PLUGIN[prefix]="$VENV_PLUGIN[color]"
VENV_PLUGIN[prefix]+=" "
VENV_PLUGIN[suffix]=" "
VENV_PLUGIN[suffix]+="%{$reset_color%}"

function venv_info() {
  local result=''
  local output=$VIRTUAL_ENV
  if [[ -n $output ]]; then
    result+="$VENV_PLUGIN[prefix]"
    result+=$(basename $output)
    result+="$VENV_PLUGIN[suffix]"
  fi
  echo $result
}

# }}} venv

# vim: ft=zsh:fdm=marker

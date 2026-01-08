# -*- mode: sh; eval: (sh-set-shell "zsh") -*-
#
# Plugin Name: vim
# Repository: https://github.com/johnstonskj/zsh-vim-plugin
#
# Description:
#
#   Add one-line description here...
#
# Public variables:
#
# * `VIM`; plugin-defined global associative array with the following keys:
#   * `_ALIASES`; a list of all aliases defined by the plugin.
#   * `_FUNCTIONS`; a list of all functions defined by the plugin.
#   * `_PLUGIN_DIR`; the directory the plugin is sourced from.
#

############################################################################
# Standard Setup Behavior
############################################################################

# See https://wiki.zshell.dev/community/zsh_plugin_standard#zero-handling
0="${ZERO:-${${0:#$ZSH_ARGZERO}:-${(%):-%N}}}"
0="${${(M)0:#/*}:-$PWD/$0}"

# See https://wiki.zshell.dev/community/zsh_plugin_standard#standard-plugins-hash
declare -gA VIM
VIM[_PLUGIN_DIR]="${0:h}"
VIM[_ALIASES]=""
VIM[_FUNCTIONS]=""

############################################################################
# Internal Support Functions
############################################################################

#
# This function will add to the `VIM[_FUNCTIONS]` list which is
# used at unload time to `unfunction` plugin-defined functions.
#
# See https://wiki.zshell.dev/community/zsh_plugin_standard#unload-function
# See https://wiki.zshell.dev/community/zsh_plugin_standard#the-proposed-function-name-prefixes
#
.vim_remember_fn() {
    builtin emulate -L zsh

    local fn_name="${1}"
    if [[ -z "${VIM[_FUNCTIONS]}" ]]; then
        VIM[_FUNCTIONS]="${fn_name}"
    elif [[ ",${VIM[_FUNCTIONS]}," != *",${fn_name},"* ]]; then
        VIM[_FUNCTIONS]="${VIM[_FUNCTIONS]},${fn_name}"
    fi
}
.vim_remember_fn .vim_remember_fn

.vim_define_alias() {
    local alias_name="${1}"
    local alias_value="${2}"

    alias ${alias_name}=${alias_value}

    if [[ -z "${VIM[_ALIASES]}" ]]; then
        VIM[_ALIASES]="${alias_name}"
    elif [[ ",${VIM[_ALIASES]}," != *",${alias_name},"* ]]; then
        VIM[_ALIASES]="${VIM[_ALIASES]},${alias_name}"
    fi
}
.vim_remember_fn .vim_remember_alias

############################################################################
# Plugin Unload Function
############################################################################

# See https://wiki.zshell.dev/community/zsh_plugin_standard#unload-function
vim_plugin_unload() {
    builtin emulate -L zsh

    # Remove all remembered functions.
    local plugin_fns
    IFS=',' read -r -A plugin_fns <<< "${VIM[_FUNCTIONS]}"
    local fn
    for fn in ${plugin_fns[@]}; do
        whence -w "${fn}" &> /dev/null && unfunction "${fn}"
    done
    
    # Remove all remembered aliases.
    local aliases
    IFS=',' read -r -A aliases <<< "${VIM[_ALIASES]}"
    local alias
    for alias in ${aliases[@]}; do
        unalias "${alias}"
    done

    # Remove the global data variable.
    unset VIM

    # Remove this function.
    unfunction vim_plugin_unload
}

############################################################################
# Plugin-defined Aliases
############################################################################

.vim_define_alias vi 'vim'

############################################################################
# Initialize Plugin
############################################################################

true

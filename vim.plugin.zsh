# -*- mode: sh; eval: (sh-set-shell "zsh") -*-
#
# @name: vim
# @brief: Provide alias `vi` for Vim.
# @repository: https://github.com/johnstonskj/zsh-vim-plugin
# @version: 0.1.1
# @license: MIT AND Apache-2.0
#

############################################################################
# @section Lifecycle
# @description Plugin lifecycle functions.
#

function todo_plugin_init() {
    @zplugins_define_alias vim vi 'vim'
}

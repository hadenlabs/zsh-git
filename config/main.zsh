#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

function git::config::main::factory {
    # shellcheck source=/dev/null
    source "${ZSH_GIT_PATH}"/config/base.zsh
    case "${OSTYPE}" in
    darwin*)
        # shellcheck source=/dev/null
        source "${ZSH_GIT_PATH}"/config/osx.zsh
        ;;
    linux*)
        # shellcheck source=/dev/null
        source "${ZSH_GIT_PATH}"/config/linux.zsh
      ;;
    esac
}

git::config::main::factory
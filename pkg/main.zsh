#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

function git::pkg::main::factory {
    # shellcheck source=/dev/null
    source "${ZSH_GIT_PATH}"/pkg/base.zsh
    case "${OSTYPE}" in
    darwin*)
        # shellcheck source=/dev/null
        source "${ZSH_GIT_PATH}"/pkg/osx.zsh
        ;;
    linux*)
        # shellcheck source=/dev/null
        source "${ZSH_GIT_PATH}"/pkg/linux.zsh
      ;;
    esac
    # shellcheck source=/dev/null
    source "${ZSH_GIT_PATH}"/pkg/helper.zsh

    # shellcheck source=/dev/null
    source "${ZSH_GIT_PATH}"/pkg/alias.zsh
}

git::pkg::main::factory

git::dependences::check
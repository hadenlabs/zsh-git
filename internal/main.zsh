#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

function git::internal::main::factory {
    # shellcheck source=/dev/null
    source "${ZSH_GIT_PATH}"/internal/base.zsh
    case "${OSTYPE}" in
    darwin*)
        # shellcheck source=/dev/null
        source "${ZSH_GIT_PATH}"/internal/osx.zsh
        ;;
    linux*)
        # shellcheck source=/dev/null
        source "${ZSH_GIT_PATH}"/internal/linux.zsh
      ;;
    esac

    # shellcheck source=/dev/null
    source "${ZSH_GIT_PATH}"/internal/helper.zsh
}

git::internal::main::factory

if ! type -p git > /dev/null; then git::internal::git::install; fi
if ! type -p hub > /dev/null; then git::internal::hub::install; fi
if ! type -p git-standup > /dev/null; then git::internal::standup::install; fi
if ! type -p git-flow > /dev/null; then git::internal::gitflow::install; fi
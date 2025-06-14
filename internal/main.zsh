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

if ! core::exists git; then core::install git; fi
if ! core::exists hub; then core::install hub; fi
if ! core::exists rsync; then core::install rsync; fi
if ! core::exists git-flow; then core::install git-flow; fi
if ! type -p git-standup > /dev/null; then git::internal::standup::install; fi
#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

# editgitconfig edit settings for git
function editgit {
    local path_git
    if [ -z "${EDITOR}" ]; then
        message_warning "it's neccesary the var EDITOR"
        return
    fi
    path_git="$(git-root)"
    if [ -z "${path_git}" ]; then
        message_warning "it's not is path of git"
        return
    fi
    "${EDITOR}" "${path_git}/.git/config"
}

# editgitconfigglobal edit settings for git global
function editgitglobal {
    if [ -z "${EDITOR}" ]; then
        message_warning "it's neccesary the var EDITOR"
        return
    fi
    "${EDITOR}" "${GIT_FILE_SETTINGS}"
}

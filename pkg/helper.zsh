#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

# editgitconfig edit settings for git
function editgit {
    if [ -z "${EDITOR}" ]; then
        message_warning "it's neccesary the var EDITOR"
        return
    fi
    "${EDITOR}" "$(git-root)/.git/config"
}

# editgitconfigglobal edit settings for git global
function editgitglobal {
    if [ -z "${EDITOR}" ]; then
        message_warning "it's neccesary the var EDITOR"
        return
    fi
    "${EDITOR}" "${GIT_FILE_SETTINGS}"
}

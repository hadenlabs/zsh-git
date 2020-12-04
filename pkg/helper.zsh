#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

# editgit edit settings for git
function editgit {
    if [ -z "${EDITOR}" ]; then
        message_warning "it's neccesary the var EDITOR"
        return
    fi
    "${EDITOR}" "${GIT_FILE_SETTINGS}"
}

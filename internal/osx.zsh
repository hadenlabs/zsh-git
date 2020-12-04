#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

function git::internal::reattach-to-user-namespace::install {
    if ! type -p brew > /dev/null; then
        message_warning "${GIT_MESSAGE_BREW}"
        return
    fi
    message_info "Installing reattach-to-user-namespace for ${GIT_PACKAGE_NAME}"
    brew install reattach-to-user-namespace
    message_success "Installed reattach-to-user-namespace ${GIT_PACKAGE_NAME}"
}

if ! type -p reattach-to-user-namespace > /dev/null; then git::internal::reattach-to-user-namespace::install; fi
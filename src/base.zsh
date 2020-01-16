#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

function hub::install {
    if ! type -p brew > /dev/null; then
        message_warning "please install brew to continue or add zshrc luismayta/zsh-brew"
        return
    fi
    message_info "Installing hub"
    brew install hub
    message_success "Installed hub"
}

if ! type -p hub > /dev/null; then
    hub::install
fi
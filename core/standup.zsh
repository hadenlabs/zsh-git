#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

#
# Bool validate if have installed git-standup
#
function standup::validate::is_installed {
    if type -p git-standup > /dev/null; then
        echo 1
        return
    fi
    echo 0
}

function standup::install {
    if [ "$(standup::validate::is_installed)" -eq 1 ]; then
        return
    fi
    if ! type -p yarn > /dev/null; then
        message_warning "please use antibody bundle luismayta/zsh-nvm branch:develop"
        return
    fi
    yarn global add git-standup
}

standup::install
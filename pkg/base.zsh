#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

#
# Bool validate if have installed git flow
#
function gitflow::is_installed {
    if type -p git-flow > /dev/null; then
        echo 1
        return
    fi
    echo 0
}

function git::dependences::check {
    if [ -z "${GITHUB_USER}" ]; then
        message_warning "You should set 'git config --global github.user'."
    fi
}

function gff {
    local action branch_name branch_eq_action action_to_skip action_excluded
    action_to_skip=(publish start)
    branch_name="$(git::internal::branch::task_name)"
    action="${1}"
    if [ -z "${action}" ]; then
        action="${branch_name}"
    fi
    action_excluded=$(printf "%s\\n" "${action_to_skip[@]}" | grep -c "^${action}")
    branch_eq_action=$(printf "%s" "${branch_name}" | grep -c "${action}")

    git::internal::gitflow::setup

    if [ -n "${action}" ] && [ "${action_excluded}" -eq 0 ] && [ "${branch_eq_action}" -eq 1 ]; then
        git::internal::gff::publish
    elif [ -n "${action}" ] && [ "${action_excluded}" -eq 0 ] && [ "${branch_eq_action}" -eq 0 ]; then
        git::internal::gff::sync
        git flow feature start "${action}"
    fi

    if [ -n "${action}" ] && [ "${action_excluded}" -eq 1 ]; then
        git flow feature "${action}"
    fi

}

function git::pkg::config::setup {

    if [ -n "${GIT_USER_NAME}" ]; then
        git config --global user.name "${GIT_USER_NAME}"
    fi

    if [ -n "${GIT_USER_EMAIL}" ]; then
        git config --global user.email "${GIT_USER_EMAIL}"
    fi

    if [ -n "${GITHUB_USER}" ]; then
        git config --global github.user "${GITHUB_USER}"
    fi

    if [ -n "${GITHUB_TOKEN}" ]; then
        git config --global \
            url."https://${GITHUB_TOKEN}:@github.com/".insteadOf "https://github.com/"
    fi

}

function git::sync {
    rsync -avhP  "${GIT_CONF_PATH}/" "${HOME}/"
}

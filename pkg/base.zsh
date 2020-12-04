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

    if [ -z "${BITBUCKET_USER}" ]; then
        message_warning "You should set 'git config --global bitbucket.user'."
    fi

    if [ -z "${GITLAB_USER}" ]; then
        message_warning "You should set 'git config --global gitlab.user'."
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

    gitflow::setup

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

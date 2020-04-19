#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

#
# Defines git alias and provides easy command line.
#
# Requirements:
#  - zsh: https://www.zsh.org/
#  - git: https://git-scm.com/
#
# Authors:
#   Luis Mayta <slovacus@gmail.com>
#

ZSH_GIT_ALIASES_ROOT_PATH=$(dirname "${0}")
export ZSH_GIT_ALIASES_SRC_PATH="${ZSH_GIT_ALIASES_ROOT_PATH}/src"
export ZSH_GIT_ALIASES_HOOKS_PATH="${ZSH_GIT_ALIASES_SRC_PATH}/git/hooks/"
export ZSH_GIT_REGEX_IS_HOOK="^(prepare-commit-msg)"
export ZSH_GIT_REGEX_DOMAIN_ENABLED="(github.com|bitbucket.org)"

GITHUB_USER="$(git config github.user)"
BITBUCKET_USER="$(git config bitbucket.user)"
GITLAB_USER="$(git config gitlab.user)"

# shellcheck source=/dev/null
source "${ZSH_GIT_ALIASES_SRC_PATH}"/base.zsh

# shellcheck source=/dev/null
source "${ZSH_GIT_ALIASES_SRC_PATH}"/git.zsh

# shellcheck source=/dev/null
source "${ZSH_GIT_ALIASES_SRC_PATH}"/gitflow.zsh

# shellcheck source=/dev/null
source "${ZSH_GIT_ALIASES_SRC_PATH}"/alias.zsh


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
    branch_name="$(git::branch::task_name)"
    action="${1}"
    if [ -z "${action}" ]; then
        action="${branch_name}"
    fi
    action_excluded=$(printf "%s\\n" "${action_to_skip[@]}" | grep -c "^${action}")
    branch_eq_action=$(printf "%s" "${branch_name}" | grep -c "${action}")

    gitflow::setup

    if [ -n "${action}" ] && [ "${action_excluded}" -eq 0 ] && [ "${branch_eq_action}" -eq 1 ]; then
        gff::publish
    elif [ -n "${action}" ] && [ "${action_excluded}" -eq 0 ] && [ "${branch_eq_action}" -eq 0 ]; then
        gff::git::sync
        git flow feature start "${action}"
    fi

    if [ -n "${action}" ] && [ "${action_excluded}" -eq 1 ]; then
        git flow feature "${action}"
    fi

}

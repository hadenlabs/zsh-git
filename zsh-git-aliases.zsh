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
ZSH_GIT_ALIASES_HOOKS_PATH="${ZSH_GIT_ALIASES_ROOT_PATH}/src/git/hooks/"
ZSH_GIT_REGEX_IS_HOOK="^(prepare-commit-msg)"
ZSH_GIT_REGEX_DOMAIN_ENABLED="(github.com|bitbucket.org)"

GITHUB_USER="$(git config github.user)"
BITBUCKET_USER="$(git config bitbucket.user)"
GITLAB_USER="$(git config gitlab.user)"

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

# exist_hook: validate when exist hook in path src/git/hooks
function git::exist_hook {
    local hook_name
    hook_name="${1}"
    echo "${hook_name}" | grep -cE "${ZSH_GIT_REGEX_IS_HOOK}"; echo
}

# has_hook: validate if have installed hook
function git::has_hook {
    local hook_name
    hook_name="${1}"
    if [ -e .git/hooks/"${hook_name}" ]; then
        echo -e 1
    fi
}

# copy_hook: copy a hook to project git
function git::copy_hook {
    local hook_name
    local has_hook
    hook_name="${1}"
    has_hook=$(git::exist_hook "${hook_name}")
    if [ "${has_hook}" -eq 1 ]; then
        [ -e .git/hooks ] && cp -rf "${ZSH_GIT_ALIASES_HOOKS_PATH}/${hook_name}" .git/hooks/
        message_success "copy hook ${hook_name}"
    else
        message_warning "not found hook ${hook_name}"
    fi
}

function git::hook::factory {
    local hook_name
    hook_name=prepare-commit-msg
    if [ "$(git::has_hook ${hook_name})" -eq 0 ]; then
        git::copy_hook "${hook_name}"
    fi
}

alias gl='git pull'
alias gp='git push'
alias gau='git add --update'
alias gc='git commit -v'
alias gca='git commit -v -a'
alias gb='git branch'
alias gba='git branch -a'
alias gco='git checkout'
alias gcob='git checkout -b'
alias gcot='git checkout -t'
alias gcotb='git checkout --track -b'
alias glog='git log'
alias glogp='git log --pretty=format:"%h %s" --graph'

# Git Flow

alias gf='git flow'
alias gfr='git flow release'
alias gfh='git flow hotfix'

function git::branch::name {
    local branch_name
    branch_name="$(git symbolic-ref --short HEAD)"
    echo "${branch_name}"
}

function git::branch::task_name {
    local branch_name
    branch_name="$(git::branch::name)"
    branch_name="${branch_name##*/}"
    echo "${branch_name}"
}

# git::repository::remote::url -> string
# input remote_name
## return url of repository remote
function git::repository::remote::url {
    local remote_name
    remote_name="${1}"
    git remote get-url "${remote_name}" 2>/dev/null || echo; echo
}

# git::repository::fork::private
#  return true when origign is different to upstream
function git::repository::fork::private {
    local domain_origin
    local domain_upstream
    domain_origin=$(echo "$(git::repository::remote::url origin)" | grep -Eo "${ZSH_GIT_REGEX_DOMAIN_ENABLED}")
    domain_upstream=$(echo "$(git::repository::remote::url upstream)" | grep -Eo "${ZSH_GIT_REGEX_DOMAIN_ENABLED}")
    if [ -z "${domain_upstream}" ]; then
        echo 0
        return
    fi

    if [ "${domain_origin}" != "${domain_upstream}" ]; then
        echo 1
        return
    fi
    echo 0
}

function gff::publish {
    local branch_name
    branch_name="$(git::branch::name)"
    if [ "$(git::repository::fork::private)" -eq 1 ]; then
        git push upstream "${branch_name}"
    else
        git push origin "${branch_name}"
    fi
}

function gff {
    local action
    local branch_name
    local branch_eq_action
    local action_to_skip=(publish start)
    local action_excluded
    branch_name="$(git::branch::task_name)"
    action="${1}"
    action_excluded=$(printf "%s\\n" "${action_to_skip[@]}" | grep -c "^${action}")
    branch_eq_action=$(printf "%s" "${branch_name}" | grep -c "${action}")

    git::hook::factory

    if [ -n "${action}" ] && [ "${action_excluded}" -eq 0 ] && [ "${branch_eq_action}" -eq 1 ]; then
        gff::publish
    elif [ -n "${action}" ] && [ "${action_excluded}" -eq 0 ] && [ "${branch_eq_action}" -eq 0 ]; then
        if [ "$(git::branch::name)" != "develop" ]; then
            message_info "starting sync branchs"
            git checkout develop
            git-sync
            message_success "finish sync branchs"
        fi
        git flow feature start "${action}"
    fi

    if [ -n "${action}" ] && [ "${action_excluded}" -eq 1 ]; then
        git flow feature "${action}"
    fi

}

function git::dependences::install {
    if ! type -p brew > /dev/null; then
        message_warning "please install brew to continue or add zshrc luismayta/zsh-brew"
    else
        if ! type -p hub > /dev/null; then
            message_info "Installing hub"
            brew install hub
            message_success "Installed hub"
        fi
    fi
}

git::dependences::install

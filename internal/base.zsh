#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

function git::internal::hub::install {
    if ! type -p brew > /dev/null; then
        message_warning "${GIT_MESSAGE_BREW}"
        return
    fi
    message_info "Installing hub"
    brew install hub
    message_success "Installed hub"
}

function git::internal::git::install {
    message_info "Installing ${GIT_PACKAGE_NAME}"
    if ! type -p brew > /dev/null; then
        message_warning "${GIT_MESSAGE_BREW}"
        return
    fi
    brew install git
    message_success "Installed ${GIT_PACKAGE_NAME}"
}

function git::internal::standup::install {
    if ! type -p yarn > /dev/null; then
        message_warning "please use antibody bundle luismayta/zsh-nvm branch:develop"
        return
    fi
    yarn global add git-standup
}

function git::internal::gitflow::install {
    if ! type -p brew > /dev/null; then
        message_warning "${GIT_MESSAGE_BREW}"
        return
    fi
    brew install git-flow
}

#
# Bool validate if exist branch develop
#
function git::internal::gitflow::validate::exist::develop {
    local response
    response="$(git config --local gitflow.branch.develop | cut -d ' ' -f 2)"
	  [ -n "${response}" ] && echo 1; return
    echo 0
}

#
# Bool validate if exist branch master
#
function git::internal::gitflow::validate::exist::master {
    local response
    response="$(git config --local gitflow.branch.master | cut -d ' ' -f 2)"
	  [ -n "${response}" ] && echo 1; return
    echo 0
}

# Function used to check if the repository is git-flow enabled.
function git::internal::gitflow::has_master::configured {
	  git::internal::gitflow::validate::exist::master
}

function git::internal::gitflow::has_develop::configured {
	  git::internal::gitflow::validate::exist::develop
}

function git::internal::gitflow::setup {
    if [ "$(git::internal::gitflow::has_develop::configured)" -eq 0 ] || [ "$(git::internal::gitflow::has_master::configured)" -eq 0 ]; then
        git flow init -d
    fi
    git::internal::hook::factory
}

# exist_hook: validate when exist hook in path src/git/hooks
function git::internal::exist_hook {
    local hook_name
    hook_name="${1}"
    echo "${hook_name}" | grep -cE "${ZSH_GIT_REGEX_IS_HOOK}"; echo
}

# has_hook: validate if have installed hook
function git::internal::has_hook {
    local hook_name
    hook_name="${1}"
    if [ -e .git/hooks/"${hook_name}" ]; then
        echo 1
        return
    fi
}

# copy_hook: copy a hook to project git
function git::internal::copy_hook {
    local hook_name
    local has_hook
    hook_name="${1}"
    has_hook=$(git::internal::exist_hook "${hook_name}")
    if [ "${has_hook}" -eq 1 ]; then
        [ -e .git/hooks ] && cp -rf "${ZSH_GIT_HOOKS_PATH}/${hook_name}" .git/hooks/
        message_success "copy hook ${hook_name}"
        return
    fi
    message_warning "not found hook ${hook_name}"
}

function git::internal::hook::factory {
    local hook_name
    hook_name=prepare-commit-msg
    if [ "$(git::internal::has_hook ${hook_name})" -eq 0 ]; then
        git::internal::copy_hook "${hook_name}"
    fi
}

function git::internal::branch::name {
    git symbolic-ref --short HEAD
}

function git::internal::branch::task_name {
    local branch_name
    branch_name="$(git::internal::branch::name)"
    branch_name="${branch_name##*/}"
    echo "${branch_name}"
}

function git::internal::branch::is_develop {
    if [ "$(git::internal::branch::name)" = "develop" ]; then
        echo 1
        return
    fi
    echo 0
}

# git::repository::remote::url -> string
# input remote_name
## return url of repository remote
function git::internal::repository::remote::url {
    local remote_name
    remote_name="${1}"
    git remote get-url "${remote_name}" 2>/dev/null || echo; echo
}

# git::internal::repository::fork::private
#  return true when origign is different to upstream
function git::internal::repository::fork::private {
    local domain_origin domain_upstream
    domain_origin=$(echo "$(git::internal::repository::remote::url origin)" | grep -Eo "${ZSH_GIT_REGEX_DOMAIN_ENABLED}")
    domain_upstream=$(echo "$(git::internal::repository::remote::url upstream)" | grep -Eo "${ZSH_GIT_REGEX_DOMAIN_ENABLED}")
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

function git::internal::gff::publish {
    local branch_name
    branch_name="$(git::internal::branch::name)"
    if [ "$(git::internal::repository::fork::private)" -eq 1 ]; then
        git push upstream "${branch_name}"
        return
    fi
    git push origin "${branch_name}"
}

function git::internal::gff::sync {
    if [ -z "$(git::internal::repository::remote::url origin)" ]; then
        return
    fi
    message_info "starting sync branchs"
    if [ "$(git::internal::branch::is_develop)" -eq 0 ]; then
        git checkout develop
    fi
    git-sync
    message_success "finish sync branchs"
}

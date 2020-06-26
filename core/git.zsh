#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

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
        echo 1
        return
    fi
}

# copy_hook: copy a hook to project git
function git::copy_hook {
    local hook_name
    local has_hook
    hook_name="${1}"
    has_hook=$(git::exist_hook "${hook_name}")
    if [ "${has_hook}" -eq 1 ]; then
        [ -e .git/hooks ] && cp -rf "${ZSH_GIT_HOOKS_PATH}/${hook_name}" .git/hooks/
        message_success "copy hook ${hook_name}"
        return
    fi
    message_warning "not found hook ${hook_name}"
}

function git::hook::factory {
    local hook_name
    hook_name=prepare-commit-msg
    if [ "$(git::has_hook ${hook_name})" -eq 0 ]; then
        git::copy_hook "${hook_name}"
    fi
}

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

function git::branch::is_develop {
    if [ "$(git::branch::name)" = "develop" ]; then
        echo 1
        return
    fi
    echo 0
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
    local domain_origin domain_upstream
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
        return
    fi
    git push origin "${branch_name}"
}

function gff::git::sync {
    if [ -z "$(git::repository::remote::url origin)" ]; then
        return
    fi
    message_info "starting sync branchs"
    if [ "$(git::branch::is_develop)" -eq 0 ]; then
        git checkout develop
    fi
    git-sync
    message_success "finish sync branchs"
}

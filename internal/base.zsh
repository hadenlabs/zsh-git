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

function git::internal::provision::hooks::sync {
    if [ ! -e "${GIT_PROVISION_HOOKS_PATH}" ]; then
        return
    fi
    rsync -avP "${ZSH_GIT_HOOKS_PATH}/" "${GIT_PROVISION_HOOKS_PATH}/"
}

# Similar to `gunwip` but recursive "Unwips" all recent `--wip--` commits not just the last one
function git::internal::gunwipall {
  local _commit
  _commit="$(git log --grep='--wip--' --invert-grep --max-count=1 --format=format:%H)"

  # Check if a commit without "--wip--" was found and it's not the same as HEAD
  if [[ "${_commit}" != "$(git rev-parse HEAD)" ]]; then
    git reset "${_commit}" || return 1
  fi
}
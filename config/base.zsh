#!/usr/bin/env ksh
# -*- coding: utf-8 -*-
export GIT_FILE_SETTINGS="${HOME}"/.gitconfig
export GIT_CONF_PATH="${ZSH_GIT_PATH}/conf"
export GIT_MESSAGE_BREW="Please install brew or use antibody bundle luismayta/zsh-brew branch:develop"
export GIT_MESSAGE_RVM="Please install rvm or use antibody bundle luismayta/zsh-rvm branch:develop"
export GIT_PROVISION_HOOKS_PATH="provision/git/hooks/"
export GIT_PACKAGE_NAME=git

export ZSH_GIT_HOOKS_PATH="${ZSH_GIT_PATH}/template/git/hooks/"
export ZSH_GIT_REGEX_IS_HOOK="^(prepare-commit-msg)"
export ZSH_GIT_REGEX_DOMAIN_ENABLED="(github.com|bitbucket.org)"

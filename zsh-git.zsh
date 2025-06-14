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
#   Luis Mayta <luis@hadenlabs.com>
#

ZSH_GIT_PATH=$(dirname "${0}")

export PATH="${ZSH_GIT_PATH}/bin:${PATH}"

# shellcheck source=/dev/null
source "${ZSH_GIT_PATH}"/config/main.zsh

# shellcheck source=/dev/null
source "${ZSH_GIT_PATH}"/internal/main.zsh

# shellcheck source=/dev/null
source "${ZSH_GIT_PATH}"/pkg/main.zsh
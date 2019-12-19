#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

#
# Defines peco git alias and provides easy command line.
#
# Requirements:
#  - peco: https://github.com/peco/peco
#  - zsh: https://www.zsh.org/
#  - git: https://git-scm.com/
#
# Authors:
#   Luis Mayta <slovacus@gmail.com>
#

alias gst='git status'
alias gl='git pull'
alias gp='git push'
alias gd='git diff | mate'
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
alias gff='git flow feature'
alias gfr='git flow release'
alias gfh='git flow hotfix'

if type -p peco > /dev/null; then
    function git-branches {
        git branch --list --no-color | colrm 1 2
    }
    function peco-git-checkout {
        fc -l -n 1 | git-branches | \
            peco --layout=bottom-up --query "$LBUFFER"| xargs git checkout

        CURSOR=$#BUFFER # move cursor
        zle -R -c       # refresh
    }
    zle -N peco-git-checkout
    bindkey "^bco" peco-git-checkout
    alias gb=peco-git-checkout
fi

#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

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

alias gwip='git add -A; git rm $(git ls-files --deleted) 2> /dev/null; git commit --no-verify --no-gpg-sign --message "--wip-- [skip ci]"; git push origin $(git rev-parse --abbrev-ref HEAD)'

alias gunwip='git rev-list --max-count=1 --format="%s" HEAD | grep -q "\--wip--" && git reset HEAD~1'

function gunwipall {
  git::internal::gunwipall
}

# Git Flow

alias gf='git flow'
alias gfr='git flow release'
alias gfh='git flow hotfix'
#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

#
# Bool validate if have installed git flow
#
function gitflow::validate::is_installed {
    if type -p git-flow > /dev/null; then
        echo 1
        return
    fi
    echo 0
}

#
# Bool validate if exist branch develop
#
function gitflow::validate::exist::develop {
    local response
    response=git config --local gitflow.branch.develop | cut -d ' ' -f 2
	  [ -n "${response}" ] && echo 1; return
    echo 0
}

#
# Bool validate if exist branch master
#
function gitflow::validate::exist::master {
    local response
    response=git config --local gitflow.branch.master | cut -d ' ' -f 2
	  [ -n "${response}" ] && echo 1; return
    echo 0
}

# Function used to check if the repository is git-flow enabled.
function gitflow::has_master::configured {
	  gitflow::validate::exist::master
}

function gitflow::has_develop::configured {
	  gitflow::validate::exist::develop
}

function gitflow::setup {
    if [ "$(gitflow::has_develop::configured)" -eq 0 ] || [ "$(gitflow::has_master::configured)" -eq 0 ]; then
        git flow init -d
    fi
    git::hook::factory
}
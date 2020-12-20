#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

function git::internal::git::user {
    git config user.name
}

function git::internal::git::email {
    git config user.email
}

#!/bin/bash

function syn()
(
    cd "$1"
    date

    if test ! -z "$(git status -s)"
    then
        echo add changes
        git add . && git commit -m 'sync'
    fi

    git pull && git push
)

syn "$1" > "$(dirname "$0")/log.txt"

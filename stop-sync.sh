#!/bin/sh

cd `dirname "$0"`

if test -f pgid
then
    pgid=-`cat pgid`
    if  ps $pgid | grep start-sync
    then
        echo "kill $pgid"
        kill -TERM $pgid
    else
        echo "skip killing"
    fi
    rm pgid
else
    echo pgid file missing, skip
fi

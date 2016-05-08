#!/bin/sh

cd `dirname "$0"`

if test -f pgid
then
    pgid=`cat pgid`
    echo "kill $pgid"
    kill -TERM -`echo $(cat pgid)`
    rm pgid
else
    echo pgid file missing, skip
fi

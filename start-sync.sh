#!/bin/sh

daemon()
{
    cd `dirname "$0"`

    date > log.txt

    while [ true ]
    do
        ./sync.rb >> log.txt 2>&1
        sleep 16
        echo 'sync.rb stopped, restart' >> log.txt
        date >> log.txt
    done
}

echo 'Try to kill old instnace...'
./stop-sync.sh
daemon &
ps -o pgid= $! > pgid

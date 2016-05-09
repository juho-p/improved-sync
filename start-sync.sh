#!/bin/sh

# make sure we run in new pgid
pid="$$"
pgid=$(echo `ps -o pgid= "$pid" 2>/dev/null`)
if [ "$pid" != "$pgid" ]; then
    exec setsid $0
fi

daemon()
{
    date > log.txt

    while [ true ]
    do
        ./sync.rb >> log.txt 2>&1
        sleep 16
        echo 'sync.rb stopped, restart' >> log.txt
        date >> log.txt
    done
}

cd `dirname "$0"`

echo 'Try to kill old instance...'
./stop-sync.sh
daemon &
echo 'Started'
echo $pgid > pgid

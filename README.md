Improved Sync Deluxe
--------------------

A git based file synchronization tool (deluxe edition).

Who is this for?
----------------

If you want something to synchronize your files and having your files in git
repository is something you want, then this is for you. Also, you probably need
to know how to use git to use this program (whenever something goes wrong,
merge conflict or whatever).

Requirements
------------

* basic knowledge of computers

Usage
-----

* create bare git repository on your remote machine
* clone this repo
* use init.rb to initialize repo locally (or just use your git skills)
* use cron to time your stuff

Now your local files are synchronized with remote repository. You can add other
systems to use the same remote and the files are kept in sync.

For example:

    foo$ ssh remote-server
    blah ~$ mkdir sync.git && git init --bare
    blah sync.git$ exit
    foo$ git clone https://github.com/juho-p/improved-sync.git
    foo$ cd improved-sync
    foo$ ./init.rb ~/sync remote-server sync.git
    foo$ crontab -e

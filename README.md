Improved Sync
-------------

A git based file synchronization tool (like dropbox, but *improved*).

Who is this for?
----------------

If you want something to synchronize your files and having your files in git
repository is something you want, then this is for you. Also, you probably need
to know how to use git to use this program (whenever something goes wrong,
merge conflict or whatever).

Requirements
------------

* server that you can connect with ssh and that has git installed
* ssh-configuration that allows you to just ssh to server without any (password) prompt
* locally, git and inotify-tools (or whatever package that has inotifywait) installed
* some *recent* version of ruby

Usage
-----

* create bare git repository on your remote machine
* clone this repo
* use init.rb to initialize repo locally (or just use your git skills)
* use start-sync.sh to start sync (or just run sync.rb)

Now your local files are synchronized with remote repository. You can add other
systems to use the same remote and the files are kept in sync.

For example:

    foo$ ssh remote-server
    blah ~$ mkdir sync.git && git init --bare
    blah sync.git$ exit
    foo$ git clone https://github.com/juho-p/improved-sync.git
    foo$ cd improved-sync
    foo$ ./init.rb ~/sync remote-server sync.git
    foo$ ./start-sync.sh

Want to stop syncing? Just run `stop-sync.sh`. Otherwise it's probably a good
idea to configure `start-sync.sh` to start whenever you login.

If something doesn't work, go to your local repo and see what's wrong using
`git` command. At least `git pull && git push` should work without errors, or
you have no hope to run this program. Or you can use any git GUI program out
there if you don't know how to CLI.

How it works
------------

You have bare git repository at remote machine and git repository at local
machine. This program listens both ends and whenever change happens, after some
delay it uses `git` command line tools to synchronize the files. 

If something goes wrong, you
have to fix everything yourself. If you don't know how to use git.

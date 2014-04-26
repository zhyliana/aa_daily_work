# Pow

Pow makes it easy to run multiple Rails apps at the same time. Instead
of having to shutdown a server, and start another app's server up,
you'll be able to have multiple app servers running and hit them at
http://myapp.dev/. No more localhost:3000!

Run `curl get.pow.cx | sh` at the command-line to download and install
Pow. See our [`curl`](#) page if you don't remember how to use it.

To set up a Rails app, go to the Pow directory (`cd ~/.pow`) and
symlink (`ln -s /path/to/myapp`) your app into the directory. See our
[`symlink`](#) page if you don't remember what a symlink is.

Now your app will be up and running at `http://myapp.dev/`!

Rinse and repeat for any other apps you want to set up.

To restart an application, you `touch` a file name 'restart.txt' in
the 'tmp' directory of your app (i.e., `touch tmp/restart.txt`). The
UNIX command `touch` updates a file's timestamps. It is often used (as
in this case) to make the lightest modification to a file so as to
notify an application or the file system of an update without making a
substantive change.

## Exercises

* Set up Pow for at least 2 Rails apps that you have.
* Make a change to the 'routes.rb' file, then restart the application.

## Resources

[Pow](http://pow.cx/)
[Pow user guide](http://pow.cx/manual.html)
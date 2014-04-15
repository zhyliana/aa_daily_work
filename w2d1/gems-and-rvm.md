# RubyGems

Sometimes, developers writing code notice that they've written
something that might be useful to others. If they are nice people,
they package that code up into a **gem** (also often called a
**library** outside Ruby contexts) and share it with the world. This
can be anything from a few short methods to a web framework as large
as Rails.

Let's see how to find, install and use a gem.

## Finding gems

The single best place to find gems to use is GitHub. I often just
simply Google around for what I want to do, read StackOverflow for
suggestions, and then look at the gem's GitHub repo to see if it's
what I want.

On GitHub you can see how many people have followed the repository,
and how recently it has been updated. Gems that have >1k follows are
mainstream and can be relied upon to be pretty much rock-solid and
typically very well documented. Gems with more than 500 follows are
fairly popular, but it may be harder to find answers to problems by
searching around. Gems with less than 500 follows are not super
popular, and might not be be quite as well maintained. Generally I
won't use a gem with <100 follows; I like to let others solve bugs for
me :-)

## Installing gems

Let's check out [Awesome Print][awesome-print], a library that "pretty
prints" Ruby output (NB: pry already prettifies output, so
awesome_print won't seem as awesome as if we were using plain irb).

[awesome-print]: https://github.com/michaeldv/awesome_print

The Awesome Print GitHub shows us how to install the gem: `gem install
awesome_print`. That's it!

## `sudo gem install` and RVM

> **This section is OS X and Linux specific**. Windows users cannot
> install rvm: it's only for *nix systems. However,
> Windows users who have installed Ruby through RubyInstaller can
> already install gems without using `sudo` and are already
> using an up-to-date Ruby.

If you aren't using RVM, you will run into an error like this:

```
~$ gem install awesome_print
Fetching: awesome_print-1.1.0.gem (100%)
ERROR:  While executing gem ... (Gem::FilePermissionError)
    You don't have write permissions into the /Library/Ruby/Gems/1.8 directory.
```

This is because the built-in Ruby that comes with OS X installs gems
in a system directory where you need superuser permissions to create
files. You'll read in some places that you should use `sudo gem
install awesome_print`; **don't do that**.

Instead, setup RVM (it's described for w1d1). You should no longer get
this error. You should not use `sudo gem install` when using RVM.

## Using gems

We should now be able to require source files provided by the gem:

```ruby
[1] pry(main)> require 'awesome_print'
=> true
[2] pry(main)> ap({:this => "is totally awesome!"})
{
    :this => "is totally awesome!"
}
=> nil
```

You'll need to read up on how to use your newly installed gem. The
github often has examples that show you the most common methods and
how they are used. Well documented libraries like RSpec have whole
websites of [documentation][rspec-docs]. Documentation is normally
linked to on the GitHub page; else I do a quick Google search.

Documentation can often be spotty and incomplete. In that case, you
may have to explore the code itself on GitHub to try to figure out how
things work.

[rspec-docs]: https://www.relishapp.com/rspec

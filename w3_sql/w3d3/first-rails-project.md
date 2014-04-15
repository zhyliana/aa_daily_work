# Your first rails project

This unit begins our foray into ActiveRecord; a component of Rails
that is a way for your Ruby code to interact with a SQL
database. ActiveRecord is maybe the most important part of Rails;
after you master it, you will find the rest of Rails probably pretty
straightforward.

First, make sure that rails is installed:

    gem install rails --version 4.0.4

Next, generate a new Rails *project*:

    rails new DemoProject

This will create a folder `DemoProject`, with a bunch of Rails
directories in them.

Open up the `Gemfile` file (located in your new `DemoProject` folder)
and add the line:

    gem 'pry-rails'

This will allow us to interact with our Rails project using the pry
console. Next, make sure you are in the DemoProject directory and run:

    bundle install

This will look for the Gemfile and then install the *dependencies*
listed in it.

## Postgres

The rails default is to use sqlite3. You may wish to use postgres
instead. This is convenient because differences between your
development and production databases can be frustrating.

It is easy to swap one for the other. First, replace the `gem
'sqlite3'` line in the `Gemfile` with `gem 'pg'`.

Next, edit `config/database.yml`. Change the `development`
environment:

```yaml
development:
  adapter: postgresql
  database: name_of_your_project_development
  host: localhost
  username: appacademy
```

You will have to create a database with the given name. You could do
this by running `psql` yourself and typing `CREATE DATABASE
name_of_your_project_development`. Alternatively and more simply, you
can run `rake db:create`.

If you're starting a new rails app and would like to use postgres, you
can specify the database flag when generating the app. This will add
the correct gem and have sensible defaults in `config/database.yml`.

    rails _4.0.4_ new DemoProject --database postgresql

Note: If you are using [Postgres.app][postgresapp], your default postgres
username is your Mac's user account. Run `echo $USER` on the command line to
find this. On App Academy workstations the username will be `appacademy`. You
will need to set this in your `config/database.yml`.

[postgresapp]: http://postgresapp.com/


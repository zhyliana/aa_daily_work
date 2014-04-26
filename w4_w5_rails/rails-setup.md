# Rails Setup

There are several things you **must** do when beginning every Rails
app for the near future.

## Use the correct version of Rails

In this course we will be using the Rails 4.0.2 release and
PostgreSQL as a database.

Start your project with the following command to ensure the right
setup:

```
rails _4.0.2_ new MyProjectName --database postgresql
```

When using postgresql, you must also change the configs in `config/database.yml`
by adding `username: appacademy` and `host: localhost`.

[See this earlier reading for an example][setting-up-postgresql].

When using postgresql, you should also run the command `rake db:create:all` in the 
terminal before trying to run migrations.  This actually creates the databases for 
your application.

[setting-up-postgresql]: https://github.com/appacademy/sql-curriculum/blob/master/w3d3/first-rails-project.md#postgres

## Stop the loading of unused assets

In `app/views/layouts/application.html.erb`, remove the lines
indicated below.

```
<%= stylesheet_link_tag    "application", :media => "all" %>
<%= javascript_include_tag "application" %>
```

Removing these will prevent Rails from loading its default CSS & JS
files, so your Rails server's output will be greatly cleaned
up. Additionally, this will prevent you from relying on Rails' JS
magic, including using impossible HTTP verbs in link tags. We will
tell you to put these back when we hit the JS & CSS portion of our
course.

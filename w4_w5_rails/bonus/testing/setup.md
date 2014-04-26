# Setting up Rails, RSpec and Guard

## Install RSpec

Using `rspec-rails` in your project is easy. First, delete the
original `test/` directory: `rm -r test/` (this contains directories
for `Test::Unit` specs; only DHH loves `Test::Unit`).

Next add `gem 'rspec-rails'` to your `Gemfile` as a *development
dependency*:

```ruby
group :development do
  gem 'rspec-rails'
end
```

This will pull in `rspec-rails` when you're working locally, but will
not include it when you deploy to, say, Heroku. Next, as usual, run
`bundle install`. Finally, run the RSpec 'railtie' (installer): `rails
g rspec:install`. Done!

## Setting up the test database

Tests run with their own instance of a test database. To prepare the
database, first run `rake db:migrate` to bring the development db
up-to-date. Then run `rake db:test:prepare` to read the `db/schema.rb`
and construct the test db.

You should know that if your test db ever talks back, you can delete
it with `rm db/test.sqlite3`.

## Setting up Guard

Tests are only valuable if you notice when you break them. One handy
gem is `guard-rspec`, which will watch for your source and test files
to change and automatically rerun the tests. To install, add the
dependency to your Gemfile:

```ruby
group :development do
  # also, on Mac, add rb-fsevent (rb-inotifyon Linux); this will make
  # guard run faster.
  gem 'rb-fsevent'
  gem 'guard-rspec'
  gem 'rspec-rails'
end
```

Then of course `bundle install`. Next run `guard init rspec` to
generate a `Guardfile`, which contains a description of the
directories and files to watch for rerunning tests. You won't need to
edit this, but you should check it into source control.

Finally, start up the guard server (`bundle exec guard`); this will
now run your tests automatically.

## Resources

* https://github.com/rspec/rspec-rails
* https://github.com/guard/guard-rspec

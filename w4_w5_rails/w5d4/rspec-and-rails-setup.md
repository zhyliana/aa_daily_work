# Setting Up RSpec with Ruby on Rails

## Overview
RSpec is a tool for testing Ruby applications, and is often used to test Rails apps.  
Set-up will include the following steps:
 * Add RSpec and other useful gems to your Gemfile, and install with Bundler
 * Set up a test database, if necessary
 * Configure RSpec
 * Configure the Rails Application to generate test files automatically as features are added
 
These instructions assume Rails 4 and Ruby 1.9.
 
## Adding RSpec Gems

Add the following to the Gemfile of your Ruby on Rails application:

```ruby
# my_app/Gemfile

group :development, :test do
  gem 'rspec-rails'
end

group :test do
  gem 'guard-rspec'
end
```

Next run bundle from the command line to install the gems:
``
$ bundle install
``

You now have the necessary gems.

## The Test Database

Open up `config/database.yml`.  By default it should look like this:

```ruby
#my_app/config/database.yml

# SQLite version 3.x
#   gem install sqlite3
#
#   Ensure the SQLite 3 gem is defined in your Gemfile
#   gem 'sqlite3'
development:
  adapter: sqlite3
  database: db/development.sqlite3
  pool: 5
  timeout: 5000

# Warning: The database defined as "test" will be erased and
# re-generated from your development database when you run "rake".
# Do not set this db to the same as development or production.
test:
  adapter: sqlite3
  database: db/test.sqlite3
  pool: 5
  timeout: 5000

production:
  adapter: sqlite3
  database: db/production.sqlite3
  pool: 5
  timeout: 5000
```

(This will be slightly different if you have [switched to Postgres.](https://github.com/appacademy/sql-curriculum/blob/master/w3d3/first-rails-project.md#postgres))

Notice there are three sets of configuration data: one for `development`, one for `test`, and one for `production`.  
When you are running a server on localhost, Rails is using the `development` database.  
For running tests, it will use a separate `test` database.
The default configuration will work just fine for testing with RSpec.

If you are using postgresql, you must run `rake db:create:all` on the command line to create your databases.

**Important:** Each time you migrate your database or change it, you must also update the test database by calling
`rake db:test:prepare`.

## Configure RSpec

Next, install RSpec by entering the following on the command line:

```
$ rails g rspec:install
```
A successful install will output the following message:
```
$    create  .rspec
$    create  spec
$    create  spec/spec_helper.rb`
```

We want to tweak the default RSpec configuration so that it will format its output in a readable way.  
To do this, add the following line to the `.rspec` configuration file:
```
--format documentation
```
If you are interested in customizing RSpec further, check out [the documentation here](http://rubydoc.info/github/rspec/rspec-core/RSpec/Core/Configuration).

## Auto-Generate Test Files
Lastly, we will configure Rails to auto-generate starter files to test with RSpec, 
rather than the using the default TestUnit included in Rails.

Open `config/application.rb` and add the following code inside the Application class:

```ruby
# my_app/config/application.rb

config.generators do |g|
  g.test_framework :rspec, 
    :fixtures => true, 
    :view_specs => false, 
    :helper_specs => false, 
    :routing_specs => false, 
    :controller_specs => true, 
    :request_specs => true
end
```
You can probably guess what these settings do:
 * `g.test_framework :rspec` tells Rails to use RSpec for testing.
 * `:fixtures => true` means Rails should generate fixtures for each model.
 * `view_specs => false` and the similar settings for `helper_specs` and `routing_specs` means that we won't auto-generate spec files for views, helper-files, or the router.  To start with, we will focus on testing the models, controllers, and your API.  As you become more comfortable testing, you may want to change these settings and use tests for these components too.
 * `request_specs => true` means that we *do* want to generate request specs.

Now you are done!  You can save spec files in the `spec` directory, using the naming convention `classname_spec.rb`.
 
## Resources
 * [How I Test my Rails Apps: Setting up RSpec](http://everydayrails.com/2012/03/12/testing-series-rspec-setup.html)
 * [RSpec homepage](http://rspec.info/)
 * [RailsGuides: Testing](http://guides.rubyonrails.org/testing.html)
 * [RailsGuides: Configuring Generators](http://guides.rubyonrails.org/configuring.html#configuring-generators)
 * [How to get Rails 3 and RSpec 2 Up and Running](http://www.rubyinside.com/how-to-rails-3-and-rspec-2-4336.html)

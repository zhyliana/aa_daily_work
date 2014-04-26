# Integration Testing with Capybara

## Overview

We use Capybara to simulate the way that a user would interact with  our
app: clicking buttons, visiting links, submitting forms, etc. Capybara
is an example of Behavior-Driven Development (BDD) because  it tests
based on a user's *behavior*, not the internal  structure of the
app.

Capybara is also a great way to conduct **integration testing**:
making sure that the app works as a whole and that all the pieces
connect in the right way.  This is the opposite of a **unit test**,
which tests one piece of the app in isolation.  Capybara lets you
conduct several browser actions in sequence, letting you test the same
part of your app in different ways. 

For example, you could write a test that expects to see a welcome screen
on the index page if a user isn't signed in.  You could write another
test that 1) signs in a user and 2) expects to see their username on the
index page.  You could write another test that 1) creates a user, 2)
logs out that user, and 3) expects to be redirected to the index page,
which tells them they have been logged out...you get the picture.

In the real world, unless you're working on a huge app, integration
tests tend to be more prevalent than unit tests.

## Setting up Capybara

Add Capybara to the 'test' group in your Gemfile and `bundle install`.

```ruby
# Gemfile

group :test do
  gem 'rspec-rails', '~> 2.0'
  gem 'capybara'
end
```

In your `spec_helper.rb` file, put:

```ruby
# spec/spec_helper.rb

#...
require 'capybara/rspec'
```

Whenever you want to write new capybara tests, they'll go in the
`spec/features` folder.  This is important: the specs must be 
in this directory for the `capybara` methods to work.

At the top of each file, you'll
require the spec_helper:

```ruby
# spec/features/authentication_spec.rb

require 'spec_helper'

...
```

To run the tests individually, run `rspec
spec/features/{file_name}_spec.rb`

## Example

Here's a snippet of how you might test signing up a user:

```ruby
# spec/features/authentication_spec.rb

require 'spec_helper'

feature "the signup process" do 

  scenario "has a new user page" do 
    visit new_user_url
    expect(page).to have_content "New user"
  end

  feature "signing up a user" do
    before(:each) do
      visit new_user_url
      fill_in 'username', :with => "testing_username"
      fill_in 'password', :with => "biscuits"
      click_on "Create User"
    end

    scenario "redirects to team index page after signup" do
      expect(page).to have_content "Team Index Page"
    end

    scenario "shows username on the homepage after signup" do
      expect(page).to have_content "testing_username"
    end
  end

end
```

Notice we use [`feature` rather than `describe`][feature-not-describe].  This is a special syntax just 
for feature specs.

## Important Methods

*  Visiting a page
	*  `visit('/projects')`
	*	 `visit(post_comments_path(post))`
*  Clicking
	*  `click_link('id-of-link')`
	*  `click_link('Link Text')`
	*  `click_button('Save')`
	*  `click_on('Link Text') # clicks on either links or buttons`
	*  `click_on('Button Value')`
*  Forms
	*  `fill_in('id-of-input', :with => 'whatever you want')`
    *  `fill_in('Password', :with => 'Seekrit')`
    *  `fill_in('Description', :with => 'Really Long Text...')`
	*  `choose('A Radio Button')`
	*  `check('A Checkbox')`
	*  `uncheck('A Checkbox')`
	*  `attach_file('Image', '/path/to/image.jpg')`
	*  `select('Option', :from => 'Select Box')`
*  Content (`page`)
	* `expect(page).to have_content('Blah blah blah')`


**Read the [docs][capybara-docs] for more**.

## Miscellaneous notes

1. By default, RSpec runs each test in a transaction and rolls it back after the
   test is done.  This behavior is the same when using capybara without 
   the setting ':js => true'.  Setting ':js => true' for a test switches to 
   the 'selenium' webdriver, and does not use transactions.
   In those cases, to make sure you have a clean database for each 
   of your tests you can use the [database-cleaner][db-cleaner] gem.
	
2. You can see what you pages look like in the middle of your capybara
   tests by using the [Launchy] gem.  Just add it to your test group in
   your Gemfile, bundle, and call `save_and_open_page` whenever you want
   to check what a page looks like.  Launchy will open it in a new
   browser window for you.

	E.g. 
	
```ruby
	it "has an index page" do
		visit posts_url
		save_and_open_page
		expect(page).to have_content("Index")
	end
```

## Additional Links

*  [`capybara` docs][capybara-docs]
*  Railscast on Capybara: [http://railscasts.com/episodes/257-request-specs-and-capybara](http://railscasts.com/episodes/257-request-specs-and-capybara)



[capybara-docs]: http://rdoc.info/github/jnicklas/capybara#The_DSL
[db-cleaner]: https://github.com/bmabey/database_cleaner
[Launchy]: http://rubygems.org/gems/launchy
[feature-not-describe]: https://www.relishapp.com/rspec/rspec-rails/docs/feature-specs/feature-spec

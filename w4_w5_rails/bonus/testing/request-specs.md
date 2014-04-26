# Writing request specs

**TODO**: Does Capybara expect you to put this in spec/featues
**TODO**: emphasize that **all capybara** specs need to be in this
dir; can't use the helpers otherwise.

Request specs (often called integration specs) test your program
end-to-end. In an integration spec, you simulate a web-user
interacting with your site, filling out forms, clicking buttons, etc.

## Setup

First add capybara as a dependency in your gemfile; capybara is the
library which lets us interact with a site inside of a spec file.

```ruby
group :development do
  gem 'rspec-rails'
  gem 'guard-rspec'
  gem 'capybara'
end
```

You'll also need to add the following line to your `spec_helper.rb`:
`require 'capybara/rspec'`

## Writing request specs

Request specs go in the `spec/requests` directory.

```ruby
# spec/requests/secrets_spec.rb
require 'spec_helper'

describe "secrets creation" do
  def submit_form
    visit new_secret_path

    # note that these field guys take the text names; capitalization
    # has to be right.
    fill_in 'Screen name', :with => "my_name"
    fill_in 'Body', :with => "my_secret"
    click_button "Submit secret!"
  end

  it "creates a new secret" do
    expect { submit_form }.to change(Secret, :count).by(1)
  end

  it "redirects to spec afterward" do
    submit_form
    current_path.should =~ Regexp.new('secrets/\d+')
  end
end
```

## Testing for presence of selectors

* have_selector
* within "#genres li:nth-child(2)" do

## Resources

* https://github.com/jnicklas/capybara

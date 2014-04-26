# Better Fixtures with FactoryGirl and Faker

## Overview of Factories

Factories generate sample data for your tests.  Another solution for generating test data is to use Rail's built in fixtures, but we prefer factories because fixtures are static and therefore brittle.

**FactoryGirl** [is the top library][f-girl-is-top]
for replacing fixtures at the time of this writing.

**Faker** is a gem which generates fake filler data like names, phone numbers, and Ipsum Lorem.

[f-girl-is-top]: https://www.ruby-toolbox.com/categories/rails_fixture_replacement

## Basic Use

Example of a factory for the post class, with a `title` attribute:

```ruby
# my_app/spec/factories/posts.rb

FactoryGirl.define do
  factory :post do
    title "It's a title!"
  end
end
```

You can use the factory to generate test data using `FactoryGirl.create(:post)` 
in your rspec code.  Example:

```ruby
# my_app/spec/models/post_spec.rb

# let's say we want to test the validation of title presence

describe Post do
 # ...
 it "should require a title" do
   expect(FactoryGirl.build(:post, :title => "")).not_to be_valid
 end
end
```

## Setting Up FactoryGirl and Faker

*In just three steps:*

 1. [Set up RSpec][rspec-setup] for your Rails application
 2. In the `Gemfile`, add `gem 'factory_girl_rails'` under `group :development, :test`, 
and add `gem 'faker'` under the `group :test`.

[rspec-setup]: ./rspec-and-rails-setup.md

Your new `Gemfile` should include the following gems:

```ruby
# my_app/Gemfile
group :development, :test do 
  gem 'rspec-rails' 
  gem 'factory_girl_rails' 
end 

group :test do 
  gem 'faker' 
  gem 'capybara' 
  gem 'guard-rspec' 
  gem 'launchy' 
end
```

Run `bundle install` to install the `faker` and `factorygirl` gems.

 3. Add the following line at the end of your `config.generators block`
    inside of the `config/application.rb` file:
 

```ruby
  g.fixture_replacement :factory_girl, :dir => "spec/factories"
```

You should now have the following in your `config/application.rb` file:


```ruby
config.generators do |g| 
  g.test_framework :rspec, 
    :fixtures => true, 
    :view_specs => false, 
    :helper_specs => false, 
    :routing_specs => false, 
    :controller_specs => true, 
    :request_specs => true 
  g.fixture_replacement :factory_girl, :dir => "spec/factories" 
end
```
 
## Using FactoryGirl and Faker

### Setting up Factories

To use FactoryGirl with RSpec, you will create a file called
`factories.rb` in the directory `my_app/spec`.  The factories you define
in that file can be used in your RSpec test files.

Typical usage:

```ruby
# my_app/spec/factories/posts.rb

FactoryGirl.define do
  factory :post do
    title "It's a title!"
    subtitle  "~also has a subtitle~"
    random_num        { 1 + rand(100) }
        
    # Child of :post factory, since it's in the `factory :post` block
    factory :published_post do
      published true
    end
  end
end
```

In the example above, the class is `Post`, and its attributes are `title`, `subtitle`, `random_num`, and `published`.


### Using Faker

The `faker` gem is a module of methods that generate randomized fake data
in specific formats.  It can generate names, addresses, phone numbers, 
business and product names, and more.  Some quick examples:

```
# in IRB

$ require 'faker'

$ Faker::Commerce.product_name
 => "Incredible Rubber Pants"
 
$ Faker::Internet.domain_name
  => "emmerichdonnelly.org"
  
$ Faker::Name.name
   => "Dessie Mertz"
```

The [`faker` documentation][faker-docs]
has details about all the data types available.

[faker-docs]: http://rubydoc.info/github/stympy/faker/master/frames

### Testing Model Validations

Start with the most basic factory to satisfy your model validations.  In other words, if you have no 
required attributes for `cat`, then your factory could look like this:

```ruby
# in my_app/spec/factories/cats.rb

FactoryGirl.define do
  factory :cat do
  end
end
```

And your test could look like this:

```ruby
# in my_app/spec/cat_spec.rb

require 'spec_helper'

describe Cat do
  it "has no required attributes" do
    FactoryGirl.create(:cat).should be_valid
  end
end
```

However, let's say your model has many specific validations and required attributes:

```ruby
# in my_app/app/models/cat.rb

class Cat < ActiveRecord::Base
  validates :name, :presence => true, format: { with:  /\A[a-zA-Z\s\.]+\z/, 
    message: "only allows letters and spaces" }, length: { minimum: 2 },
    uniqueness: true
  validates :color, :presence => true, inclusion: { in: %w(red blue green yellow brown black white orange),
    message: "That is not a valid color for a cat." }
  validates :age, :presence => true, numericality: { only_integer: true, 
    less_than: 100, message: "Cat age must be a number below 100." }
  validates :temperament, :presence => true, exclusion: { in: %w(evil mean), 
    message: "No bad cats allowed!" }
  
end
```

In that case, you need to explicitly create attributes in the factory which satisfy the validations, like this:

```ruby
# in my_app/spec/factories/cats.rb

FactoryGirl.define do
  factory :cat do
    name "Garfield"
    color "orange"
    age 53
    temperament "sarcastic"
  end
end
```

**Overwriting attributes in your test**

A valid model factory can easily be overwritten to test invalid
instances of the model:

```ruby
# ...
it "must have a name" do
  FactoryGirl.build(:cat, name: nil).should_not be_valid
end
# ...
```

Passing in a hash of attributes and values for the second argument of
`FactoryGirl#build`, `FactoryGirl#create`, and similar methods will 
overwrite those attributes for the model.

```ruby
# in my_app/spec/models/cat_spec.rb

# fully testing the name validations

describe Cat do
 context "when name is invalid" do
   it "should require a name" do
     expect(FactoryGirl.build(:cat, :name => "")).not_to be_valid
   end
   
   it "should only accept letters and spaces in name" do
     expect(FactoryGirl.build(:cat, :name => "1337-H4x0r")).not_to be_valid   
   end
   
   it "should require a name longer than 2 letters" do
     expect(FactoryGirl.build(:cat, :name => "Bo")).not_to be_valid
   end
 end
 # (... more validation tests would follow.)
end
```

### Making Many Models At Once

**Creating Randomized Data**

If you want to generate a large batch of test data, you most likely want
different attributes for each entry (rather than having 100 users with the
name 'John Doe').

To generate random names for our test users, we must 
[pass a block][passing-block] that generates the random name string instead of passing the string value itself.

```ruby
# in my_app/spec/factories/puppies.rb

FactoryGirl.define do
  factory :puppy do
    name do
      Faker::Name.name
    end
  end
end
```

In the RSpec test, you can now 
[generate or build multiple records][mult-records].

[passing-block]: https://github.com/thoughtbot/factory_girl/blob/master/GETTING_STARTED.md#lazy-attributes
[seqs]: https://github.com/thoughtbot/factory_girl/blob/master/GETTING_STARTED.md#sequences
[mult-records]: https://github.com/thoughtbot/factory_girl/blob/master/GETTING_STARTED.md#building-or-creating-multiple-records

### Models with Associations

Using a sequence is an easy way to generate associated models with unique values, 
because it gives you an iterator.
 
Example: Creating a cat with an associated hat.

(This assumes you have already got the `hat.rb` model file, the
`create_hats...` table migration, and the one-to-one association 
between cats and  hats set up.)
 
```ruby
# in my_app/spec/factories/cats.rb

FactoryGirl.define do
  factory :cat do
    sequence :hat do |n|
      FactoryGirl.create(:hat, :hat_name => "top-hat #{n}")
    end
  end
end
```

This example also uses FactoryGirl 
[sequences][seqs], to add an iterator.

You can test the association in this case by calling `#hat` on the 
generated cat:

```ruby
# in my_app/specs/cat_spec.rb

describe Cat do
 
 # ...
  
  it "may wear a hat" do
    FactoryGirl.build(:cat).hat.should be_instance_of(Hat)
  end
  
end
```

### Factory Writing Patterns

**Inheriting from a base factory**

In the below 

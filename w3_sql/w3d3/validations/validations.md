# Validations I: Basics

This guide teaches you how to validate that objects are correctly
filled out before they go into the database. Validations are used to
ensure that only valid data is saved into your database. For example,
it may be important to your application to ensure that every user
provides a valid email address and mailing address. Validations keep
garbage data out.

### Versus database constraints

We've seen how to write some database constraints in SQL (`NOT NULL`,
`REFERENCES`, `UNIQUE INDEX`); the database level will enforce these
constraints. These constraints are very strong, because not only will
they keep bugs in our Rails app from putting bad data into the
database, they'll also stop bad data coming from other sources (SQL
scripts, the database console, etc).

We will frequently use simple DB constraints like these. However, for
complicated validations, DB constraints can be tortuous to write in
SQL.

Also, when a DB constraint fails, a generic error is thrown to Rails
(`SQLException`). In general, errors thrown by the DB cannot be
handled by Rails, and a web user's request will fail with an ugly 500,
internal server error. DB constraints are good at catching corrupt
data from a **serious software bug**, but they are not appropriate for
validating user input. If a user chooses a previously chosen username,
they should not get a 500 error page; Rails should nicely ask for
another name. This is what *model-level validations* are good at.

Model-level validations live in the Rails world. Because we write them
in Ruby, they are very flexible, database agnostic, and convenient to
test, maintain and reuse. Rails provides built-in helpers for common
validations, making them easy to add. Many things we can validate in
the Rails layer would be very difficult to enforce at the DB layer.

That said, it is good practice to create unique indices and `NOT NULL`
constraints (in addition to Rails validations). This will catch errors
from non-Rails sources, and serve as a last line of defense.

## When does validation happen?

Whenever you call `save`/`save!` on a model, ActiveRecord will first
run the validations to make sure the data is valid to be persisted
permanently to the DB. If any validations fail, the object will be
marked as invalid and Active Record will not perform the `INSERT` or
`UPDATE` operation. This keeps invalid data from being inserted into
the database.

To signal success saving the object, `save` will return `true`;
otherwise `false` is returned. `save!` will instead raise an error if
the validations fail.

**Always use `save!` unless you are going to explicitly check if the
validations failed**. Otherwise, you may silently fail to save
records. Make `save!` your default!

## `valid?`

Before saving, ActiveRecord calls the `valid?` method; this is what
actually triggers the validations to run. If any fail, `valid?`
returns `false`. Of course, when `save`/`save!` call `valid?`, they
are expecting to get `true` back. If not, ActiveRecord won't actually
perform the SQL `INSERT`/`UPDATE`.

You can also use this method on your own. `valid?` triggers your
validations and returns true if no errors were found in the object,
and false otherwise.

```ruby
class Person < ActiveRecord::Base
  validates :name, :presence => true
end

Person.create(:name => "John Doe").valid? # => true
Person.create(:name => nil).valid? # => false
```

## `errors`

Okay, so we know an object is invalid, but what's wrong with it? We
can get a hash-like object through the`#errors` method. `#errors`
returns an instance of `ActiveModel::Errors`, but it can be used like
a `Hash`. The keys are attribute names, the values are arrays of all
the errors for each attribute. If there are no errors on the specified
attribute, an empty array is returned.

The `errors` method is only useful *after* validations have been run,
because it only inspects the errors collection and does not trigger
validations itself. You should always first run `valid?` or `save` or
some such before trying to access `errors`.

```ruby
# let's see some of the many ways a record may fail to save!

class Person < ActiveRecord::Base
  validates :name, :presence => true
end

>> p = Person.new
#=> #<Person id: nil, name: nil>
>> p.errors
#=> {}

>> p.valid?
#=> false
>> p.errors
#=> {:name=>["can't be blank"]}

>> p = Person.create
#=> #<Person id: nil, name: nil>
>> p.errors
#=> {:name=>["can't be blank"]}

>> p.save
#=> false

>> p.save!
#=> ActiveRecord::RecordInvalid: Validation failed: Name can't be blank

>> Person.create!
#=> ActiveRecord::RecordInvalid: Validation failed: Name can't be blank
```

### `errors.full_messages`

To get an array of human readable messages, call
`record.errors.full_messages`.

```
>> p = Person.create
#=> #<Person id: nil, name: nil>
>> p.errors.full_messages
#=> ["Name can't be blank"]
```

## Built-in validators

Okay, but how do we actually start telling Active Record what to
validate? Active Record offers many pre-defined validators that you
can use directly inside your class definitions. These helpers provide
common validation rules. Every time a validation fails, an error
message is added to the object's `errors` collection, and this message
is associated with the attribute being validated.

There are many many different validation helpers; we'll focus on the
most common and important. Refer to the Rails guides or documentation
for a totally comprehensive list.

### `presence`

This one is the most common by far: the `presence` helper validates
that the specified attributes are not empty. It uses the `blank?`
method to check if the value is either `nil` or a blank string, that
is, a string that is either empty or consists of only whitespace.

```ruby
class Person < ActiveRecord::Base
  # must have name, login, and email
  validates :name, :login, :email, :presence => true
end
```

This demonstrates our first validation: we call the class method
`validates` on our model class, giving it a list of column names to
validate, then the validation type mapping to `true`.

If you want to be sure that an associated object exists, you can do
that too:

```ruby
class LineItem < ActiveRecord::Base
  belongs_to :order

  validates :order, :presence => true
end
```

Don't check for the presence of the foreign_key (`order_id`); check
the presence of the associated object (`order`). This will become
useful later when we do nested forms. Until then, just develop good
habits.

The default error message is "X can't be empty".

### `uniqueness`

This helper validates that the attribute's value is unique:

```ruby
class Account < ActiveRecord::Base
  # no two Accounts with the same email
  validates :email, :uniqueness => true
end
```

There is a very useful `:scope` option that you can use to specify
other attributes that are used to limit the uniqueness check:

```ruby
class Holiday < ActiveRecord::Base
  # no two Holidays with the same name for a single year
  validates :name, :uniqueness => {
    :scope => :year,
    :message => "should happen once per year"
  }
end
```

Notice how options for the validation can be passed as the value of
the hash.

The default error message is "X has already been taken".

### Less common helpers

Presence and uniqueness are super-common. But there are some others
that are often handy. Refer to the documentation for all the gory
details:

* `format`
    * Tests whether a string matches a given regular expression
* `length`
    * Tests whether a string or array has an appropriate length. Has
      options for `minimum` and `maximum`.
* `numericality`; options include:
    * `greater_than`/`greater_than_or_equal_to`
    * `less_than`/`less_than_or_equal_to`
* `inclusion`
    * `in` option lets you specify an array of possible values. All
      other values are invalid.

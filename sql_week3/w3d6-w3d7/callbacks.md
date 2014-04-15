# Callbacks

Callbacks are methods that get called at certain moments of an
object's life cycle. With callbacks it is possible to write code that
will run whenever an Active Record object is created, saved, updated,
deleted, validated, or loaded from the database.

## Relational Callbacks

Suppose an example where a user has many posts. A user's posts should
be destroyed if the user is destroyed; else the posts are said to be
*widowed*. To do this, we pass the `:dependent` option to `has_many`:

```ruby
class User < ActiveRecord::Base
  has_many :posts, :dependent => :destroy
end

class Post < ActiveRecord::Base
  belongs_to :user
end

>> user = User.first
=> #<User id: 1>
>> user.posts.create!
=> #<Post id: 1, user_id: 1>
>> user.destroy
=> #<User id: 1>
```

A somewhat less common option is to use `:dependent => :nullify`;
which instead of destroying the dependent objects will merely set the
foreign key to `NULL`. An even less common option is `:dependent =>
:restrict`, which will cause an exception to be raised if there exists
associated objects; you'd have to destroy the associated objects
yourself. This won't do any deleting or nullifying for you, but at
least you are assured safety from widowed records.

You may add `:dependent => destroy` on a `belongs_to` relationship,
but this is uncommon. Logically, if a `Post` `belongs_to` a `User`,
why should destroying the `Post` destroy the `User`? For this reason
it's seldom the case to add dependent logic to `belongs_to` relations.

### Active Record and Referential Integrity

When a record is widowed, its foreign key becomes invalid. This is
an error.

Using `:dependent => :destroy` or `:dependent => :nullify` should help
clean up child records so that records don't become widowed. However,
these validations won't help if you explicitly set a bogus foreign key
value (e.g., `post.user_id = -1`). Likewise, if a record is DELETEd
through the SQL console, Rails won't be able to protect against the
error.

To guarantee **referential integrity**, you need to enforce a
constraint at the DB level. As you know from the SQL readings, this
means adding a FOREIGN KEY constraint.

To add FK constraints in ActiveRecord, you can use a library like
[foreigner][foreigner]. You don't have to worry about this for now;
some Rails developers consider this to be overkill. Widowed records aren't the
\#1 worst thing in the world, since they can usually be safely
ignored. However, it is good for you to know about and understand the
potential problems, though.

[foreigner]: https://github.com/matthuhiggins/foreigner

## Callback Registration

You can also hook into other model lifecycle events. This is less
common than dependent callbacks; registered callbacks are an advanced
feature, somewhat fancy, and a little magical.

You implement callbacks as ordinary methods and use a macro-style
class method to register them as callbacks:

```ruby
class User < ActiveRecord::Base
  validates :random_code, :presence => true
  before_validation :ensure_random_code

  protected
  def ensure_random_code
    # assign a random code
    self.random_code ||= SecureRandom.hex(8)
  end
end
```

Here we use a callback to make sure to set the `random_code` attribute
(if forgotten) before we perform validations on the object. This helps
the user; they'll be alllowed to forget to specify `random_code` and
we'll conveniently make one for them.

It is considered good practice to declare callback methods as
protected or private. If left public, they can be called from outside
of the model and violate the principle of object encapsulation.

## Available Callbacks

There are many available Active Record callbacks; I've collected the
most commonly hooked-into:

* `before_validation` (handy as a last chance to set forgotten fields)
* `after_create` (handy to do some post-create logic, like send a confirmation email)
* `after_destroy` (handy to perform post-destroy clean-up logic)

You can further specify that the callback should only be called when
performing certain operations:

```ruby
class CreditCard < ActiveRecord::Base
  # Strip everything but digits, so the user can specify "555 234 34" or
  # "5552-3434" or both will mean "55523434"
  before_validation(:on => :create) do
    self.number = number.gsub(%r[^0-9]/, "") if attribute_present?("number")
  end
end
```

This will only perform this callback when creating the object;
validations before subsequent saves will not perform this.

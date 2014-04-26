# Nested Objects and Validations: `inverse_of`

What is `inverse_of` and why do we need it?

## Why?

Here are a couple models we have:

```ruby
class User < ActiveRecord::Base
  has_many :addresses
end

class Address < ActiveRecord::Base
  belongs_to :user
end
```

Simple one-to-many associations between a user and addresses.

Let's go to the console:

```
>> user = User.new(name: 'John', email: 'j@j.com')
  => #<User id: nil, name: "John", email: "j@j.com", created_at: nil, updated_at: nil>
>> user.addresses.build(street: '123 Cherry Lane', city: 'New York', state: 'New York')
  => #<Address id: nil, street: "123 Cherry Lane", city: "New York", state: "New York", user_id: nil, created_at: nil, updated_at: nil>
>> user.save
   (0.1ms)  begin transaction
  SQL (8.2ms)  INSERT INTO "users" ("created_at", "email", "name", "updated_at") VALUES (?, ?, ?, ?)  [["created_at", Tue, 11 Jun 2013 22:17:24 UTC +00:00], ["email", "j@j.com"], ["name", "John"], ["updated_at", Tue, 11 Jun 2013 22:17:24 UTC +00:00]]
  SQL (0.2ms)  INSERT INTO "addresses" ("city", "created_at", "state", "street", "updated_at", "user_id") VALUES (?, ?, ?, ?, ?, ?)  [["city", "New York"], ["created_at", Tue, 11 Jun 2013 22:17:24 UTC +00:00], ["state", "New York"], ["street", "123 Cherry Lane"], ["updated_at", Tue, 11 Jun 2013 22:17:24 UTC +00:00], ["user_id", 1]]
   (0.8ms)  commit transaction
  => true
```

*Note that when we hit save on the user, both the user and the address
were inserted into the database.*

Simple enough. No problems.

Let's make a small alteration in the `Address` model though:

```ruby
class Address < ActiveRecord::Base
  belongs_to :user

  validates :user_id, :presence => true
end
```

We added a simple validation on the foreign key; we don't want to
have a dangling address without a user.

And we do the same thing in the console:

```
>> user = User.new(name: 'John', email: 'j@j.com') => #<User id: nil, name: "John", email: "j@j.com", created_at: nil, updated_at: nil>
>> user.addresses.build(street: '123 Cherry Lane', city: 'New York', state: 'New York')
  => #<Address id: nil, street: "123 Cherry Lane", city: "New York", state: "New York", user_id: nil, created_at: nil, updated_at: nil>
>> user.save   (0.1ms)  begin transaction
   (0.1ms)  rollback transaction
  => false
```

WTF?! What happened? Let's look at the error messages:

```
>> user.errors.messages
  => {:addresses=>["is invalid"]}
```

Let's take a look at the address object we tried to create:

```
>> user.addresses.first.errors.messages
  => {:user_id=>["can't be blank"]}
```

Why is the `user_id` blank? We created the `Address` through a `User`;
why doesn't it use the `User`'s `id`?

The problem is that when we save `user` (and the associated `Address`
objects), Rails first runs the validations on each of the objects. If
any of the objects fail validation, none of them are saved to the
DB. At this point, the `User` doesn't have an `id` yet, so it's not
possible to fill out the `Address` `user_id` attribute yet.

How can we get around this problem? We want the `Address` to know that
it is indeed associated with a `User`, even before the `User` is saved
to the DB.

## Don't validate `user_id`

Our first problem is that we are validating the `user_id` attribute of
`Address`, but if the `User` isn't saved before the `Address` is
validated, there won't be any id to use.

The solution is not to validate `Address#user_id`; instead, we should
validate the presence of `Address#user`. The `User` may not be saved,
but we should be able to access the `User` object through
`Address#user`. We know that before saving we can access
`User#addresses`:

```ruby
u = User.new(:name => "Houdini")
u.addresses.build(:city => "San Francisco", :state => "California")
u.addresses.build(:city => "Reno", :state => "Nevada")

u.addresses
# => returns both of the two addresses.

# save the `User` and `Address`es
u.save!
```

Cool. Let's first update our validations:

```ruby
class User < ActiveRecord::Base
  has_many :addresses
end

class Address < ActiveRecord::Base
  belongs_to :user
  validates :user, :presence => true
end
```

Okay, let's try again:

```ruby
u = User.new(:name => "Houdini")
u.addresses.build(:city => "San Francisco", :state => "California")
u.addresses.build(:city => "Reno", :state => "Nevada")

u.save!
# => Still yells about `Address#user` being blank??
```

Wait. What's happening?

```ruby
# get first address
address1 = u.addresses.first
address1.user
# => nil??
```

The problem is that when we build an `Address` through the
`User#addresses` association, the `User` hangs on to new `Address`,
but the `Address` doesn't know which `User` it has been built for.

## `inverse_of`'s job

The solution is to add an option to our
`has_many`/`has_one`/`belongs_to` associations: `inverse_of`.

`inverse_of`'s job is to let objects know that they're associated to
one another. Our `User` knows about its `Addresses`, but not
vice-versa.

To fix this, we set the `:inverse_of` option on the `User` model's
`has_many :addresses` association.

```ruby
class User < ActiveRecord::Base
  has_many :addresses, :inverse_of => :user
end
```

Why set it on `User` and not on `Address`? Because you're creating an
address through a user (i.e. that's the association - and related
method - that's actually being used). With the `:inverse_of` option
set, the `user.addresses.build` method will go look for the address
object's `:user` association and make sure it points to the user
object.

*NB: It's good to know which side of the association the `:inverse_of`
option needs to go on, but you should always put it on both sides.*

Adding that fixes our problem:

```ruby
# get first address
address1 = u.addresses.first
address1.user
# => u
```

## Final Words

Remember, `:inverse_of` is an option on associations that takes as a
value the name of an inverse association. Its purpose is to let objects
know that they're associated with one another when those objects are
created or instantiated through an association.

This will be particularly handy when we're dealing with nested forms
that may have validations that would trip everything up were we not
to use `inverse_of`.

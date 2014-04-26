# Authentication I: Creating Users

In this project, we will refer to the [NewAuthDemo][new-auth-demo]
project.

## Phase I: bcrypt

### Don't store passwords in the DB

Never store passwords in the database. This is bad, because if someone
hacks your server and gains access to the database, they will be able
to steal all of your user's passwords. Since your users probably use
the same password across services, the hacker will be able to login to
the user's gmail, facebook, etc.

### What is a hash function?

The solution to this problem is to use a **hash function**. A hash
function is a "one-way" function; it is easy to compute in one
direction, but difficult to "invert". That means that, given a
password, you can easily calculate the hash value of the password, but
there is no easy way to go back and recover the password from the
hash.

Basically, a hash is sort of like scrambling; scrambling is easier
than unscrambling. The fancy mathematical trick (which we'll leave to
the mathematicians), is to design a function where:

* You scramble things the same way every time: the same password will
  hash to the same value every time.
* That means the scrambling isn't really random; if the scrambling
  were totally random, you'd calculate a new, different hash every time.
* Even though the scrambling isn't truly random, it should still be
  difficult (that is, near impossible) to "unscramble".

### Using a library

Let's use a library called `bcrypt` to do the hashing for
us. First `gem install bcrypt`. Now let's play in the console:

```
[1] pry(main)> require 'bcrypt'
=> true
[2] pry(main)> password_hash = BCrypt::Password.create("my_secret_password")

=> "$2a$10$sl.3R32Paf64TqYRU3DBduNJkZMNBsbjyr8WIOdUi/s9TM4VmHNHO"
[3] pry(main)> password_hash.is_password?("my_secret_password")
=> true
[4] pry(main)> password_hash.is_password?("not_my_secret_password")
=> false
```

We use the `BCrypt::Password` class here; the `::create` factory
method takes a password and hashes it. We store the resulting
`BCrypt::Password` object in `password_hash`.

The `BCrypt::Password` class has an instance method,
`#is_password?`. The method takes a string, hashes the string, and
compares it with the `BCrypt::Password` contents.

If the argument is the same string as before, the two hashes will be
equal and `#is_password?` returns true; otherwise false is returned.

### Requiring `bcrypt`

Edit your `Gemfile`; add `gem 'bcrypt'`.

## Phase II: `User` model

### Initial columns and indices

Let's start with `rails g model user`. Add string columns to the
`users` table: `username` and `password_digest`. **Digest** is another
name for a hash. Toss on an index for `username` too (make it unique).

Note that we **will not** store the password itself in the DB; we're
going to store the hashed version.

### Storing/verifying a password

Let's create a `User` object:

```
[1] pry(main)> u = User.new
=> #<User id: nil, username: nil, password_digest: nil, created_at: nil, updated_at: nil>
[2] pry(main)> u.username = "earl"
=> "earl"
[4] pry(main)> u.password_digest = BCrypt::Password.create("i_love_breakfast")
=> "$2a$10$oO6LUi.ikUl7rloGcZ.NFeURc0pNQhQA9MTaB89XX/kDNm.3vQVVu"
[5] pry(main)> u.save
   (0.3ms)  BEGIN
  SQL (108.5ms)  INSERT INTO "users" ("created_at", "password_digest", "updated_at", "username") VALUES ($1, $2, $3, $4) RETURNING "id"  [["created_at", Wed, 14 Aug 2013 18:50:23 UTC +00:00], ["password_digest", "$2a$10$oO6LUi.ikUl7rloGcZ.NFeURc0pNQhQA9MTaB89XX/kDNm.3vQVVu"], ["updated_at", Wed, 14 Aug 2013 18:50:23 UTC +00:00], ["username", "earl"]]
   (0.5ms)  COMMIT
=> true
[6] pry(main)> u.password_digest
=> "$2a$10$oO6LUi.ikUl7rloGcZ.NFeURc0pNQhQA9MTaB89XX/kDNm.3vQVVu"
```

Let's see how to verify a password later:

```
[8] pry(main)> u = User.first
  User Load (0.7ms)  SELECT "users".* FROM "users" LIMIT 1
=> #<User id: 1, username: "earl", password_digest: "$2a$10$oO6LUi.ikUl7rloGcZ.NFeURc0pNQhQA9MTaB89XX/kD...", created_at: "2013-08-14 18:50:23", updated_at: "2013-08-14 18:50:23">
[9] pry(main)> BCrypt::Password.new(u.password_digest).is_password?("i_love_breakfast")
=> true
```

Okay, cool. Notice that when we pull down the `User`,
`password_digest` is set to a string, since that is what the DB
stores. We want to get a `BCrypt::Password` object back from the
digest. Because the digest is **already hashed**, we use the `new`
constructor rather than the `create` factory method; `create` creates
a `Password` object by hashing the input, while `new` builds a
`Password` object from an existing, stringified hash.

Anyway all this code is not very convenient. Let's add some
helper-methods to `User`.

### Write `User#password=` and `User#is_password?`

Let's first write a method that will make it easier to set the
`password_digest` column; right now, the programmer is required to
hash the password themselves. Let's do it for them:

```ruby
class User < ActiveRecord::Base
  def password=(password)
    self.password_digest = BCrypt::Password.create(password)
  end
end
```

The fact that we don't have a `password` column in the DB does not
prevent us from writing a setter method named `password=`. This is
totally cool. In this case, instead of saving the actual password,
we're going to use BCrypt to hash it and then save it to the
`password_digest` column.

Likewise, let's save the programmer from having to do the hard work of
verifying a password:

```ruby
class User < ActiveRecord::Base
  def password=(password)
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end
end
```

Let's test it out!

```
[3] pry(main)> u = User.new
=> #<User id: nil, username: nil, password_digest: nil, created_at: nil, updated_at: nil>
[4] pry(main)> u.username = "Houdini"
=> "Houdini"
[5] pry(main)> u.password = "i_remember_kiki"
=> "i_remember_kiki"
[6] pry(main)> u.save
   (0.3ms)  BEGIN
  SQL (4.8ms)  INSERT INTO "users" ("created_at", "password_digest", "updated_at", "username") VALUES ($1, $2, $3, $4) RETURNING "id"  [["created_at", Wed, 14 Aug 2013 19:01:58 UTC +00:00], ["password_digest", "$2a$10$.cMnzIMCgh/VUZ1OF3dJUOf1zJSRBw2t6YMAcKeuIbYmx8KK3.u9G"], ["updated_at", Wed, 14 Aug 2013 19:01:58 UTC +00:00], ["username", "Houdini"]]
   (2.6ms)  COMMIT
=> true
[7] pry(main)> u = User.last
  User Load (0.8ms)  SELECT "users".* FROM "users" ORDER BY "users"."id" DESC LIMIT 1
=> #<User id: 2, username: "Houdini", password_digest: "$2a$10$.cMnzIMCgh/VUZ1OF3dJUOf1zJSRBw2t6YMAcKeuIbYm...", created_at: "2013-08-14 19:01:58", updated_at: "2013-08-14 19:01:58">
[8] pry(main)> u.is_password?("i_remember_kiki")
=> true
[9] pry(main)> u.is_password?("random_password_guess")
=> false
```

Whoa, object orientation for the win! Hey, did you know it's totally
cool to write methods on your model objects? I grant thee the
permission! Go forth, and multiply methods!

## Phase III: Creating new users

Let's add a `UsersController` and a `users` resource. Let's add a
`new` view so that the user can sign up for the site.

```ruby
# app/controllers/users_controller.rb
class UsersController < ApplicationController
  def create
    @user = User.new(user_params)

    if @user.save
      render :json => @user
    else
      render :json => @user.errors.full_messages
    end
  end

  def new
    @user = User.new
  end
  
  private
  
  def user_params
    params.require(:user).permit(:username, :password)
  end
end
```

Notice that we are calling `#permit` with `:password`, and *not*
with `password_digest`.  Is this ok?  *Yes*:
Just like in your Rails Lite
project, mass-assignment will call the setter method `password=`. It
is totally okay that this doesn't set a password column.

Then our views:

```html+erb
<!-- app/views/users/new.html.erb -->
<h1>Create User</h1>

<%= render "form", :user => @user %>

<!-- app/views/users/_form.html.erb -->
<% action = (user.persisted? ? user_url(user) : users_url) %>
<% method = (user.persisted? ? "put" : "post") %>
<% message = (user.persisted? ? "Update user" : "Create user") %>

<form action="<%= action %>" method="post">
  <input
     name="_method"
     type="hidden"
     value="<%= method %>">
  <input
     name="authenticity_token"
     type="hidden"
     value="<%= form_authenticity_token %>">

  <label for="user_username">Username</label>
  <input
     id="user_username"
     name="user[username]"
     type="text">
  <br>

  <label for="user_password">Password</label>
  <input
     id="user_password"
     name="user[password]"
     type="password">
  <br>

  <input type="submit" value="<%= message %>">
</form>
```

### Validating `User`

Okay, we can now create users through the form. We probably want to
toss some validations on:

```ruby
class User < ActiveRecord::Base
  validates :username, :presence => true
  validates :password_digest, :presence => { :message => "Password can't be blank" }

  # ...
end
```

Notice that I set my own message to use if the `password_digest` is
blank. The default is "Password digest can't be blank", but I don't
like that because the user won't know what a password digest is.

What if we want to validate the length of the password? Right now, we
never store the password in the `User` object; for that reason, we
won't still have the password to check when we eventually validate the
`User`. Does it make sense why we can't just slap on `validates
:password, :length => { :minimum => 6 }`?

Here's one way to accomplish our goal: store the password in an
instance variable, but never save this to the DB. First let's modify
`#password=`:

```ruby
  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end
```

This saves the password in an instance variable. ActiveRecord **will
not** try to save the password to the DB, however. Instead, the
`@password` instance variable will be ignored.

We can now validate the password:

```ruby
class User < ActiveRecord::Base
  attr_reader :password

  validates :username, :presence => true
  validates :password_digest, :presence => { :message => "Password can't be blank" }
  validates :password, :length => { :minimum => 6, :allow_nil => true }

  # ...
end
```

Couple of notes. I added the `#password` reader method; the validation
will call this to check the attribute. Again, validations do not need
to check only database columns; you can apply a validation to any
attribute.

I also added `:allow_nil => true`. This means the validation will
not run if the password attribute is blank. This is desirable, because
the `@password` attribute is only set **if we change the password with
`#password=`.**

Let me give an example:

```
[7] pry(main)> User.create!(:username => "houdini", :password => "password")

   (0.3ms)  BEGIN
  SQL (0.6ms)  INSERT INTO "users" ("created_at", "password_digest", "updated_at", "username") VALUES ($1, $2, $3, $4) RETURNING "id"  [["created_at", Wed, 14 Aug 2013 20:53:14 UTC +00:00], ["password_digest", "$2a$10$88gQuHB0WxPa//tsI6pB4.xwrMWFGdtjnoMfSSfzgpzp5xIiQhM.6"], ["updated_at", Wed, 14 Aug 2013 20:53:14 UTC +00:00], ["username", "houdini"]]
   (2.0ms)  COMMIT
=> #<User id: 6, username: "houdini", password_digest: "$2a$10$88gQuHB0WxPa//tsI6pB4.xwrMWFGdtjnoMfSSfzgpzp...", created_at: "2013-08-14 20:53:14", updated_at: "2013-08-14 20:53:14">
[8] pry(main)> u = User.last
  User Load (0.5ms)  SELECT "users".* FROM "users" ORDER BY "users"."id" DESC LIMIT 1
=> #<User id: 6, username: "houdini", password_digest: "$2a$10$88gQuHB0WxPa//tsI6pB4.xwrMWFGdtjnoMfSSfzgpzp...", created_at: "2013-08-14 20:53:14", updated_at: "2013-08-14 20:53:14">
[9] pry(main)> u.password
=> nil
[10] pry(main)> u.password_digest
=> "$2a$10$88gQuHB0WxPa//tsI6pB4.xwrMWFGdtjnoMfSSfzgpzp5xIiQhM.6"
```

Notice that after we fetch Houdini back from the DB, the password is
no longer set. That's because this attribute only lived in an instance
variable that was never going to get persisted to the DB.

Let's try one more thing:

    [11] pry(main)> u.valid?
    => true

If we didn't `:allow_nil => true`, then Houdini would be marked as
invalid, because a `nil` `password` attribute would not meet the
length requirement. In reality, we only need to validate the password
when it has been changed, which is exactly when `@password` is not
`nil`.

[new-auth-demo]: https://github.com/appacademy-demos/NewAuthDemo

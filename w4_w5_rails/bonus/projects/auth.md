# Secure Auth

Today you will build SecretShareApp, but start to lock down the secrets
so that they truly are secrets. Each user should be able to upload
secrets, and also select a single user to share it with. No one but the
sender and recipient should see the secret. Today's project will focus
mostly on authorization and authentication.

**Read the instructions first before beginning**. 

## Manage `User` passwords

So far when we've dealt with passwords, we've stored them in the
database as plain-text. Very, very bad. In production, we would never do
that. What we want to do instead is store a hashed version of the
password. Thankfully, Rails provides us a simple way to do just that.

Rails has a helpful method for managing passwords:
[`has_secure_password`][has-secure-password]. First add bcrypt-ruby to
your Gemfile; it's required for `has_secure_password`. Next add, a
single line to your `User` model:

```ruby
class User < ActiveRecord::Base
  has_secure_password
end
```

This will add a fake `password` attribute to your model; you can set
the `password`, but it won't be stored to the DB. This will be for when
a user is created and has sent along their desired password, or for when
a user has sent along their password for login.

By using `has_secure_password`, assignments to `password` will set a
scrambled ([hashed][hash-wiki]) version of the password in a
`password_digest` column (you must put this column in your database).  A
good hash won't let you recover the original from the scrambled version,
but when the user comes back with the right password, you can scramble
(*rehash*) it and compare with the stored hash. You should write a
migration to add a string `password_digest` column; don't add a
`password` column, you **never** want to store plaintext passwords.

`has_secure_password` will also add a fake `password_confirmation`
attribute; if present, it will validate that `password ==
password_confirmation`. Again, neither will be persisted.

After saving the model, we can call `#authenticate` on the user object
during login, passing a submitted password. This returns `false` if
password doesn't match, else returns back the user. `#authenticate` is
also provided by the `has_secure_password` macro.

### Requirements

* A `/users/new` path should give you a form to create a user.
    * Hint: Use `<input type='password'>` to filter the password field
* Validations:
    * Enforce a unique screenname.
    * Validate password length.
    * Validate email format (just rip a regex off the internet).
    * Be careful; even though we validate the password fields, they
      won't be stored. Subsequent updates to the `User` model will
      fail because the password won't validate.
    * We can run the password validations only on first create or
      password update by adding an [`:if` option][validates-if]. In
      particular, changes to other `User` attributes (like the
      `session_token` should not run these validations).
* Flash success on user creation.

[validates-if]: http://stackoverflow.com/questions/8533891/rails-validates-if

## Architecture

### signup/login flow

In short:

* GET to `/users/new` should return a form for a new user
* POST to `/users` should create the user.
* GET to `/session/new` should return form for login
* POST to `/session` should send along login credentials,
  verify login credentials, issue token (and
  store in cookie+db), and redirect to `/secrets`.
* DELETE to `/session` should log the user out

## Flow

There should be two controllers with content. `UsersController` should
manage user creation and its `show` action should display all
secrets shared between the currently logged in user and the user whose
profile is showing.

Also build a `SecretsController`; the `index` action should list
the current user's shared secrets, and the `show` should display a
single secret.

Implement a privacy model; try to do a better job than
Facebook. Whenever a privileged request is made (almost any request),
make sure you're properly authenticating and authorizing the user making
the request.

On protected pages, redirect to login page if not logged in. 

Add a `logout` button throughout the site (in the application layout).
Of course, don't display the `logout` button if a user is logged in.

## Indices

Throw a unique index on `username` and `session_token` to enforce
uniqueness at the db level; it would be *really bad* (read:
compromised account) if these didn't end up being truly unique. Review
the SQL/AR chapter and read a bit about database race conditions (even
despite Rails validations).

Indices also provide fast lookup; you should add them to any column
you plan to perform lookups on. This will help not only with
`username` and `session_token`, but also any foreign key column.

## Mailing

* Use [ActionMailer][action-mailer-guide] to build an email flow.
    * Use the [letter_opener][letter-opener-github] gem to test emails
      being sent.
* Require user to confirm email address after login.
    * Confirmation should be done by sending a link embedding an
      `email_token` in the query string; clicking the link should 
      send you to a
      `validate_email` action; a simple GET request to this page
      should "validate" the address.
* Implement password reset
    * On the login page, there should be a "Forgot Your
      Password?" link that takes the user to a page that prompts them
      for their email address.
    * Do NOT reset the user's password just yet.
    * Send an email to that address with a link that will take them to
      a page that allows them to enter a new password. The link that you
      send will have to have something in the query string that
      identifies which user is trying to reset their password (similar
      to `session_token` or `email_token` above)
    * You'll need to add a column to your database to be able to lookup
      the `password_reset` token that is in the query string in the
      reset email you sent out.
    * The controller actions for this sequence could live in
      `UsersController` or you can construct a separate controller to
      deal with all this (`PasswordsController` or some such)

[hash-wiki]: http://en.wikipedia.org/wiki/Hash_function
[has-secure-password]:
https://github.com/rails/rails/blob/3-2-stable/activemodel/lib/active_model/secure_password.rb
[secure-random-docs]: http://www.ruby-doc.org/stdlib-1.9.3/libdoc/securerandom/rdoc/SecureRandom.html
[action-mailer-guide]: ../mailers/mailing-1.md

[letter-opener-github]: https://github.com/ryanb/letter_opener

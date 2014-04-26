# Music app

We're going to build an inventory system for record labels. This app
will let them track their `Band`s, `Album`s and `Track`s. Additionally
we'll offer user accounts so users can comment on our inventory.

## Warm Up: Authentication

Create a `User` model and bake in the prerequisites of
authentication. Let's use email addresses in lieu of usernames; in
phase III of the project we'll use their emails to send confirmation
emails and other spam.

See if you can build auth without looking back at any old
code or demos. Here's a rough guide if you get stuck:

In the `users` table, you'll want to store an `email`,
`password_digest` and `session_token`. Make sure to add database
constraints (require all fields), and indices to ensure uniqueness
of `email`s and speed up the lookup by `session_token`.

* Write methods to deal with the session token:
`User::generate_session_token` and `User#reset_session_token!`.
* Write a `User#password=(secret)` method which actually sets the
`password_digest` attribute using [BCrypt][bcrypt-documentation], and a
`User#is_password?(secret)` method to check the users' secret (_i.e._
their plaintext password) when they log in.
 * Be careful setting instance variables in activerecord, you can't just
   set `@password_digest`.  Check out the [write_attribute][write_attribute] method
   instead.
* Remember that in the `User` model, you'll want to use a
[callback][rails-guides-callbacks] to set the `session_token` before
validation if it's not present.
* Write a `User::find_by_credentials(email, secret)` method.

Next write a `UsersController` and `SessionsController`

* Write methods on the `UsersController` to allow new users to sign up.
  * Users should be logged in immediately after they sign up.
* Create a `SessionsController` but no `Session` model.
  * Write controller methods and the accompanying routes so that users
    can log in and log out. Should session be a singular resource?
  * `SessionsController#create` should re-set the appropriate user's
    `session_token` and `session[:session_token]`.
  * For now just redirect them to a `User#show` page which has nothing
    but their email on it.

Finally, take some time to refactor out shared code & add some convenience methods to a
`SessionsHelper`. Make sure to include the helper module appropriately so
they're available all over your app. You'll probably want:

* `#current_user` to return the current user.
* `#logged_in?` to return a boolean indicating whether someone is signed in.
* `#log_in_user!` reset the `user`s session token, cookie, &c.

[rails-guides-callbacks]:http://guides.rubyonrails.org/v3.2.13/active_record_validations_callbacks.html#available-callbacks
[bcrypt-documentation]:http://bcrypt-ruby.rubyforge.org/
[write_attribute]:http://api.rubyonrails.org/classes/ActiveRecord/Base.html

## Phase I: Band/Album/Track

We'll put aside the `user` features for a moment and build out our inventory system. First, the relevant models:

* A `Band` records many `Album`s.
* An `Album` contains many `Track`s.
    * Don't call it `Record`, as ActiveRecord uses `record_id` internally. 
* A `Track` is a recording on an `Album`.

Take a look at the description of the forms below to figure out what columns you'll need in the database.

Add `:dependent => :destroy` to applicable
associations. Remember that this option causes associated objects to
be destroyed on destroy.

After setting up the schema and
associations, generate controllers and write the seven actions for
each:

* `#index`
* `#show`
* `#new`
* `#create`
* `#edit`
* `#update`
* `#destroy`

Time to write some routes. Some of them should be nested, but keep them shallow.
For example, you'll probably want `Album`'s `:index`, `:new`, and `:create` routes
nested under a `Band`, but probably not `Album`'s `:show` route.

For the new/edit views, you'll want:

* A form to create a `Band`.
* A form to create an `Album`.
    * You'll need a drop down to select the `Band` that recorded it.
      * Because `Album#new` is nested under a band, select a default
        value for this drop down using the band's `:id` in the route.
        We give the user the drop down of all bands because we want
        them to be able to add albums to bands other than the one
        whos album index we are curently viewing.
    * Add the ability to select whether the album is a live or studio album.
      Don't use a column named "type", or Ruby will try to change the
      object type of the album and everything will break.
* A form to create a `Track`.
    * You'll need a drop down to select the `Album` it was recorded
      for.
    * Add the ability to select whether the `Track` is a bonus or
      regular track.
    * Use a textarea to upload some lyrics.
* Put your forms in a partial so they can be reused in both the new
  and edit pages.

Instructions on show:

* Your `Band`, `Album`, and `Track` show pages should be rich and list
  related objects.
    * E.g., `BandsController#show` should link to `Album`s and
      `Track`s.
    * E.g., `AlbumsController#show` should link to the `Band` and its
      `Track`s.
    * E.g., `TracksController#show` should link to the `Album` and
      `Band`.
    * If you're running into issues with nested url helper methods,
      make sure you pass BOTH objects into the helper method. E.g., `album_url(@album.band, @album)`.
* Tack on a `button_to` to destroy an object.

## Phase II: Notes

* Add a `Note` model. Users can take a `Note` on any `Track`.
  * _i.e._ `Note`s will belong to a `User` and a `Track`.
* On the `Track` show page, display the track's `Note`s.
* Write a `notes/_note.html.erb` partial.
* Also, put a `Note` form on the show page. On submit of a new `Note`,
  redirect back to the `Track`.
* Add destroy buttons for notes, too.

## Phase III: Additional Authentication Features

Spam-bots keep signing up for our inventory management application. Let's defeat them by sending out
an activation email. We'll ask users to click a link to activate their account when they sign up.

* On signup, send the user an email (via [ActionMailer][actionmailer-curriculum]).
    * The email should contain a link to activate the new account.
    * We'll need an `activated` boolean field on the user table to track the
      status of user accounts.
      * Accounts should start out deactivated.
      * We should add a check to see if a user is active before
        logging them in.
    * To activate the accounts, we'll add an `activation_token` column.
    * In the email, add a URL to `/users/activate?activation_token=...`.
    * Add a custom route for a new action like `UsersController#activate`.
      * You can use the [`collection`][adding-routes-rails-guides] method
        to do add additional routes to the users resources.
    * This custom controller action, `UsersController#activate`,
      should verify that the user clicked the link in their email. If
      the token in the query string matches with the token in the
      database, it should activate the account and flip the boolean.
      **Hint**: You can use [ActiveRecord's toggle method][ar-toggle] to elegantly
      flip the value of a boolean attribute.

[actionmailer-curriculum]:  ../w4d5/mailing-1.md
[adding-routes-rails-guides]: http://guides.rubyonrails.org/v3.2.13/routing.html#adding-more-restful-actions
[ar-toggle]: http://api.rubyonrails.org/classes/ActiveRecord/Persistence.html#method-i-toggle

## Bonus Ideas

Great work! Here are some bonus features to add to our inventory application.

### Bonus I: Admin Accounts

Let's add admin accounts for people from our record label.
This way our PR department can remove notes that don't reflect well on our properties.

* Add an `admin` boolean to the user table.
  * Only admin users should be allowed to create/update/destroy inventory objects or notes.
    * Hide the links from regular users, and make sure to check if
      someone is an admin using a before filter on admin-only
      controller actions.
  * Users should be able to destroy their own notes.
    * Start tracking the author of notes to enable this, _i.e._ `notes` belong to a `user`.
* Add a `users` index only visible to admin users.
  * Put a button next to each user which, when clicked, makes that user an admin.

### Bonus II: Helpers

In a fit of poor judgment, you have decided to display your lyrics
like this, with a music note before every line:

```
♫ And I was like baby, baby, baby, oh
♫ Like baby, baby, baby, no
♫ Like baby, baby, baby, oh
♫ I thought you'd always be mine, mine
```

Write and use a helper `ugly_lyrics(lyrics)` that will:

* break up the lyrics on newlines
* insert a ♫ at the start of each line (the html entity that will render as a
  music note is `&#9835;`)
* properly escape the user input
* wrap the lyrics in a [`pre` tag][pre-tag] so that the newlines are
  respected (in a`<pre>` or _preformatted text tag_,
  whitespace is preserved)
* mark the produced HTML as safe for insertion (otherwise your `<pre>` tag will
  get escaped when you insert it into the template)

[pre-tag]:https://developer.mozilla.org/en-US/docs/Web/HTML/Element/pre

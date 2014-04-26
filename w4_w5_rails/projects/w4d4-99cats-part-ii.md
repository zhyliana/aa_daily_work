# 99 Cats II: Auth

Today we add a world of `users`

## Phase IV: Users

### Add a `User` model

* Store the `User`'s `user_name` and `password_digest`.
    * As ever, toss on necessary constraints and validations.
* Also create a `session_token` column.
    * Go ahead and require the session token to be present. This means
      you'll need a `before_validation` callback to set the token if it's
      not already set.
    * Go ahead and add a unique index.
* Write yourself a `User#reset_session_token!` method. Go on, you're
  worth it! Use yourself a `SecureRandom` to generate a token.
* Write a `#password=(password)` setter method that writes the
  `password_digest` attribute with the hash of the given password.
* Write a `#is_password?(password)` method that verifies a password.
* Write a `::find_by_credentials(user_name, password)` method that
  returns the user with the given name if the password is correct.

### `UsersController`, `SessionsController`

* To allow signup, write a `UsersController` with `new`/`create`
  actions. Add appropriate routes.
* Build a `SessionsController`.
    * Add a singular session resource.
    * There is at most one session in the user's life; they don't need
      to have routes to address multiple sessions.
    * Write a `new` form that has the user input their username
      and password.
* In `SessionsController#create`:
    * Verify the `user_name`/`password`.
    * (Re)set the `User`'s `session_token`.
    * Update the `session`.
* Redirect the user to the cats index.

### Using the session

* In the `SessionsHelper`, write a method `current_user` that looks up
  the user with the current session token.
    * This lets you use the method in any view.
    * Since you'll want to use this method in your controllers, you
      can `include` the module in `ApplicationController`, too. This
      is a common trick.
* Add a destroy action to your `SessionsController`.
    * Blank out the token in the cookie.
    * Call `#reset_session_token!` on the `User` to invalidate the old
      token.
    * This is good practice in case someone has stolen our token in
      the past.
* Edit the layout so that at the top the user's name is displayed, or
  an invitation to log in.
    * Thanks for being so welcoming!
* Add a logout button to the top if the user is signed in.
* Be a dear and login in the user on sign-up of a new user. Probably
  want to factor out shared code (with `SessionsController#create`) to
  a `login_user!` method in `SessionsHelper`.
* In the User and Session controllers, use a `before_action` callback to 
redirect the user to the cats index if the user tries to visit the 
login/signup pages when already signed in.

### CSRF time!

* You may not have been uploading the `form_authenticity_token`. Now
  is the time! You need to do this or else whenever you post a form
  you'll get logged out. Frustration!
* You might as well throw it on every form.

## Phase V: Users own cats

* Add a `user_id` column and association to `cats`. As ever, index
  the foreign key. Add needed validations.
* Add `owner` and `cats` associations.
* In the create action of the `CatsController`, set the `user_id` with
  the current user's id.
    * Note that you **do not** need a hidden field for this.
    * Ask your TA why that would be insecure.
* In the `CatsController` `edit`/`update` actions, make sure the
  editor owns the cat.
    * Use a `before_action` callback to accomplish this.
    * Do a `redirect_to` in the filter if the user is not authorized.
    * Note that redirection from inside a before filter cancels
      further processing of the request. The action will never be
      called.
* Do likewise for `CatRentalRequestsController`; only the owner should
  be able to approve/deny.
* On the cat show page, don't show the approve/deny buttons unless the
  user owns the cat.
* Add a `user_id` column to `CatRentalRequest`. Set up the `belongs_to`
  and `has_many` associations between `CatRentalRequest` and `User`.
    * Don't forget to add database constraints and model validations.
* Be sure to assign the `current_user`'s ID to the rental request's
  `user_id` in the `CatRentalRequestController`'s create action.
* Display the requesting user's username next to each rental request
  on the cat show page.

## Bonus

Your cat rental request app is becoming very popular! Your users want to
be able to login to your app from multiple browsers and devices at the same
time.

* Once you think you know how to implement this, call your TA over
and explain it.

* Change your app so you can login from multiple devices. (you can test 
this using Chrome incognito).

* Implement functionality so that logging out from one browser won't log them
  out from other devices. 

* Allow users to see everywhere they're logged in and let them log out of each
  individually. 
    * Give them information about each session so they know if they're logging
      out of their iPad or computer. Hint: `request.env`
    * Pro status: Tell them where (physically) they logged in. 
      Hint: geocoder gem & `request.remote_ip`

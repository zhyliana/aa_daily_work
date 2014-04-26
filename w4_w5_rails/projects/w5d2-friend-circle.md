# Social Thingamajig

## Phase I: `User`, `UsersController` and `SessionsController`

* Sign up (`email` instead of `username`), log in, log out. Go.
  *(Use [BCrypt][bcrypt], please - we want our fake users to have some peace
  of mind)*
  
[bcrypt]: https://github.com/codahale/bcrypt-ruby

## Phase IB: Forgot password
* Allow users to reset their password.
* Use [ActionMailer][mailer] to send a link to the user. This link will reset their password.
    * You probably want to use the [letter_opener][letter-opener] gem for testing.
* Once you have a strategy thought out for implementing password reset, call over a TA to review your plan
* Make sure you don't allow users to reset other people's passwords!

[mailer]: https://github.com/appacademy/rails-curriculum/blob/master/w4d5/mailing-1.md
[letter-opener]: https://github.com/ryanb/letter_opener

## Phase II: `FriendCircle`

* Allow users to create a `FriendCircle` to share with.
* Allow them to select other `User`s to put in the friend circle.
    * To start, present check-boxes.
    * Upload an array of `*_ids`.
    * Make sure each of your form inputs has a unique `id` attribute.
    * You can ensure this by embedding the `user.id` in the attribute
      name.
* You'll probably want a join table, `friend_circle_memberships`. A user
  can be part of many circles and a circle has many members.
* Remember to `permit` your `*_ids` attribute in the controller,
  since the `FriendCirclesController` could mass-assign it on
  `FriendCircle` creation. Take a look at the "Methods added by
  has_many" section in the Rails Guide on associations.

## Phase III: `Post` and `Link`s

*[Nested form time!][nested-form]*

Users will be making posts which they will share with friend circles
that they select. Each post will have many links, and we'll be
creating the post and the links all in one form.

* Allow `User`s to make a `Post`.
* They can select multiple of their `FriendCircle`s to share the new post with
  (checkboxes).
    * You'll probably want a join table, `post_shares`, to connect a
      `Post` with multiple `FriendCircle`s.
    * Again, ensure each checkbox input tag has a unique HTML id.
* Each `Post` has a body, which is a description of the collection of
  links.
* Each `Post` also has a collection of associated `Link`s. `Link`
  should be its own model class.
* A user will POST the post data and the link data together to the same
  controller action. Ensure the links data and the post data are named well `params[:post]` & `params[:links]` so that you can use transactions in your create action.
* Allow the user to submit up to three `Link`s to start (i.e. display
  3 nested forms for links).
    * The user may not want to upload as many as three links so make
      sure you don't create empty link objects.

[nested-form]: ./w5d2/nested-forms.md
## Phase IIIB: Editing `FriendCircle`

Use your old form so that you can edit a `FriendCircle`. Factor it out
into a partial for reuse. Allow the user to return and re-edit the
circle.

Obviously, embed the current attributes in the edit form. Don't make
the user type in all the attributes again.

The user may wish to remove members of the `FriendCircle`. What about
if you uncheck all the `User`s from the `FriendCircle`? Try it.

The problem is that if no users are selected, then the form has
nothing to upload for `user_ids`. Instead of uploading an empty array
for `user_ids`, it just doesn't upload anything at all. That means
that in the `update` action, if we call
`FriendCircle#update_attributes`, `user_ids` won't appear among the
attributes to update, so it will remain unchanged.

The solution is to add a "bumper" hidden input:

    <input type="hidden" name="friend_circle[user_ids][]" value="">

This way the form will always upload **at least** one value for
`firend_circle[user_ids]`: `""`. `user_ids=` will ignore the `""` value:
`user_ids = [1, 2, ""]` will add memberships for users \#1 and
\#2. `user_ids = [""]` will clear all memberships.

You need to use this trick whenever you have checkboxes that you want to
be able to uncheck to indicate a deletion.

## Phase IV: Feed

A user should be able to see all the posts shared with them.

Use the `PostShare` model you created earlier.

* Create a `/feed` route
* It should display the items shared with the current user
  (posts with bodies and associated links, along with the
  author of that post)

## Phase V: Making Sign-Up fun!

Let's make the sign up process a bit more frustra -- fun!

Edit your sign-up page to give a user an opportunity to create their
first post along with the usual body and links.

User has many posts, and a post has many links. Double nesting!

[NESTED FORM INCEPTION][inception]

[inception]: http://www.youtube.com/watch?v=1khghXRGb6k

## Later Functionality

* Upvoting
* [Pagination][kaminari]
* Comments
* Password reset

[kaminari]: https://github.com/amatsuda/kaminari


# Layering on Contacts

We're going to continue building on the API we built in the
FirstRoutesAndControllers project.

Our goal is to build an application to store your email contacts. Your
users will be able to send requests to our API in order to create and
share contacts, as well as retrieve their stored contact information.

## Phase I: Data Layer

You almost always start with the data layer when you're thinking about
adding functionality. What pieces of data are necessary to implement
the functionality you need? What changes need to be made to the
database schema? What models do you need? What associations and
validations?

**User**

* One column: `username`
* Enforce presence and uniqueness of `username` at both ActiveRecord
  and DB levels.

**Contact**

* Columns:
    * `name`
    * `email`
    * `user_id`
* All of these should be present; add ActiveRecord and DB level
  checks.
* Enforce that `email` be unique at both levels. A single user
  can't have two contacts that share an email address. Two different
  users can each have contacts that have the same email address, but
  a single user cannot have two contacts that are the same. This means
  that the `user_id` and `email` combination must be unique.
* Add associations between `User` and `Contact`. Call the association
  from `Contact` to `User` `owner`.
* Add an index on `user_id` so that we can quickly get all the
  contacts for a user

**ContactShare**

* Columns:
    * `contact_id`
    * `user_id`
* Ensure that both are present. Add the two levels of
  validations/constraints.
* Ensure that a user can't have two shares for the same contact. Add
  two levels of validation/constraint.
* Add associations from `ContactShare` to both `Contact` and
  `User`. Add associations in the other direction.
* Add through associations from `Contact` to `shared_users` and `User`
  to `shared_contacts`.
* Lastly, add indices to `ContactShare`'s foreign key columns for fast
  lookup.

Play around in the Rails console to ensure that you can create `User`,
`Contact`, and `ContactShare` models. Ensure that your associations
work.

## Phase II: API Layer: `UsersController`, `ContactsController`

Next you usually move to the API layer: how you will be **exposing**
your data, specifying how the outside world can interact with it.

First, build out your `User` controller actions. You'll want:

* `user_params` helper method
    * should be private
    * requires the key `:user` in params, and permits each of the user attributes as keys in the nested hash.
* `create` (POST `/users`)
    * Using uploaded parameters (use `user_params`), build a new `User`
      object and try to save it.
    * Remember to use `if @user.save` to check if validations passed.
    * On error, render validation errors using
      `@user.errors.full_messages`.
* `destroy` (DELETE `/users:id`)
    * Find the user (use `params[:id]`) and destroy the object.
    * Traditionally you render the destroyed user
* `index` (GET `/users`)
    * Render all the users in the DB.
* `show` (GET `/users/:id`)
    * Render a single user, fetched by `params[:id]`.
* `update` (PATCH `/users/:id`)
    * Find the requested user (`params[:id]`)
    * Use `update_attributes` with `user_params` to do a
      mass-assignment update and save.
    * Render validation errors using `@user.errors.full_messages`.

In the `routes.rb` file, use the `:only` option for `resources` to
restrict to just these 6 of 8 default routes.

Next, move on to creating `ContactsController`. Build the same six
actions. Your code should look very similar, but practice this a
second time.

Next, use RestClient or Chrome's Postman plugin to test your API. Test
every API endpoint.

**Hint**: For this project, do not write any authentication or
authorization logic. When creating a new `contact`, require the
uploader submit their `user_id`. This isn't secure because anyone
could always take your `user_id` and upload new contacts in your name.
For now, let's assume all the users of our service aren't malicious
:-)

## Adding `ContactShare`

Add a new collection resource and a controller for
`ContactShare`s. Add an action to `create` a `ContactShare`; you'll
want to upload the `contact_id` and the `user_id` to share with.
Also, remember to use strong parameters (`params[:contact_share].permit(
:attribute_here, :another_attribute_here)`).

Add a `destroy` action that will un-share a `Contact` with a
`User`. To delete a share, the user should issue a DELETE to
`/contact_shares/123`, where `123` is the id of the `ContactShare` to
destroy.

Both routes should conventionally render the created/destroyed
`ContactShare` for a response.

We won't need any of the other routes yet.

## Getting a `User`'s `Contact`s: nested routes

Right now a GET to `/contacts` gets all of the contacts in the
system. That's probably too many: we probably want to only fetch the
`Contact`s of a particular user.

Let's add a new, nested resource, `/users/:user_id/contacts`, so that
we can get the contacts for a given user. We'll only need the `index`
action for this nested resource.

You may remove the `index` action from the top-level `contacts`
resource. We'll modify our API so that you can't download all the
contacts in one go, but instead only per-user. You will be able to get
user 1's contacts through `GET /users/1/contacts`, user 2's through
`GET /users/2/contacts`, etc.

The nested resource will still hit the `ContactsController`. Rewrite
the `index` method to return (a) the `Contact`s owned by a user plus
(b) the `Contact`s shared with the user. You can access the specified
user through `params[:user_id]` because it is part of the nested
route.

To do this, write a helper class method
`Contact::contacts_for_user_id(user_id)`. Write this using one query:
use a LEFT OUTER JOIN to join `contacts` with `contact_shares`,
selecting contacts where (a) the contact is owned by the user or (b) a
contact share exists for the user.

## Bonus

Implement these (thinking about sensible routes for each):

* Try out [polymorphic associations][poly-assoc] by making a comments model that can belong to 
either a user or a contact.  A user should be able to comment on a contact, or comment on another user.
 
* Favorite contacts. This will require adding additional columns to contacts and shared contacts. Also, we should use a nice custom route to accomplish this. [Hint.][more-restful-actions]

[poly-assoc]: http://guides.rubyonrails.org/association_basics.html#polymorphic-associations
[concerns-for-models]: http://signalvnoise.com/posts/3372-put-chubby-models-on-a-diet-with-concerns
[more-restful-actions]: http://guides.rubyonrails.org/v3.2.14/routing.html#adding-more-restful-actions
* Contact groups
    * A user can have many groups
    * Contacts can belong to more than one group
* Comments on contacts
    * Watch out for shared contacts! 
    * A user should only be able to see his own comments 

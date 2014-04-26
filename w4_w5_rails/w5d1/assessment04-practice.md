# Practice for Assessment 4

## Topics it will cover

This assessment will be your first test of your full-stack Rails
knowledge. You'll have to integrate the knowledge you've acquired
over the past 1.5 weeks.

Be comfortable with both the data (Database) & logic (Model) layers,
along with the API layer (routers, controllers, views).

* Controllers
* Routing
* Simple Views
    * No partials
    * No helpers
* Forms
    * Label
    * Text
    * Radio
    * Submit
    * Select/Option
    * Attributes: type, id/for, name, value
    * Know how to use `_method` 
    * Know how to use the CSRF token.
* Authentication & Authorization
    * User model with session token
    * SessionsController, singular route, new/create/destroy actions.
    * You won't need bcrypt; you can store plaintext passwords
    * You'll need SecureRandom to generate a session token
* No ActionMailer

## Preparation

The best thing you can do to prepare is to review Wednesday and Thursday's
projects. Better yet, rebuild them from scratch. And/or, do the project
specified below.

## Practice Project

This app will have users and followers. You should be able to create
a user, sign in as a user, follow other users, and have other users
follow you. This should take 2hrs.

* Profile page
  * Should see a list of people user is following and people who
    are following that user.
  * Profile page should be protected so only that user can see his/her
    own list of followers and followees.
* Sign-up
  * Should submit a name, username, and password on sign-up and have
    it create a new user
* Sign-in
  * Make a SessionsController
  * Submit username and password on sign-in
* FollowingsController
  * Should see a list of all users with buttons to follow
  * Follow buttons should not be shown for people the user is
    already following. Instead, show unfollow button.

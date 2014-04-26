#Authentication Checklist#

0. make sure you have `bcrypt` in gemfile
0. create user model with password digest and session token
0. add `#password=` and `is_password?` to `User`
0. add a `::find_by_credentials` method to `User`
0. add a `::find_by_session_token` method to `User`
0. add validations to `User`
0. create `UsersController`
0. add methods for new/creation
0. make views for creating new user
0. add `SessionsController`
0. make views for logging in existing user
0. add routes for the `:session` resource
0. add methods to log in user, log out user, and `current_user`
0. make sure methods are available as *helper methods* 

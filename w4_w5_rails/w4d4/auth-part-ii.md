# Authentication II: Creating Sessions

In this project, we will refer to the [NewAuthDemo][new-auth-demo]
project. We pick up from the previous work.

[new-auth-demo]: https://github.com/appacademy-demos/NewAuthDemo

## Overview

We are now successfully creating users. Let's start logging them in,
too.

We're going to create a (singular) resource named `session`. When the
user logs in, they'll go to `/session/new` to fill in their
credentials. POSTing to `/session` (to the `SessionsController#create`
action) will sign the user in; we'll store a **session token** in the
cookie so that subsequent requests will know which user is logged
in. Lastly, to log out, the client can issue a DELETE request to
`/session`.

A couple notes:

* There is no `Session` class, nor `sessions` table. This doesn't
  mean we can't write a `session` resource.
* The `session` resource is singular because the user will only use at
  most one session: their own.
* We'll write a `SessionsController`; even when using a singular
  resource, controllers are **always** pluralized.

## Phase IV: Logging in: verifying credentials

### Adding a `session` resource, `SessionsController`

Add a `session` resource to the routes file. Generate a
`SessionsController`. Write a `new` form so that the user can fill out
their username/password:

```html+erb
<!-- app/views/sessions/new.html.erb -->
<h1>Sign In</h1>

<form action="<%= session_url %>" method="post">
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

  <input type="submit" value="Log in">
</form>
```

**Remember to include the form authenticity token!**

Okay; but what about the create action?

### Adding `::find_by_credentials`

Okay, we need to write `SessionsController#create` so that it verifies
the username/password and then builds/sets a session token. Let's add
a `find_by_credentials` method:

```ruby
class User < ActiveRecord::Base
  # ...

  def self.find_by_credentials(username, password)
    user = User.find_by_username(username)
    return nil if user.nil?
    user.is_password?(password) ? user : nil
  end

  # ...
end
```

This will only return a user if the username/password is correct.

Let's try this out in our controller:

```ruby
class SessionsController < ApplicationController
  def create
    user = User.find_by_credentials(
      params[:user][:username],
      params[:user][:password]
    )

    if user.nil?
      render :json => "Credentials were wrong"
    else
      render :json => "Welcome back #{user.username}!"
    end
  end

  def new
  end
end
```

Cool! But this is useless, because the sessions controller doesn't set
any cookie to remember the logged-in user.

## Phase V: Logging in: setting the session

We now have the `SessionsController` properly verifying the user's
credentials, but it doesn't actually do anything with the successful
login. Let's fix that.

### Add a `UsersController#show` page

Make a very simple `show` view for your `UsersController`.

```html+erb
<!-- app/views/users/show.html.erb -->
<h1><%= @user.username %></h1>

<p>Hello, dear user!</p>
```

Let's edit the `#create` method in `UsersController` and
`SessionsController` to redirect to this page on successful form
submission.

Let's begin making the show page private; a user should be the only
one allowed to look at their own `users#show` page. But before we
start, we need to start setting a session token...

### Adding `session_token` to `User`

We're going to need to introduce a `session_token` so that after login
we can remember the current user. Let's write a migration:

```ruby
class AddSessionTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :session_token, :string, :null => false
    add_index :users, :session_token, :unique => true
  end
end
```

Next, let's make sure that when we create a `User` it has a
`session_token`:

```ruby
class User < ActiveRecord::Base
  # ...

  validates :session_token, :presence => true
  after_initialize :ensure_session_token

  def self.generate_session_token
    SecureRandom::urlsafe_base64(16)
  end

  # ...

  def reset_session_token!
    self.session_token = self.class.generate_session_token
    self.save!
  end

  private
  def ensure_session_token
    self.session_token ||= self.class.generate_session_token
  end
end
```

Note that the `User` now validates the presence of the
`session_token`. Note that we'll conveniently generate a session token
for the `User` if one isn't already set (that's the `after_initialize`
callback bit).

### Setting the session

We're now storing the session token in the `User`, but we need to also
store it in the `session`. Let's write helper methods in the `SessionsHelper` module:

```ruby
module SessionsHelper
  def current_user=(user)
    @current_user = user
    session[:session_token] = user.session_token
  end

  def current_user
    return nil if session[:session_token].nil?
    @current_user ||= User.find_by_session_token(session[:session_token])
  end
end
```

To be able to use these helper methods throughout any controller,
`include SessionsHelper` in the `ApplicationController`.

And let's update our `SessionsController` and `UsersController`
create methods:

```ruby
class SessionsController < ApplicationController
  def create
    user = User.find_by_credentials(
      params[:user][:username],
      params[:user][:password]
    )

    if user.nil?
      render :json => "Credentials were wrong"
    else
      self.current_user = user
      redirect_to user_url(user)
    end
  end

  # ...
end

class UsersController < ApplicationController
  def create
    @user = User.new(params[:user])

    if @user.save
      self.current_user = @user
      redirect_to user_url(@user)
    else
      render :json => @user.errors.full_messages
    end
  end

  # ...
end
```

## Phase VI: Using the `current_user`

### Adding a logout button

We haven't written any logout functionality, nor do we ever tell the
user who they are logged in as. Let's fix that by editing the
application's layout:

```html+erb
<!-- app/views/layouts/application.html.erb -->

<!-- ... -->
<% if !current_user.nil? %>
  <ul>
    <li>Logged in as: <%= current_user.username %></li>
    <li><%= button_to "Logout", session_url, :method => :delete %></li>
  </ul>
<% end %>

<%= yield %>

</body>
</html>
```

Now, after we log in, we should be able to see the logout button. But
we don't have a destroy action yet. Let's write one:

```ruby
module SessionsHelper
  # ...

  def logout_current_user!
    current_user.reset_session_token!
    session[:session_token] = nil
  end
end

class SessionsController < ApplicationController
  # ...

  def destroy
    logout_current_user!
    redirect_to new_session_url
  end

  # ...
end
```

Now sign out should be working. Notice that in `logout_current_user!`
we reset the session token. This will invalidate the old session
token. We want to do that in case anyone has managed to steal the
token; this will deny the thieves further access to the account.

### Adding a `before_action` callback

Let's finally finish what we started: let's protect the `users#show`
page so that only the user themselves can view their own show.

To do that, let's write a `require_current_user!` helper:

```ruby
module SessionsHelper
  # ...

  def require_current_user!
    redirect_to new_session_url if current_user.nil?
  end
end
```

We can then add this as a `before_action` callback in our controllers:

```ruby
class UsersController < ApplicationController
  before_action :require_current_user!, :except => [:create, :new]

  # ...
end
```

Notice that I except the `create` and `new` actions; those are needed
before a user is signed up, so there's no way for them to be logged in
at that point.

A rule of `before_action` is that, if in the process of running a
filter `redirect_to` is called, the action method will not be
called. For instance, if a user tries to visit the `users#show` page
without having logged in first, the callback will issue a redirect, and
Rails will forgo calling the `UsersController#show` method.

### Wait one more second

The callback we defined requires that a user be logged in to look at a
`users#show` page. However, it does not enforce that user A may not
look at user B's show page. Write a new filter in the
`UsersController` to do this.


Filters
-------

Filters are methods that are run before, after or "around" a
controller action.

Filters are inherited, so if you set a filter on
`ApplicationController`, it will be run on every controller in your
application.

Before filters may halt the request cycle. A common before filter is
one which requires that a user is logged in for an action to be
run. You can define the filter method this way:

```ruby
class ApplicationController < ActionController::Base
  before_filter :require_login

  private

  def require_login
    unless logged_in?
      flash[:error] = "You must be logged in to access this section"
      redirect_to new_login_url # halts request cycle
    end
  end

  # The logged_in? method simply returns true if the user is logged
  # in and false otherwise. It does this by "booleanizing" the
  # current_user method we created previously using a double ! operator.
  # Note that this is not common in Ruby and is discouraged unless you
  # really mean to convert something into true or false.
  def logged_in?
    !!current_user
  end
end
```

The method simply stores an error message in the flash and redirects
to the login form if the user is not logged in. If a before filter
renders or redirects, the action will not run. If there are additional
filters scheduled to run after that filter they are also cancelled.

In this example the filter is added to `ApplicationController` and
thus all controllers in the application inherit it. This will make
everything in the application require the user to be logged in in
order to use it. For obvious reasons (the user wouldn't be able to log
in in the first place!), not all controllers or actions should require
this. You can prevent this filter from running before particular
actions with `skip_before_filter`:

```ruby
class LoginsController < ApplicationController
  skip_before_filter :require_login, only: [:new, :create]
end
```

Now, the `LoginsController`'s `new` and `create` actions will work as
before without requiring the user to be logged in. The `:only` option
is used to only skip this filter for these actions, and there is also
an `:except` option which works the other way. These options can be
used when adding filters too, so you can add a filter which only runs
for selected actions in the first place.

### After Filters and Around Filters

In addition to before filters, you can also run filters after an
action has been executed, or both before and after.

After filters are similar to before filters, but because the action
has already been run they have access to the response data that's
about to be sent to the client. Obviously, after filters cannot stop
the action from running.

Around filters are responsible for running their associated actions by
yielding, similar to how Rack middlewares work.

For example, in a website where changes have an approval workflow an
administrator could be able to preview them easily, just apply them
within a transaction:

```ruby
class ChangesController < ActionController::Base
  around_filter :wrap_in_transaction, only: :show

  private

  def wrap_in_transaction
    ActiveRecord::Base.transaction do
      begin
        yield
      ensure
        raise ActiveRecord::Rollback
      end
    end
  end
end
```

Note that an around filter also wraps rendering. In particular, if in
the example above, the view itself reads from the database (e.g. via a
scope), it will do so within the transaction and thus present the data
to preview.

You can choose not to yield and build the response yourself, in which
case the action will not be run.

### Other Ways to Use Filters

While the most common way to use filters is by creating private
methods and using *_filter to add them, there are two other ways to do
the same thing.

The first is to use a block directly with the *_filter methods. The
block receives the controller as an argument, and the `require_login`
filter from above could be rewritten to use a block:

```ruby
class ApplicationController < ActionController::Base
  before_filter do |controller|
    redirect_to new_login_url unless controller.send(:logged_in?)
  end
end
```

Note that the filter in this case uses `send` because the `logged_in?`
method is private and the filter is not run in the scope of the
controller. This is not the recommended way to implement this
particular filter, but in more simple cases it might be useful.

The second way is to use a class (actually, any object that responds
to the right methods will do) to handle the filtering. This is useful
in cases that are more complex and can not be implemented in a
readable and reusable way using the two other methods. As an example,
you could rewrite the login filter again to use a class:

```ruby
class ApplicationController < ActionController::Base
  before_filter LoginFilter
end

class LoginFilter
  def self.filter(controller)
    unless controller.send(:logged_in?)
      controller.flash[:error] = "You must be logged in"
      controller.redirect_to controller.new_login_url
    end
  end
end
```

Again, this is not an ideal example for this filter, because it's not
run in the scope of the controller but gets the controller passed as
an argument. The filter class has a class method `filter` which gets
run before or after the action, depending on if it's a before or after
filter. Classes used as around filters can also use the same `filter`
method, which will get run in the same way. The method must `yield` to
execute the action. Alternatively, it can have both a `before` and an
`after` method that are run before and after the action.

Request Forgery Protection
--------------------------

Cross-site request forgery is a type of attack in which a site tricks
a user into making requests on another site, possibly adding,
modifying or deleting data on that site without the user's knowledge
or permission.

The first step to avoid this is to make sure all "destructive" actions
(create, update and destroy) can only be accessed with non-GET
requests. If you're following RESTful conventions you're already doing
this. However, a malicious site can still send a non-GET request to
your site quite easily, and that's where the request forgery
protection comes in. As the name says, it protects from forged
requests.

The way this is done is to add a non-guessable token which is only
known to your server to each request. This way, if a request comes in
without the proper token, it will be denied access.

If you generate a form like this:

```erb
<%= form_for @user do |f| %>
  <%= f.text_field :username %>
  <%= f.text_field :password %>
<% end %>
```

You will see how the token gets added as a hidden field:

```html
<form accept-charset="UTF-8" action="/users/1" method="post">
<input type="hidden"
       value="67250ab105eb5ad10851c00a5621854a23af5489"
       name="authenticity_token"/>
<!-- fields -->
</form>
```

Rails adds this token to every form that's generated using the
[form helpers](form_helpers.html), so most of the time you don't have
to worry about it. If you're writing a form manually or need to add
the token for another reason, it's available through the method
`form_authenticity_token`:

The `form_authenticity_token` generates a valid authentication
token. That's useful in places where Rails does not add it
automatically, like in custom Ajax calls.

The [Security Guide](security.html) has more about this and a lot of
other security-related issues that you should be aware of when
developing a web application.

HTTP Authentications
--------------------

Rails comes with two built-in HTTP authentication mechanisms:

* Basic Authentication
* Digest Authentication

### HTTP Basic Authentication

HTTP basic authentication is an authentication scheme that is
supported by the majority of browsers and other HTTP clients. As an
example, consider an administration section which will only be
available by entering a username and a password into the browser's
HTTP basic dialog window. Using the built-in authentication is quite
easy and only requires you to use one method,
`http_basic_authenticate_with`.

```ruby
class AdminController < ApplicationController
  http_basic_authenticate_with name: "humbaba", password: "5baa61e4"
end
```

With this in place, you can create namespaced controllers that inherit
from `AdminController`. The filter will thus be run for all actions in
those controllers, protecting them with HTTP basic authentication.

### HTTP Digest Authentication

HTTP digest authentication is superior to the basic authentication as
it does not require the client to send an unencrypted password over
the network (though HTTP basic authentication is safe over
HTTPS). Using digest authentication with Rails is quite easy and only
requires using one method, `authenticate_or_request_with_http_digest`.

```ruby
class AdminController < ApplicationController
  USERS = { "lifo" => "world" }

  before_filter :authenticate

  private

  def authenticate
    authenticate_or_request_with_http_digest do |username|
      USERS[username]
    end
  end
end
```

As seen in the example above, the
`authenticate_or_request_with_http_digest` block takes only one
argument - the username. And the block returns the password. Returning
`false` or `nil` from the `authenticate_or_request_with_http_digest`
will cause authentication failure.

Streaming and File Downloads
----------------------------

Sometimes you may want to send a file to the user instead of rendering
an HTML page. All controllers in Rails have the `send_data` and the
`send_file` methods, which will both stream data to the
client. `send_file` is a convenience method that lets you provide the
name of a file on the disk and it will stream the contents of that
file for you.

To stream data to the client, use `send_data`:

```ruby
require "prawn"
class ClientsController < ApplicationController
  # Generates a PDF document with information on the client and
  # returns it. The user will get the PDF as a file download.
  def download_pdf
    client = Client.find(params[:id])
    send_data generate_pdf(client),
              filename: "#{client.name}.pdf",
              type: "application/pdf"
  end

  private

  def generate_pdf(client)
    Prawn::Document.new do
      text client.name, align: :center
      text "Address: #{client.address}"
      text "Email: #{client.email}"
    end.render
  end
end
```

The `download_pdf` action in the example above will call a private
method which actually generates the PDF document and returns it as a
string. This string will then be streamed to the client as a file
download and a filename will be suggested to the user. Sometimes when
streaming files to the user, you may not want them to download the
file. Take images, for example, which can be embedded into HTML
pages. To tell the browser a file is not meant to be downloaded, you
can set the `:disposition` option to "inline". The opposite and
default value for this option is "attachment".

### Sending Files

If you want to send a file that already exists on disk, use the
`send_file` method.

```ruby
class ClientsController < ApplicationController
  # Stream a file that has already been generated and stored on disk.
  def download_pdf
    client = Client.find(params[:id])
    send_file("#{Rails.root}/files/clients/#{client.id}.pdf",
              filename: "#{client.name}.pdf",
              type: "application/pdf")
  end
end
```

This will read and stream the file 4kB at the time, avoiding loading
the entire file into memory at once. You can turn off streaming with
the `:stream` option or adjust the block size with the `:buffer_size`
option.

If `:type` is not specified, it will be guessed from the file
extension specified in `:filename`. If the content type is not
registered for the extension, `application/octet-stream` will be used.

WARNING: Be careful when using data coming from the client (params,
cookies, etc.) to locate the file on disk, as this is a security risk
that might allow someone to gain access to files they are not meant to
see.

TIP: It is not recommended that you stream static files through Rails
if you can instead keep them in a public folder on your web server. It
is much more efficient to let the user download the file directly
using Apache or another web server, keeping the request from
unnecessarily going through the whole Rails stack.

### RESTful Downloads

While `send_data` works just fine, if you are creating a RESTful
application having separate actions for file downloads is usually not
necessary. In REST terminology, the PDF file from the example above
can be considered just another representation of the client
resource. Rails provides an easy and quite sleek way of doing "RESTful
downloads". Here's how you can rewrite the example so that the PDF
download is a part of the `show` action, without any streaming:

```ruby
class ClientsController < ApplicationController
  # The user can request to receive this resource as HTML or PDF.
  def show
    @client = Client.find(params[:id])

    respond_to do |format|
      format.html
      format.pdf { render pdf: generate_pdf(@client) }
    end
  end
end
```

In order for this example to work, you have to add the PDF MIME type
to Rails. This can be done by adding the following line to the file
`config/initializers/mime_types.rb`:

```ruby
Mime::Type.register "application/pdf", :pdf
```

NOTE: Configuration files are not reloaded on each request, so you
have to restart the server in order for their changes to take effect.

Now the user can request to get a PDF version of a client just by
adding ".pdf" to the URL:

```bash
GET /clients/1.pdf
```

Rescue
------

Most likely your application is going to contain bugs or otherwise
throw an exception that needs to be handled. For example, if the user
follows a link to a resource that no longer exists in the database,
Active Record will throw the `ActiveRecord::RecordNotFound` exception.

Rails' default exception handling displays a "500 Server Error"
message for all exceptions. If the request was made locally, a nice
traceback and some added information gets displayed so you can figure
out what went wrong and deal with it. If the request was remote Rails
will just display a simple "500 Server Error" message to the user, or
a "404 Not Found" if there was a routing error or a record could not
be found. Sometimes you might want to customize how these errors are
caught and how they're displayed to the user. There are several levels
of exception handling available in a Rails application:

### The Default 500 and 404 Templates

By default a production application will render either a 404 or a 500
error message. These messages are contained in static HTML files in
the `public` folder, in `404.html` and `500.html` respectively. You
can customize these files to add some extra information and layout,
but remember that they are static; i.e. you can't use RHTML or layouts
in them, just plain HTML.

### `rescue_from`

If you want to do something a bit more elaborate when catching errors,
you can use `rescue_from`, which handles exceptions of a certain type
(or multiple types) in an entire controller and its subclasses.

When an exception occurs which is caught by a `rescue_from` directive,
the exception object is passed to the handler. The handler can be a
method or a `Proc` object passed to the `:with` option. You can also
use a block directly instead of an explicit `Proc` object.

Here's how you can use `rescue_from` to intercept all
`ActiveRecord::RecordNotFound` errors and do something with them.

```ruby
class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  private

  def record_not_found
    render text: "404 Not Found", status: 404
  end
end
```

Of course, this example is anything but elaborate and doesn't improve
on the default exception handling at all, but once you can catch all
those exceptions you're free to do whatever you want with them. For
example, you could create custom exception classes that will be thrown
when a user doesn't have access to a certain section of your
application:

```ruby
class ApplicationController < ActionController::Base
  rescue_from User::NotAuthorized, with: :user_not_authorized

  private

  def user_not_authorized
    flash[:error] = "You don't have access to this section."
    redirect_to :back
  end
end

class ClientsController < ApplicationController
  # Check that the user has the right authorization to access clients.
  before_filter :check_authorization

  # Note how the actions don't have to worry about all the auth stuff.
  def edit
    @client = Client.find(params[:id])
  end

  private

  # If the user is not authorized, just throw the exception.
  def check_authorization
    raise User::NotAuthorized unless current_user.admin?
  end
end
```

NOTE: Certain exceptions are only rescuable from the
`ApplicationController` class, as they are raised before the
controller gets initialized and the action gets executed. See Pratik
Naik's [article](http://m.onkey.org/2008/7/20/rescue-from-dispatching)
on the subject for more information.

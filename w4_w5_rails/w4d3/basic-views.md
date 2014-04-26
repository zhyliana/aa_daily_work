# Basic views

## Overview: How the Pieces Fit Together

This guide focuses on the interaction between controller and view in
the Model-View-Controller triangle. As you know, the controller is
responsible for orchestrating the handling of a request, though it
will try to delegate as much work as it can to the model layer. When
it's time to send a response back to the user, the controller hands
things off to the view. It's that handoff that is the subject of this
guide.

Views are responsible for **presentation logic**: the controller
decides what model data to fetch in response to a request, but it
leaves it to the view layer to decide how to present that data to the
user. Typically, this means **rendering** (building) HTML to send back
to the client browser.

## Creating Responses

From the controller's point of view, there are two main ways to create
an HTTP response:

* Call `render` to create a full response to send back to the browser.
* Call `redirect_to` to ask the client to make a new HTTP request for
  a different resource.

### Rendering a template

Here is a `BooksController` action that will fetch all the `Book`s
from the model layer and return them in an array. It then calls
`render`, which will cause a **view template** to be rendered. The
view template contains a mix of static HTML and dynamic Ruby code
that, when evaluated, will become the response sent back to the
client.

```ruby
# app/controllers/books_controller.rb
class BooksController < ApplicationController
  def index
    @books = Book.all

    render :index
  end
end
```

The `render` method is passed the name of a template (`:index`) to
render. This will tell Rails to look for the template
`app/views/books/index.html.erb`, fill it out, and return it to the
user. **Instance variables set in the controller will be made
available to the view template:**

```html+erb
<!-- app/views/books/index.html.erb -->
<h1>Listing Books</h1>

<ul>
  <% @books.each do |book| %>
    <li>
      <%= "#{book.author}: #{book.title}" %>
    </li>
  <% end %>
</ul>
```

Embedded Ruby (ERB) is a templating language which lets us mix Ruby
code with HTML. We'll learn more about it in a bit.

### Avoiding Double Render Errors

Sooner or later, most Rails developers will see the error message "Can
only render or redirect once per action". While this is annoying, it's
relatively easy to fix. Usually it happens because of a simple
misunderstanding of the way that `render` works.

For example, here's some code that will trigger this error:

```ruby
def show
  @book = Book.find(params[:id])
  if @book.special?
    render :special_show
  end

  render :regular_show
end
```

If `@book.special?` evaluates to `true`, Rails will render the
`special_show` view. But this will **not** stop the rest of the code
in the `show` action from running, and when Rails hits the end of the
action, it will start to render the `regular_show` view - and throw an
error. The solution is simple: make sure that you have only one call
to `render` or `redirect_to` in a single code path. Here's a fixed
version of the method:

```ruby
def show
  @book = Book.find(params[:id])
  if @book.special?
    render :special_show
  else
    render :regular_show
  end
end
```

This will render a book with `special?` set with the `special_show`
template, while other books will render with a `regular_show`
template.

Think about it. `render` is just a controller method. Calling it won't
jump out of your `show` method code. Only the special `return` keyword
could do that.

## Using `redirect_to`

Another way to respond to an HTTP request is with `redirect_to`.

As you've seen, `render` tells Rails to evaluate a view template or
convert a data object to JSON/XML and ask the result to be shipped
back to the user. The `redirect_to` method does something completely
different: it tells Rails to ask the browser to send a **new request**
for a different URL. For example, you could ask the browser to request
the index of photos with this call:

```ruby
redirect_to photos_url
```

Here's the series of steps involved when a redirect issued:

0. **First Request Cycle**:
    0. The initial request from the client is sent to the server. For
       instance, perhaps the client POSTs some data to `/blog_entries`
    0. In the `BlogEntries#create` action, the controller stores the
       blog entry in the database (`Blog.create(params[:blog_entry])`.
    0. The controller then **issues a redirect**, instructing the
       client to make a new GET request for `/blogs/123`. No true
       content is sent in response to this first request.
0. **Second Request Cycle**:
    0. The client honors the redirect response by making a new
       GET request for `/blogs/123`
    0. The server looks up `Blog.find(params[:id])`. It renders the
       `:show` template and sends the response back to the client.
    0. At this point, the user has finally received the HTML
       representation of the blog entry they just created.

### Back

You can use any of the URL helpers you read about previously in the
routing chapter. There's also a special redirect that asks the
browsers to go back to the page they just came from:

```ruby
redirect_to :back
```

Redirects are often used at the end of create, destroy, and update
actions - the resource has been created (for example) and now you
want to take the user to the show page for that resource, which you'll
do with a redirect.

### The Difference Between `render` and `redirect_to`

It is typical to `render` a view with the same name as the controller
action. Sometimes we wish to render another action's view:

```ruby
class BooksController
  def index
    @books = Book.all

    render :index
  end

  def show
    @book = Book.find_by_id(params[:id])
    if @book.nil?
      # couldn't find the book; maybe just show the index again?
      flash[:errors] << "Couldn't find book!"
      redirect_to books_url
      return
    end

    render :show
  end
end
```

Here if the `show` is called but the book cannot be found, we will ask
the client to make a new request for the index. This involves a second
request.

Consider this subtle (and inferior) variation:

```ruby
class BooksController
  def index
    @books = Book.all

    render :index
  end

  def show
    @book = Book.find_by_id(params[:id])
    if @book.nil?
      flash.now[:errors] << "Couldn't find book!"
      render :index
    else
      render :show
    end
  end
end
```

This is different. Instead of asking the client to make a new request,
we render the index view in response to the first (and only) request:
the request to `GET /books/:id`. This involves no second request.

Though we will see times when we wish to do this, this is probably not
desirable in this case. First, when the user is redirected, the url
bar is updated to `/books`; in the render case, the url bar will
remain, say, `/books/17877`, even though that book doesn't exist and
the index is being displayed.

Also, the view template presumably expects `@books` to be set so that
it can list all the books, but this will not be set by the `show`
method. The `render` method **will not call** the
`BooksController#index` method. It only causes the view named
`index.html.erb` to be rendered. Thus the `show` method should have at
least set `@books` before calling `render :index`.

It's worth noting that neither does `redirect_to books_url` (directly)
call the index method. It only asks the client to make a new request
for `/books`; this second request will then invoke the index action.

We will see that the most common case for rendering another action's
view template is in the case of handling form errors. Otherwise this
is seldom done.

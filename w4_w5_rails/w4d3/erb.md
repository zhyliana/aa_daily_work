# Templates

As we've discussed, controllers cause templates to be rendered by
calling the `render` method. But how are templates structured? Answer:
with HTML and ERB (and love!).

## ERB (embedded Ruby)

Templates consist of HTML, but they are augmented with Ruby code. ERB
templates are pretty simple:

* `<% ruby_code_here %>` executes Ruby code that does not return
  anything. For example, conditions, loops or blocks.
* `<%= %>` is used when you want to embed the return value into the
  template. i.e. Something that will actually show up in the HTML.

For example:

```html+erb
<b>Names of all the people</b>
<ul>
  <% ["Tom", "Dick", "Harry"].each do |name| %>
    <li>
      Name: <%= name %>
    </li>
  <% end %>
</ul>
```

The loop is setup in regular embedding tags `<% %>` and the name is
written using the output embedding tag `<%= %>`. Output functions like
`print` or `puts` won't work with ERB templates. So this would be
wrong:

```html+erb
<!-- WRONG -->
Hi, Mr. <% puts "Frodo" %>
```

It's important to note that the ERB is simply helping construct HTML
server-side.  When the view is finished rendering, it will be pure
HTML and it is the pure HTML when it is sent out to the user. Your
user will never know you are using ERB.

### Commenting out ERB

Say you want to comment out some broken Ruby code in your ERB file
that's throwing an error:

```html+erb
<!-- <%= my_broken_ruby_code %> -->
```

Even though you wrap the embedded Ruby in an HTML comment, the Ruby
code will still be evaluated (and inserted as the body of the
comment). If the code was erroring out previously, it will still be
run and will still call errors.

To stop the code from running, simply add a `#`. So:

```html+erb
<%#= my_broken_ruby_code %>
```

The `%#` means to not evaluate the embedded Ruby. The '=' is dangling.

## Instance variables

Controllers make data available to the view layer by **setting
instance variables**. It may seem a bit silly that this is the
mechanism by which data is shared since instance variables are all
about keeping private data, but that's how Rails does it. When the
view is rendered, it copies over the instance variables of the
controller so that it has access to them; the view cannot otherwise
get access to the controller or its attributes.

Let's give a full example:

```ruby
# app/controllers/products_controller.rb
class ProductsController < ActionController::Base
  def index
    # get an array of all products, make it available to view
    @products = Product.all
  end
end
```

```html+erb
<!-- app/views/products/index.html.erb -->
<h1>All the products!</h1>
<ul>
  <% @products.each do |product| %>
    <li>
      <%= product.name %>
    </li>
  <% end %>
</ul>
```

It is good practice to make all your database queries inside the
controller, setting the results to instance variables. Never make
database queries in your views; it can make it harder to find hidden
performance issues caused by unintended queries.

## `link_to` and `button_to`

To help us generate HTML, we may use **helper** methods. We'll talk
about writing our own helpers in a later chapter, but first we'll talk
about the two most commonly used helper methods provided by Rails.

You may have seen `link_to` around before; it generates the HTML code
for a link. Here's a few uses:

```html+erb
<%= link_to "Cat Pictures", "http://cashcats.biz" %>
<a href="http://cashcats.biz">Cat Pictures</a>

<%= link_to "New Application", new_application_url %>
<a href="www.example.com/applications/new">New Application</a>
```

When a user clicks on an anchor tag, a `GET` request is issued. If you
want to issue a `POST`, `PATCH`, or `DELETE` request, you can use a
button and specify the method:

```html+erb
<%= button_to "Delete post", application_url(@application), :method => :delete %>
```

Technically you can specify the `:method` attribute for `link_to`, but
you should reserve `a` tags for GET requests. We'll talk about why
later. If you want to issue a `POST`/`PATCH`/`DELETE`, use a button.

Do not rely on these helper methods blindly. Always look at the HTML
they generate. You should be able to write the same HTML yourself, if
necessary. You'll have to when we start doing JS and Backbone.

Often you want to send some parameters along with the request; for
instance, you want to make a `POST` request to create a new
`Application`, passing in the applicant's name, city, etc. To do this,
we want to create an HTML **form**; we'll learn how to do this in a
later chapter.

When it suffices to send parameters in the query string, recall from
the routing chapter that you can do this like so: `xyz_url(:key =>
:value)`.

See the [URLHelper docs][url-helper-docs] for more info on `link_to`
and `button_to`.

## Resources

* [URLHelper docs][url-helper-docs]

[url-helper-docs]: http://api.rubyonrails.org/classes/ActionView/Helpers/UrlHelper.html

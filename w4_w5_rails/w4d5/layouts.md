# Layouts

When Rails renders a view as a response, it does so by inserting the
rendered template into a **layout** to form the complete
response. This lets us focus on writing the page-specific information
in the template, and not duplicate surrounding data like the `<html>`,
`<head>`, etc tags, any header, navbar, or footer structure. You might
also load site-wide JavaScript in the layout.

Layouts live in `app/views/layouts`; here's the default
`application.html.erb` layout:

```html+erb
<!DOCTYPE html>
<html>
<head>
  <title>Testapp1</title>
  <%= stylesheet_link_tag    "application", media: "all", "data-turbolinks-track" => true %>
  <%= javascript_include_tag "application", "data-turbolinks-track" => true %>
  <%= csrf_meta_tags %>
</head>
<body>

<%= yield %>

</body>
</html>
```

## Understanding `yield`

Within the context of a layout, `yield` identifies a section where
content from the view should be inserted. The simplest way to use this
is to have a single `yield`, into which the entire contents of the
view currently being rendered is inserted (see above).

You can also create a layout with multiple yielding regions:

```html+erb
<html>
  <head>
  <%= yield :head %>
  </head>
  <body>
  <%= yield %>
  </body>
</html>
```

The main body of the view will always render into the unnamed
`yield`. To render content into a named `yield`, you use the
`content_for` method.

The `content_for` method allows you to insert content into a named
`yield` block in your layout. For example, this view would work with
the layout that you just saw:

```html+erb
<% content_for :head do %>
  <title>A simple page</title>
<% end %>

<p>Hello, Rails!</p>
```

The result of rendering this page into the supplied layout would be
this HTML:

```html+erb
<html>
  <head>
  <title>A simple page</title>
  </head>
  <body>
  <p>Hello, Rails!</p>
  </body>
</html>
```

The `content_for` method is very helpful when your layout contains
distinct regions such as sidebars and footers that should get their
own blocks of content inserted. It's also useful for inserting tags
that load page-specific JavaScript or CSS files into the header of an
otherwise generic layout.

## Asset tags

Layouts are typically responsible for directing the browser to load
site-wide JavaScript and CSS. JavaScript and CSS source are not
(typically) embedded in the HTML response; instead, the HTML contains
`<script>` and `<link>` tags in the header that direct the browser to
make subsequent requests for the JS and CSS files to load.

For instance, to direct the client to load `common.js`, you would use
the `javascript_include_tag` helper:

```ruby
javascript_include_tag "common"
# => <script src="/assets/common.js"></script>
```

Likewise, to tell the browser to use the css file `application.css`,
you would use `stylesheet_link_tag`:

```ruby
stylesheet_link_tag "application"
# => <link href="/assets/application.css" media="screen" rel="stylesheet" />
```

As you can see, both of these tags direct the browser to fetch another
resource from the server. When we learn about the **asset pipeline**,
we'll learn where these files are stored (`app/assets`) and how to add
your own JS/CSS files.

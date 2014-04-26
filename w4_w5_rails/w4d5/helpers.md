# View helpers

When we write our view templates, we try to keep them DRY like our
code. We've seen that we can do this using partials. Rails gives us a
another tool: view helpers.

View helpers are Ruby methods that can be called from your view. The
job of view helpers is to hold **view specific** code that DRYs up
templates. The most popular view helper is `link_to`. Other common
helpers are for building forms (`form_for`), including assets
(`javascript_include_tag`), etc. We'll see plenty more Rails helpers
in our time.

We can also write our own helpers: they are stored in
`app/helpers/#{controller}_helper.rb`. Any view logic that will be
repeated should be broken out to a helper method.

It's common to write helper methods for repeated chunks of HTML you
might use all over the place. Some examples might be to highlight a
string, format a quote correctly, or display a user picture.

```ruby
# app/helpers/application_helper.rb
module ApplicationHelper
  def highlight(text)
    "<strong class=\"highlight\">#{h(text)}</strong>".html_safe
  end

  def picture_for(user)
    html = "<div class=\"user-picture\">"
    html += "<img src=\"#{user.picture_url}\" alt=\"#{h(user.name)}\">"
    html += "</div>"

    html.html_safe
  end
end
```

You can then use these helpers in all your views:

```html+erb
<!-- app/views/cats/show.html.erb -->
<p>
  How can one not like <%= highlight "cats" %>? They are my favorite!
</p>

<%= picture_for @cat %>
```

You should really lean on helpers to keep your templates clean and
readable. View partials are useful for breaking up repeated larger
bits of code, but repeated snippets of a few lines are best stored in
helpers.

To organize your helper methods, Rails lets you make as many helper
module files as necessary. They go in the folder `app/helpers`. All
the methods in these modules will be available in every view; even
something in `app/helpers/user_helpers` will be available in a
`app/views/posts` view. You may put non-specifc helper methods in the
`ApplicationHelper` module Rails has generated for you.

## Escaping HTML

Rails escapes all HTML when it prints out content in ERB tags.

```html+erb
<%= '<p>This paragraph tag will be escaped</p>' %>
<!--
Outputs: &lt;p&gt;This paragraph tag will be escaped&lt;/p&gt;
-->
```

This prevents user generated HTML from sneaking into the page. It's
the same idea as how `?` in a SQL query is meant to protect against a
SQL injection attack. This prevents HTML injection.

The main problem with HTML injection is that a malicious user might
add JavaScript code to the page which could then start making
undesired API requests on behalf of the user.

When making helper methods that generate HTML for us this becomes
problematic. Your helper builds up a string, which should be inserted
into the HTML unescaped.

Fortunately, Rails added a `.html_safe` method to the String class,
which lets us bypass the escaping. Any string marked `html_safe` will
not be escaped when inserted into a view.

```html+erb
<%= '<p>This will NOT be escaped</p>'.html_safe %>
<!--
Outputs: <p>This will NOT be escaped</p>
-->
```

So, for instance:

```ruby
# app/helpers/application_helper.rb
module ApplicationHelper
  def highlight(text)
    "<strong class=\"highlight\">#{text}</strong>".html_safe
  end
end
```

wouldn't work without `html_safe`.

However, we're now at risk of an injection attack. Do we trust `text`?
Could that come from the user? What if they try something sneaky?

Just like there is a way to mark a string as HTML safe so that it
won't be escaped when inserted into a template, there's a way to
escape an HTML unsafe string: you use the `html_escape` method (an
alias, `h` is conveniently short and thus more common):

```ruby
# app/helpers/application_helper.rb
module ApplicationHelper
  def highlight(text)
    "<strong class=\"highlight\">#{h(text)}</strong>".html_safe
  end
end
```

You can read more [here][erb-util-doc].

[erb-util-doc]: http://api.rubyonrails.org/classes/ERB/Util.html

## Capturing a block in ERB

Sometimes we want to pass a lot of content into a helper. To do this,
you can pass in a block:

```html+erb
<%= long_quote("_whytheluckystiff") do %>
  <p>
    All you need to know thus far is that Ruby is basically built from
    sentences. They aren’t exactly English sentences. They are short
    collections of words and punctuation which encompass a single
    thought.
  </p>
  
  <p>
    Look ma, a <%= link_to "link",
    "http://en.wikipedia.org/wiki/Why_the_lucky_stiff" %>
  </p>
  
  <p>
    These sentences can form books. They can form pages. They can form
    entire novels, when strung together. Novels that can be read by
    humans, but also by computers.
  </p>
<% end %>
```

Alright, let's do it! Rails lets us render the blocks using the
[`capture`][rails-api-capture] method.

```ruby
def long_quote(author, &block)
  text = capture(&block)

  html = "<blockquote cite=\"#{h(author)}\">"
  html += text
  html += "</blockquote>"
  
  html.html_safe
end
```

[rails-api-capture]: http://api.rubyonrails.org/classes/ActionView/Helpers/CaptureHelper.html#method-i-capture

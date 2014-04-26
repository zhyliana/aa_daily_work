# Collections and hidden fields

Many forms will require selecting a choice from among many options. This is
typically done with an HTML `select` tag:

```html
<form action="http://99cats.com/cats" method="post">
  <label for="cat_coat_color">Coat color</label>
  <!-- dropdown -->
  <select name="cat[coat_color]">
    <!-- `brown` is the value that will be submitted to the server; user is
         displayed "Brown" as the choice -->
    <option value="brown">Brown</option>
    <option value="black">Black</option>
    <option value="blue">Blue</option>
  </select>
  <br>

  <input type="submit" value="Create cat">
</form>
```

## `FormBuilder#collection_select`

`FormBuilder#collection_select` provides a way:

```html+erb
<%= form_for(@cat) do |f| %>
  <!-- ... -->
  
  <%=
    f.select(
      :coat_color,
      [["Brown", "brown"], ["Black", "black"],
      ["Blue", "blue"]]
    )
   %>
  
  <%= f.submit "Create cat!" %>
<% end %>
```

This will present a dropdown of colors (Brown, Black, Blue). Selecting one of
these options will upload the associated value ("brown", "black", "blue").

Say we want to select the owner for a `Cat`; `Cat` has an attribute,
`owner_id`. We may do this:

```html+erb
<%= form_for(@cat) do |f| %>
  <!-- ... -->
  
  <%= f.select :owner_id, User.all.map { |user| [user.full_name, user.id] } %>
  
  <%= f.submit "Create cat!" %>
<% end %>
```

This will present `User#full_name` to the user; the value uploaded is the
`User`'s id. Because this is common, `FormBuilder#collection_select` helps
out:

```html+erb
<%= form_for(@cat) do |f| %>
  <!-- ... -->
  
  <%= f.collection_select :owner_id, User.all, :id, :full_name %>
  
  <%= f.submit "Create cat!" %>
<% end %>
```

The last two parameters (`id` and `full_name`) are the names of methods that
will be called on each member of the collection (`User.all`) to generate the
values and text names.

## `hidden_field`

Hidden fields are used to store attributes that the user is not responsible
for inputting. Let's take a simple example:

```html+erb
<!-- app/views/post/show.html.erb -->
<h1><%= @post.title %></h1>

<div class="contents">
  <%= @post.html_content %>
</div>

<!--
  Option hash passed to a url helper will be used to generate the query
  string.
  -->
<%= link_to "Add comment", new_comment_url(:post_id => @post.id) %>
```

When a user clicks to comment on the `Post`, he is directed to a path like
`/comments/new?post_id=101`. By embedding the post id in the query string,
the `CommentsController#new` method will know what post we're talking about.

```ruby
class CommentsController
  def new
    @comment = Comment.new(:post_id => params[:post_id])
  end
end
```

This will store the post id in the `Comment` object. Here's the form:

```html+erb
<%= form_for(@comment) do |f| %>
  <%= f.hidden_field :post_id %>
  <%= f.text_area :body %>
  
  <%= f.submit "Post!" %>
<% end %>
```

The hidden field will not be displayed, or editable by the casual
user. It is otherwise submitted like any other field. We need to
include it because when the form is submitted and POSTed to
`/comments`, the `CommentsController` needs to continue to remember
what `Post` this `Comment` is intended for. This way,
`params[:comment][:post_id]` is set
properly. `Comment.new(params[:comment])` will create a comment which
refers to the proper `Post`.

NB: a knowledgable user can trivially edit your hidden field; you must
not rely on its value being unmodified. More generally, the user can
POST whatever he likes to your server; you must not rely on the format
of the form to protect against a malicious user.

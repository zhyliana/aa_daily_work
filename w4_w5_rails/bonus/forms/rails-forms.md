# Rails Forms: Basics

We've seen how to build HTML forms. HTML forms can be tedious to write, but
Rails helps us by providing the `form_for` method and `FormBuilder` helper:

Here's a `BlogEntry` form:

```ruby
class BlogEntriesController < ActionController
  def new
    # a blank blog entry to fill out
    @blog_entry = BlogEntry.new
  end

  def create
    @blog_entry = BlogEntry.create!(params[:blog_entry])
    redirect_to blog_entry_url(@blog_entry)
  end
end
```

```html+erb
<!-- app/views/blog_entries/new.html.erb -->
<%= form_for(@blog_entry) do |f| %>
  <%= f.label :title %>
  <%= f.text_field :title %>
  <br>
  
  <%= f.label :body %>
  <%= f.text_area :body %>
  <br>
  
  <%= f.submit "Blog it down!" %>
<% end %>
```

### Setting up the `form` tag

In the `new` action, we build a new, blank `BlogEntry`. In the view, we pass
it to the `form_for` method. `form_for` will setup a `form` tag. `form_for`
will look to see if `blog_entry.persisted?`; if the `blog_entry` is new
(not persisted), `form_for` will submit using `POST`. If the `blog_entry`
already exists (and we are editing it), it will use `PUT`.

After choosing the `method` attribute, `form_for` will choose the `action`
URL. Again, if the model is new, it will POST to the inferred create action
(`/blog_entries`); if this is an update to an existing record, it PUTs to
`/blog_entries/:id`.

**NB**: A common error to see when using `form_for` is "undefined method
'model_name' for NilClass:Class". This happens if you forget to set the
instance variable `@blog_entry`. In that case `@blog_entry` is `nil`, so
`@blog_entry.class` is `NilClass`. `form_for` expects a subclass of
`ActiveRecord::Base` to be passed in; `NilClass` doesn't have the AR method
`model_name`, which causes the error.

### Setting up the `input` tags

`form_for` sets up the `form` tag, but we are responsible for describing the
`input` tags we want. `form_for` passes a `FormBuilder` into the block (we
name it `f` in the example). We use `f` to direct it to add `label`s and
`input`s.

An annoyance of writing forms was setting the `name`s of all the `input`
attributes. `FormBuilder` does this work for us; it will namespace the
`input`s with the model's class name.

## Important `FormBuilder` methods

Simple ones:

* `f.password_field name`
* `f.text_area name`
* `f.text_field name`
* `f.label name, text`
* `f.date_select name`
* `f.submit value`

More complex ones:

* `f.radio_button name, value`
    * You may define several of these with the same name
    * To make a label for a radio button, use `f.label name, text, :value =>
      value`
* `f.hidden_field name`
    * Not displayed to the user.
* `f.collection_select(name, collection, value_method, text_method)`
    * More on this later

## `form_for` and re-rendering a form on errors

Have you ever filled out a form, and then been forced to re-fill it when
there are errors? **That sucks**. To solve this, a typical new/create pair in
Rails looks like this:

```ruby
class BlogEntriesController < ActionController
  def new
    # a blank blog entry to fill out
    @blog_entry = BlogEntry.new
  end

  def create
    @blog_entry = BlogEntry.new(params[:blog_entry])
    if @blog_entry.save
      # validation success
      redirect_to blog_entry_url(@blog_entry)
    else
      # validation fail; re-render the "new" view again
      render :new
    end
  end
end
```

`form_for` does this one final service for us. If, upon form submission,
validations fail and the user is required to resubmit the form, we want to
re-display the form, populated with the user's (erroneous) submission. The
`create` method builds a new `BlogEntry` with the uploaded attributes
(`params[:blog_entry]`), storing it in the instance variable `@blog_entry`.

When validations fail, we will render the "new" view again. As before, this
will run `form_for(@blog_entry)`. But `form_for` will access `@blog_entry`'s
attributes to pre-populate the input tags. The re-rendered form returned to
the client will already be filled out with their previous, though erroneous
submission.

## References

* [FormHelper][form-helper-docs]
* [FormBuilder][form-builder-docs]

[form-helper-docs]: http://api.rubyonrails.org/classes/ActionView/Helpers/FormHelper.html
[form-builder-docs]: http://api.rubyonrails.org/classes/ActionView/Helpers/FormBuilder.html

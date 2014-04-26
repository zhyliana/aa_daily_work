Displaying Validation Errors in the View
----------------------------------------

**TODO**: this chapter needs review.

[DynamicForm](https://github.com/joelmoss/dynamic_form) provides
helpers to display the error messages of your models in your view
templates.

You can install it as a gem by adding this line to your Gemfile:

```ruby
gem "dynamic_form"
```

Now you will have access to the two helper methods `error_messages`
and `error_messages_for` in your view templates.

### `error_messages` and `error_messages_for`

When creating a form with the `form_for` helper, you can use the
`error_messages` method on the form builder to render all failed
validation messages for the current model instance.

```ruby
class Product < ActiveRecord::Base
  validates :description, :value, :presence => true
  validates :value, :numericality => true, :allow_nil => true
end
```

```erb
<%= form_for(@product) do |f| %>
  <%= f.error_messages %>
  <p>
    <%= f.label :description %><br />
    <%= f.text_field :description %>
  </p>
  <p>
    <%= f.label :value %><br />
    <%= f.text_field :value %>
  </p>
  <p>
    <%= f.submit "Create" %>
  </p>
<% end %>
```

If you submit the form with empty fields, the result will be similar
to the one shown below:

![Error messages][error-messages]

NOTE: The appearance of the generated HTML will be different from the
one shown, unless you have used scaffolding. See
[Customizing the Error Messages CSS](#customizing-the-error-messages-css).

You can also use the `error_messages_for` helper to display the error
messages of a model assigned to a view template. It is very similar to
the previous example and will achieve exactly the same result.

```erb
<%= error_messages_for :product %>
```

The displayed text for each error message will always be formed by the
capitalized name of the attribute that holds the error, followed by
the error message itself.

Both the `form.error_messages` and the `error_messages_for` helpers
accept options that let you customize the `div` element that holds the
messages, change the header text, change the message below the header,
and specify the tag used for the header element. For example,

```erb
<%= f.error_messages :header_message => "Invalid product!",
  :message => "You'll need to fix the following fields:",
  :header_tag => :h3 %>
```

results in:

![Customized error messages][customized-error-messages]

If you pass `nil` in any of these options, the corresponding section
of the `div` will be discarded.

### Customizing the Error Messages CSS

The selectors used to customize the style of error messages are:

* `.field_with_errors` - Style for the form fields and labels with errors.
* `#error_explanation` - Style for the `div` element with the error messages.
* `#error_explanation h2` - Style for the header of the `div` element.
* `#error_explanation p` - Style for the paragraph holding the message that appears right below the header of the `div` element.
* `#error_explanation ul li` - Style for the list items with individual error messages.

If scaffolding was used, file
`app/assets/stylesheets/scaffolds.css.scss` will have been generated
automatically. This file defines the red-based styles you saw in the
examples above.

The name of the class and the id can be changed with the `:class` and
`:id` options, accepted by both helpers.

### Customizing the Error Messages HTML

By default, form fields with errors are displayed enclosed by a `div`
element with the `field_with_errors` CSS class. However, it's possible
to override that.

The way form fields with errors are treated is defined by
`ActionView::Base.field_error_proc`. This is a `Proc` that receives
two parameters:

* A string with the HTML tag
* An instance of `ActionView::Helpers::InstanceTag`.

Below is a simple example where we change the Rails behavior to always
display the error messages in front of each of the form fields in
error. The error messages will be enclosed by a `span` element with a
`validation-error` CSS class. There will be no `div` element enclosing
the `input` element, so we get rid of that red border around the text
field. You can use the `validation-error` CSS class to style it anyway
you want.

```ruby
ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  errors = Array(instance.error_message).join(',')
  %(#{html_tag}<span class="validation-error">&nbsp;#{errors}</span>).html_safe
end
```

The result looks like the following:

![Validation error messages][validation-error-messages]

[error-messages]: http://guides.rubyonrails.org/images/error_messages.png
[customized-error-messages]: http://guides.rubyonrails.org/images/customized_error_messages.png
[validation-error-messages]: http://guides.rubyonrails.org/images/validation_error_messages.png

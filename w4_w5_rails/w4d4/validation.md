# Validation
For sundry reasons, data saved to the database need to be validated. Model level validations are the most common, but validations can be created on the client side in javascript, or controller level validations. Database constraints can also be added to the database to prevent bad input. 

Performing the validations at the model level has these benefits:
* Database agnostic
* Convenient to test and maintain
* Nice, specific, per-field error messages

ActiveRecord::Base instance methods that run validations:
* `#create`
* `#create!`
* `#save`
* `#save!`
* `#update`
* `#update_attributes`
* `#update_attributes!`

## Model-Level Validation
Lets consider the `User` class with basic validations for username and password.

```ruby
class User < ActiveRecord::Base
  validates :username, :password, :presence => true
  validates :password, :length => { :minimum => 6 }
end
```

So if we run 
```ruby
u = User.new(:username => "Billy Bob")
u.save
```

`u.save` will run validations. After completing the validations the `u.errors` attribute will contain a hash with all of the errors, by attribute.

`=> { :password => ["can't be blank", "is too short (minimum is 6 characters)"]}`

## `flash` vs `flash.now`
Data stored in `flash` will be available to the next controller action and can be used when redirecting.

Data stored in `flash.now` will only be available in the view currently being rendered by the `render` method.

[Flash Hash][flash-api]

[flash-api]: http://api.rubyonrails.org/classes/ActionDispatch/Flash/FlashHash.html

## Rendering Errors
One common way to render errors is to store them in `flash[:errors]` after running validation, then displaying them on the page by iterating through each of the errors displaying each of them.

By following the construct of always storing `obj.errors.full_messages` in `flash[:errors]` a partial can be rendered with the flash errors on each of the forms.

### Controller
Lets make a simple controller that will store any validation errors in a `flash[:errors]` array.

```ruby
def create
  @user = User.new(params[:user])
  if @user.save
    flash[:notice] = "Success!"
    redirect_to user_url(@user)
  else
    # sweet! now my flash.now[:errors] will be full of informative errors!
    flash.now[:errors] = @user.errors.full_messages
    render :new
  end
end
```


### View
When the new or edit pages are rendered, also render a list of all of the errors if any.

```html
<!-- layouts/_errors.html.erb -->
<% if flash.now[:errors] %>
  <% flash.now[:errors].each do |error| %>
   <%= error %><br />
  <% end %>
<% end %>

<!-- views/users/new.html.erb -->
<%= render :partial => "layouts/errors" %>

<!-- views/users/edit.html.erb -->
<%= render :partial => "layouts/errors" %>
```

Notice how trivial it is to add the list of errors to future new/edit pages by using a partial.

## Resources
* [Rails Guides - Validations][rails-guides-validations]
* [4h of error messages][error-4h]

[rails-guides-validations]: http://edgeguides.rubyonrails.org/active_record_validations.html
[error-4h]: http://uxmas.com/2012/the-4-hs-of-writing-error-messages

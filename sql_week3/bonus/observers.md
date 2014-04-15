# Extra credit: Observers

[Observers][obs-doc] are similar to callbacks, but with important
differences. Whereas callbacks can pollute a model with code that
isn't directly related to its purpose, observers allow you to add the
same functionality without changing the code of the model. For
example, it could be argued that a `User` model should not include
code to send registration confirmation emails. Whenever you use
callbacks with code that isn't directly related to your model, you may
want to consider creating an observer instead.

Observers aren't very different from callbacks, they are more about
code organization and simplifying model logic.

[obs-doc]: http://api.rubyonrails.org/classes/ActiveRecord/Observer.html

### Creating Observers

For example, imagine a `User` model where we want to send an email
every time a new user is created. Because sending emails is not
directly related to our model's purpose, we should create an observer
to contain the code implementing this functionality.

```bash
$ rails generate observer User
```

generates `app/models/user_observer.rb` containing the observer class
`UserObserver`:

```ruby
class UserObserver < ActiveRecord::Observer
end
```

You may now add methods to be called at the desired occasions:

```ruby
class UserObserver < ActiveRecord::Observer
  def after_create(model)
    # code to send confirmation email...
  end
end
```

As with callback classes, the observer's methods receive the observed
model as a parameter.

### Registering Observers

Observers are conventionally placed inside of your `app/models`
directory and registered in your application's `config/application.rb`
file. For example, the `UserObserver` above would be saved as
`app/models/user_observer.rb` and registered in
`config/application.rb` this way:

```ruby
# Activate observers that should always be running.
config.active_record.observers = :user_observer
```

As usual, settings in `config/environments` take precedence over those
in `config/application.rb`. So, if you prefer that an observer doesn't
run in all environments, you can simply register it in a specific
environment instead.

### Sharing Observers

By default, Rails will simply strip "Observer" from an observer's name
to find the model it should observe. However, observers can also be
used to add behavior to more than one model, and thus it is possible
to explicitly specify the models that our observer should observe:

```ruby
class MailerObserver < ActiveRecord::Observer
  observe :registration, :user

  def after_create(model)
    # code to send confirmation email...
  end
end
```

In this example, the `after_create` method will be called whenever a
`Registration` or `User` is created. Note that this new
`MailerObserver` would also need to be registered in
`config/application.rb` in order to take effect:

```ruby
# Activate observers that should always be running.
config.active_record.observers = :mailer_observer
```

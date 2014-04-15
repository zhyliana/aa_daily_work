# Validations II: Custom Validations

When the built-in validation helpers are not enough for your needs,
you can write your own **validation methods** or **validator
classes**.

## Custom Methods

With validation methods, you can write your own methods to validate a
model.

```ruby
class Invoice < ActiveRecord::Base
  # validate tells the class to run these methods at validation time.
  validate :discount_cannot_be_greater_than_total_value

  private
  def discount_cannot_be_greater_than_total_value
    if discount > total_value
      errors[:discount] << "can't be greater than total value"
    end
  end
end
```

Note that the presence of an error is registered by adding a message
to the `errors` hash. If no error messages are added, the validation
is deemed to have passed. Note that the message does not mention the
variable name; when you call `full_messages`, Rails will prefix the
message with the attribute name for you.

### `errors[:base]`

Sometimes an error is not specific to any one attribute. In this case,
you add the error to `errors[:base]`. Since `errors[:base]` is an
array, you can simply add a string to it and it will be used as an
error message.

```ruby
class Person < ActiveRecord::Base
  def a_method_used_for_validation_purposes
    errors[:base] << "This person is invalid because ..."
  end
end
```

## Custom Validators

Custom validators are classes that extend
`ActiveModel::EachValidator`. Prefer writing a custom validator class
when you want to reuse validation logic for **multiple models or
multiple columns**. Otherwise, it's simpler to use a validator method.

Your custom validator class must implement a `validate_each` method
which takes three arguments: the record, the attribute name and its
value.

```ruby
# app/validators/email_validator.rb
class EmailValidator < ActiveModel::EachValidator
  CRAZY_EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i

  def validate_each(record, attribute_name, value)
    unless value =~ CRAZY_EMAIL_REGEX
      # we can use `EachValidator#options` to access custom options
      # passed to the validator.
      message = options[:message] || "is not an email"
      record.errors[attribute_name] << message
    end
  end
end

# app/models/person.rb
class Person < ActiveRecord::Base
  # Rails knows `:email` means `EmailValidator`.
  validates :email, :presence => true, :email => true
  # not required, but must also be an email
  validates :backup_email, :email => {:message => "isn't even valid"}
end
```

As shown in the example, you can also combine standard validations
with your own custom validators.

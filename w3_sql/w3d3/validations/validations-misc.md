# Validations III: Misc

## `VARCHAR` and `length` validations

When you run a migration specifying a string field, the database will
create a `VARCHAR` column. Rails will use a default length of 255
characters. That means that you will not be able to insert strings of
greater than 255 characters in length.

If you try to insert a value longer than 255 characters, Active Record
won't care until the DB complains. Because the error will occur at the
DB level, AR won't have marked your record as `#invalid?`, and you
won't get anything useful in `#errors`. Instead, you get a nasty
exception on `#save`:

```
ActiveRecord::StatementInvalid (PGError: ERROR:  value too long for type character varying(255)
```

For this reason, you'll probably want to add a `length` validation,
which will catch the problem at the AR level before going to the
DB. Other options are to raise the VARCHAR length, or use a `TEXT`
field with no limit (but worse performance).

```ruby
# some urls get mighty long
t.string :url, :limit => 1024
# some people go on and on...
t.text :comments
```

## Common Validation Options

These are a few common validation options which can be applied to most
validation helpers.

### `:allow_nil`/`:allow_blank`

The `:allow_nil` option skips the validation when the value being
validated is `nil`.

```ruby
class Coffee < ActiveRecord::Base
  validates :size, :inclusion => { :in => %w(small medium large),
    :message => "%{value} is not a valid size" }, :allow_nil => true
end
```

The `:allow_blank` option is similar to the `:allow_nil` option. This
option will let validation pass if the attribute's value is `blank?`,
like `nil` or an empty string for example.

```ruby
class Topic < ActiveRecord::Base
  validates :title, :length => { :is => 5 }, :allow_blank => true
end

Topic.create("title" => "").valid?  # => true
Topic.create("title" => nil).valid? # => true
```

### `:message`

Most validators will come up with a default error message on your
behalf. Sometimes you want more control over the message reported to
the user. In this case, you will want to use the `:message`
option. This lets you provide a string to use as the error message.

### `:if`

Sometimes it will make sense to validate an object only when a given
predicate is satisfied. You may use the `:if` option when you want to
specify when the validation **should** happen. If you want to specify
when the validation **should not** happen, then you may use the
`:unless` option.

You can associate the `:if` and `:unless` options with a symbol
corresponding to the name of a method that will get called right
before validation happens:

```ruby
class Order < ActiveRecord::Base
  validates :card_number, :presence => true, :if => :paid_with_card?

  def paid_with_card?
    payment_type == "card"
  end
end
```

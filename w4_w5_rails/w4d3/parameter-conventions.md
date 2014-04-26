# Rails Parameter Conventions

As you've seen in the previous sections, values from forms can be at
the top level of the `params` hash or nested in another hash. For
example in a standard `create` action for a Person model,
`params[:person]` would usually be a hash of all the attributes for
the person to create. The `params` hash can also contain arrays,
arrays of hashes and so on.

Fundamentally HTML forms don't know about any sort of structured data,
all they generate is name–value pairs, where pairs are just plain
strings. The arrays and hashes you see in your application are the
result of some parameter naming conventions that Rails uses.

TIP: You may find you can try out examples in this section faster by
using the console to directly invoke Rack's parameter parser. For
example:

```ruby
Rack::Utils.parse_query "name=fred&phone=0123456789"
# => {"name"=>"fred", "phone"=>"0123456789"}
```

## Basic Structures: Hash

The two basic structures are arrays and hashes. Hashes mirror the
syntax used for accessing the value in `params`. For example if a form
contains

```html
<input id="person_name" name="person[name]" type="text" value="Henry">
```

the `params` hash will contain

```ruby
{'person' => {'name' => 'Henry'}}
```

and `params[:person][:name]` will retrieve the submitted value in the
controller.

Hashes can be nested as many levels as required, for example

```html
<input id="person_address_city" name="person[address][city]" type="text" value="New York">
```

will result in the `params` hash being

```ruby
{'person' => {'address' => {'city' => 'New York'}}}
```

## Basic Structures: Arrays

Normally Rails ignores duplicate parameter name. For instance, if your
form contains:

```html
<input type="hidden" name="key" value="value1">
<input type="hidden" name="key" value="value2">
```

then on submission, the browser will send:

    key=value1&key=value2

When Rails goes to parse this, it will return:

```ruby
{ "key" => "value2" }
```

The last value wins. Rails discards any prior values. Note that Rails
is the one which does this: the browser is happy to upload multiple
values for the same name.

When you want Rails to build an array, you append an empty set of
square brackets to the name:

```html
<input name="person[phone_numbers][]" type="text" value="555-123-4567">
<input name="person[phone_numbers][]" type="text" value="555-765-4321">
<input name="person[phone_numbers][]" type="text" value="555-135-2468">
```

Rails will parse the uploaded params as:

```ruby
{ "person" => {
    "phone_number" => [
      "555-123-4567",
      "555-765-4321",
      "555-135-2468"
    ]
  }
}
```

## Rule 2.5: No arrays of hashes

You can't create arrays of hashes:

```html
<input name="persons[][phone_number]" type="text" value="555-123-4567">
<input name="persons[][phone_number]" type="text" value="555-765-4321">
<input name="persons[][phone_number]" type="text" value="555-135-2468">
```

You want:

```ruby
{ "persons" => [
    { "phone_number" => "555-123-4567" },
    { "phone_number" => "555-765-4321" },
    { "phone_number" => "555-135-2468" }
  ]
}
```

But this won't work. For whatever reason, Rails won't let you do
this. Instead, there's a hack:

```html
<input name="persons[0][phone_number]" type="text" value="555-123-4567">
<input name="persons[1][phone_number]" type="text" value="555-765-4321">
<input name="persons[2][phone_number]" type="text" value="555-135-2468">
```

Which Rails translates as:

```ruby
{ "persons" => {
    "0" => { "phone_number" => "555-123-4567" },
    "1" => { "phone_number" => "555-765-4321" },
    "2" => { "phone_number" => "555-135-2468" }
  }
}
```

When we read about nested forms (forms which create more than one
object), we will have occasion to use this trick.

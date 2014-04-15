# Building ActiveRecordLite

In this project, we build our own lite version of ActiveRecord. The
purpose of this project is for you to understand how ActiveRecord
actually works: how your ActiveRecord world is translated into SQL.

## Setup

Clone the [ActiveRecordLite repo][repo]. There are specs in it which
will guide you through the project.

[repo]: https://github.com/appacademy-solutions/active_record_lite

## Phase 0: Implement `my_attr_accessor`

This phase will serve as a (relatively) easy warm up to metaprogramming.
You already know what the standard Ruby method `attr_accessor` does.
What if Ruby didn't provide this convenient method for you?

In the `lib/00_attr_accessor_object.rb` file, implement a
`::my_attr_accessor` macro, which should do exactly the same thing as
the real `attr_accessor`: it should define setter/getter methods.

To do this, use `define_method` to define getter and setter instance
methods. You'll want to investigate and use the
`instance_variable_get` and `instance_variable_set` methods described
[here][ivar-get].

[ivar-get]: http://ruby-doc.org/core-2.0.0/Object.html#method-i-instance_variable_get

There is a corresponding `spec/00_attr_accessor_object_spec.rb` spec
file. Run it using `rspec` to check your work.

## Phase I: `SQLObject`

Our first job is to write a class, `SQLObject`, that will interact with
the database. Like `ActiveRecord::Base`, we want to define these
methods:

* `::all`: return an array of all the records in the DB
* `::find`: look up a single record by primary key
* `#insert`: insert a new row into the table to represent the
  `SQLObject`.
* `#update`: update the row with the `id` of this `SQLObject`
* `#save`: convenience method that either calls `insert`/`update`
  depending on whether the `SQLObject` already exists in the table.

### `::table_name` and `::table_name=`

Before we begin writing methods that interact with the DB, we need to
be able to figure out which table the records should be fetched from,
inserted into, etc. We should write a class getter method `::table_name`
which will get the name of the table for the class. We should also
write a `::table_name=` setter to set the table. You definitely want to
use class instance variables to store these.

Example:

```ruby
class Human < SQLObject
  self.table_name = "humans"
end

Human.table_name # => "humans"
```


It would also be nice if, in the absence of an explicitly set table
name, we would have `::table_name` by default convert the class name
to snake\_case and pluralize:

```ruby
class BigDog < SQLObject
end

BigDog.table_name # => "big_dogs"
```

ActiveSupport (part of Rails) has an inflector library that adds
methods to `String` to help you do this. In particular, look at
`String#underscore` and `String#pluralize` methods. You can require
the inflector with `require 'active_support/inflector'`.

###NB:
you cannot always infer the name of the table. For example: the `inflector`
library will, by default, pluralize `human` into `humen` not `humans`. Ain't
that some shit?

*Note:* There is more to Phase I!  You will probably want to finish the 
next couple of sections (Attributes, Columns, and Initialize) before 
running the specs.

### Attributes:  `SQLObject#attributes`

The first thing we need to add is an instance variable which stores a hash
which will hold all the data for the model. **NB**: Data from the database is 
not stored in ActiveRecord::Base model in seprate instance variables per column. 

Make a getter method to access the attributes hash, call it `#attributes`. If 
the `@attributes` instance variable is nil when the method is called, create 
a new hash and assign it to the instance variable `@attributes`.

### Columns: `SQLObject::columns`

Make a class method, `::columns` for the `SQLObject` class.

This _class_ method will return an array of the names of the columns that this
model contains (as ***symbols***). 

If we knew the names of the columns, we could just assign the array directly,
but our `SQLObject` needs to be intelligent enough to get these values from the 
database. 

```ruby
Cat.columns
#=> [:id, :name, :owner_id]
```

So, to get these values we must ask the database what they are. 
When executing a query using the gem `SQLite3`, we can choose to 
include the column names as an array in addition to the data from database.

For example: the `DBConnection.execute2("SELECT * FROM cats")`
(notice this is `execute2`, **not** just `execute`), would return
an array of things. The first would be an array containing the columns names.
Subsequent arrays would contain the data for all the cats in the table.

Using the table name for the class, you should be able to get the array of 
columns from the table.

Iterate over this array of column names and define getter and setter methods
for each column in the table.

These getter and setter methods will abstract the access to the attributes hash.
The user will never have to interact with the hash directly, but will instead
get and set the values using the methods we define dynamically when `columns`
is first called.

Example:

```ruby
class Cat < SQLObject
end

cat = Cat.find(1)
puts "#{cat.name} belongs to user ##{cat.owner_id}"

ajax = Cat.new(:name => "Ajax", :owner_id => 123)
ajax.insert
```
### `#initialize`

Write an `#initialize` method for `SQLObject`. It should take in a
single `params` hash.

Your `#initialize` method should iterate through each of the
`attr_name, value` pairs. For each `attr_name`, it should use
first convert the name to a symbol, then check whether the `attr_name`
is among the `columns`. If it is not, raise an error.

    unknown attribute '#{attr_name}'

**Hint**: we need to call `::columns` on a class object, not the
instance. For example, we can call `Dog::columns` but not
`dog.columns`.

Note that `dog.class == Dog`. How can we use the `Object#class` method
to access the `::columns` **class method** from inside the
`#initialize` **instance method**?


### `::all`

We now want to write a method `::all` that will fetch all the records
from the database. The first thing to do is to try to generate the
necessary SQL query to issue. Generate SQL and print it out so you can
view and verify it. Use the heredoc syntax to define your query.

Example:

```ruby
class Cat < SQLObject
end

Cat.all
# SELECT
#   cats.*
# FROM
#   cats

class Human < SQLObject
  self.table_name = "humans"
end

Human.all
# SELECT
#   humans.*
# FROM
#   humans
```

Notice that the SQL is formulaic except for the table name, which we
need insert. Use ordinary Ruby string interpolation (`#{whatevs}`) for
this; SQL will only let you use `?` to interpolate **values**, not
table or column names.

Once we've got our query looking good, it's time to execute it. Use
the provided `DBConnection` class. You can use
`DBConnection.execute(sql, arg1, arg2, ...)` in the usual manner.

Calling `DBConnection` will return an array of raw `Hash` objects
where the keys are column names and the values are column values. We
want to turn these into Ruby objects:

```ruby
class Human < SQLObject
  self.table_name = "humans"
end

Human.all
#=> [#<Human:0x007ff98398a600 @fname="Devon", @house_id=1, @id=1, @lname="Watts">,
#    #<Human:0x007ff983989db8 @fname="Matt", @house_id=1, @id=2, @lname="Rubens">]
```

### `::parse_all`
To turn each of the `Hash`es into `Human`s, write a
`SQLObject::parse_all` method. Iterate through the results, using
`new` to create a new instance for each.

`new` what? `SQLObject.new`? That's not right, we want `Human.all` to
return `Human` objects, and `Cat.all` to return `Cat`
objects. **Hint**: inside the `::parse_all` class method, what is
`self`?

### `::find`

Write a `SQLObject::find(id)` method to return a single object with
the given id. You could write `::find` using `::all` and then use
`Array#select` to only pick the objects with the given id, but that
would be inefficient: we'd fetch all the records from the DB. Instead,
write a new SQL query that will fetch at most one record.

### `#insert`

Write a `SQLObject#insert` instance method. This should build and
execute a SQL query like this:

```sql
INSERT INTO
  table_name (col1, col2, col3)
VALUES
  (?, ?, ?)
```

To simplify building this query, I made two local variables:

* `col_names`: I took the array of `::attributes` of the class and
  joined it with commas.
* `question_marks`: I built an array of question marks (`["?"] * 3`)
  and joined it with commas.

Lastly, when you call `DBConnection.execute`, you'll need to pass in
the values of the columns. Two hints:

* I wrote a `SQLObject#attribute_values` method that returns an array
  of the values for each attribute. I did this by calling `Array#map`
  on `SQLObject::attributes`, calling `send` on the instance to get
  the value.
* Once you have the `#attribute_values` method working, I passed this
  into `DBConnection.execute` using the splat operator.

Finally, after completing the insert, you need to set the object's
`id` attribute with the newly issued row id. Check out the
`DBConnection` file for a helpful method.

### `#update

Next we'll write a `SQLObject#update` method to update a record's
attributes. Here's a reminder of what the resulting SQL should look
like:

```sql
UPDATE
  table_name
SET
  col1 = ?, col2 = ?, col3 = ?
WHERE
  id = ?
```

This is very similar to the `#insert` method. Here, I used a
`set_line` local variable which I built by mapping `::attributes` to
`"#{attr_name} = ?"` and then joining with commas.

I again used the `#attribute_values` trick. I additionally passed in
the `id` of the object (for the last `?` in the `WHERE` clause).

### `#save`

Finally, write an instance method `SQLObject#save`. This should call
`#insert` or `#update` depending on whether `id.nil?`. It is not
intended that the user call `#insert` or `#update` directly (leave
them public so the specs can call them :-).


## Phase II: `Searchable`

Let's write a module named `Searchable` which will add the ability to
search using `::where`. By using `extend`, we can mix in `Searchable`
to our `SQLObject` class.

So let's write `Searchable#where(params)`. Here's an example:

```ruby
haskell_cats = Cat.where(:name => "Haskell", :color => "calico")
# SELECT
#   *
# FROM
#   cats
# WHERE
#   name = ? AND color = ?
```

I used a local variable `where_line` where I mapped the `keys` of the
`params` to `"#{key} = ?"` and joined with `AND`.

In lieu of using `#attribute_values`, I used the `values` of the
`params` object.

## Phase III+: Associations

[Page on over to the association phases!][ar-part-two]

[ar-part-two]: ./w3d5-build-your-own-ar-p2.md

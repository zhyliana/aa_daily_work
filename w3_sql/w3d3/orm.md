# Object Relational Mapping

## Motivation

We've discussed how to manage changes to a SQL database through
migrations. Now we'd like to start using the records stored in that
database.

We've previously worked directly with a database by writing SQL. One
downside was that this embedded SQL code is in our Ruby code; though this
works, it would be nice to work, as much as possible, only in Ruby syntax.

Also, when we fetched data from our SQL database, the data was
returned in generic `Hash` objects. For instance, if our database was
setup like this:

    > CREATE TABLE cars (make VARCHAR(255), model VARCHAR(255), year INTEGER);
    > INSERT INTO cars (model, make, year)
        ("Toyota", "Camry", 1997),
        ("Toyota", "Land Cruiser", 1989),
        ("Citroen", "DS", 1969);

And we wrote the following ruby code to fetch the data:

```ruby
require 'sqlite3'
db = SQLite3::Database.new("cars.db")
db.results_as_hash = true
db.type_translation = true

cars = db.execute("SELECT * FROM cars")
# => [
  {"make" => "Toyota", "model" => "Camry", "year" => 1997},
  {"make" => "Toyota", "model" => "Land Cruiser", "year" => 1989},
  {"make" => "Citroen", "model" => "DS", "year" => 1969}
]
```

That works nicely, but what if we wanted to store and load objects of
a `Car` class? Instead of retrieving generic `Hash` objects, we want
to get back instances of our `Car` class. Then we could call `Car`
methods like `go` and `vroom`. How would we translate between the
world of Ruby classes and rows in our database?

## What is an ORM?

An *object relational mapping* is the system that translates between
SQL records and Ruby (or Java, or Lisp...) objects. The ActiveRecord
ORM translates rows from your SQL tables into Ruby objects on fetch,
and translates your Ruby objects back to rows on save. The ORM also
empowers your Ruby classes with convenient methods to perform common
SQL operations: for instance, if the table `physicians` contains a
foreign key referring to `offices`, ActiveRecord will be able to
provide your `Physician` class a method, `#office`, which will fetch
the associated record. Using ORM, the properties and relationships of
the objects in an application can be easily stored and retrieved from
a database without writing SQL statements directly and with less
overall database access code.

## Model classes and `ActiveRecord::Base`

For each table, we define a Ruby **model** class; an instance of the
model will represent an individual row in the table. For instance, a
`physicians` table will have a corresponding `Physician` model class;
when we fetch rows from the `physicians` table, we will get back
`Physician` objects. All model classes extend `ActiveRecord::Base`;
methods in `ActiveRecord::Base` will allow us to fetch and save Ruby
objects from/to the table.

If we had a table named `physicians`, we would create a model
class like so:

```ruby
# app/models/physician.rb
class Physician < ActiveRecord::Base
end
```

By convention, we define this class in `app/models/physician.rb`. The
`app/models` directory is where Rails looks for model classes.

The `ActiveRecord::Base` class has lots of magic within it. For one,
the name of the class is important; ActiveRecord is able to infer from
the class name `Physician` that the associated table is
`physicians`. Model classes are always singular (just like tables are
always plural): respect the connection so ActiveRecord knows how to
make the connection between the two worlds.

### `::find` and `::all`

The first methods we'll learn are for fetching records from the DB:

```ruby
# return an array of Physician objects, one for each row in the
# physicians table
Physician.all

# lookup the Physician with primary key (id) 101
Physician.find(101)
```

### `::where` queries

Often we want to look up records by some criteria other than primary
key. To do this, we use `::where`:

```ruby
# return an array of Physicians based in La Jolla
Physician.where("home_city = ?", "La Jolla")
# Executes:
#   SELECT *
#     FROM physicians
#    WHERE physicians.home_city = 'La Jolla'
```

Note the **SQL fragment** that is passed to `::where`. This condition
will form the `WHERE` SQL condition. We continue to use the `?`
interpolation character so as to avoid the Bobby Tables (colloquially
called **SQL injection**) attack.

#### Querying for Cool Kids

ActiveRecord lets you query without SQL fragments:

```ruby
Physician.where(
  :home_city => "La Jolla"
)
```

ActiveRecord will look at the hash and construct a `WHERE` fragment
requiring `home_city = 'La Jolla'`. Here's some other cool versions:

```ruby
# physicians at any of these three schools
Physician.where(:college => ["City College", "Columbia", "NYU"])
# => SELECT * FROM physicians WHERE college IN ('City College', 'Columbia', 'NYU');
# physicians with 3-9 years experience
Physician.where(:years_experience => (3..9))
# => SELECT * FROM physicians WHERE years_experience BETWEEN 3 AND 9
```

Myself, I don't bother with those methods. Rails (and especially
ActiveRecord) often tries to offer very high-level, abstract ways to
do things. Often-times, the hidden cost of these is added
complexity. This is a minor case (these uses of `where` are not hard
to understand), but the minimal added convenience makes me feel these
cool ways to use `where` are not worth it.

Let's put it another way: you're not allowed to forget SQL anyway, and
writing SQL `WHERE` fragments is easy...

### Updating and inserting rows

By extending `ActiveRecord::Base`, your model class will automatically
receive getter/setter methods for each of the database columns. This
is convenient, since you won't have to write `attr_accessor` for each
column. Here we construct a new `Physician` and set some appropriate
fields:

```ruby
# create a new Physician object
p = Physician.new

# set some fields
p.name = "Jonas Salk"
p.college = "City College"
p.home_city = "La Jolla"
```

Great! As you know from your previous AA Questions project, this will
not have saved `p` to the Database however. To do this, we need to
call the `ActiveRecord::Base#save!` method:

```ruby
# save the record to the database
p.save!
```

Notice that I use `#save!`; you may have also seen the plain ol'
`#save`. The difference between the two is that `#save!` will warn you
if you fail to save the object, whereas `#save` will quietly return
`false` (it returns `true` on success). Since it is a common mistake
to forget to check the return value of `#save`, make `#save!` your
default.

There is nothing worse than silently losing a bunch of data because
you never made sure it was actually persisted to the database...

To save some steps of `#save!`, we can use `#create!` to create a new
record and immediately save it to the db:

```ruby
Physician.create!(
  :name => "Jonas Salk",
  :college => "City College",
  :home_city => "La Jolla"
)
```

### Destroying data

Finally, we can destroy a record and remove it from the table through
`#destroy`:

```ruby
physician.destroy
```

## The Rails consoles

Okay! Let's say you want to start playing with your Rails
application. In other applications, we started up a REPL by running
the `pry` command.

To do likewise in Rails, run `rails console` (or `rails c` for the
impatient). I've told you to add the `pry-rails` gem so you still get
the `pry` sweetness you've become accustomed to.

The only big difference between `rails console` and `pry`/`irb` is
that the console will take care of loading your Rails application so
you won't have to `require` your model classes manually. It will also
open up a connection to the DB for you. This is handy, because you can
immediately start playing with your app, rather than first requiring
and loading a bunch of supporting classes.

Another trick: you're used to using `load` to re-load source code from
the console. In the Rails console, run the `reload!` command; this
will re-load all the model classes.

If you want to access a SQL console, you may conveniently run `rails
dbconsole`.

**Start a Rails project and play round with what you've learned so
far!**

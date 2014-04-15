# Rails Conventions

## Intro

When writing applications using other programming languages or
frameworks, it may be necessary to write a lot of configuration
code. This is particularly true for ORM frameworks in general. For
instance, it is often a great nuisance to connect the models to
tables, describe the relationships (associations) between objects,
etc. Doing this in other frameworks that pre-existed Rails often
involved a lot of "boilerplate", repetitive code.

You lived this life when you did the AA Questions project. Would you
like to write all that boilerplate again? For the rest of your career?
I didn't think so :-)

If you follow the conventions adopted by Rails, you'll need to write
very little boilerplate (in most cases none at all) when authoring
ActiveRecord models. The idea is that if you configure your models in
the very same way most of the time, then this configuration should be
the default way. Explicit configuration should be needed only in those
cases where you can't follow the convention for some reason or
another.

This philosophy is called **convention over configuration**.

## Model/Table Conventions

Rails' ability to perform configuration for you relies on your
following Rails' naming conventions. Follow the naming conventions
and Rails will make your life easy. Violate the conventions, and
you'll burn up a lot of time fighting Rails.

By default, ActiveRecord uses some naming conventions to find out how
the mapping between models and database tables should be
created. Rails will pluralize your class names to find the respective
database table. So, for a class `Book`, you should have a database
table called **books**. The Rails pluralization mechanisms are very
powerful, being able to pluralize (and singularize) both regular and
irregular words. When using class names composed of two or more words,
the model class name should follow the Ruby conventions, using the
CamelCase form, while the table name must contain the words separated
by underscores (snake\_case). Examples:

| Model / Class | Table / Schema |
| ------------- | -------------- |
| `Post`        | `posts`        |
| `LineItem`    | `line_items`   |
| `Deer`        | `deer`         |
| `Mouse`       | `mice`         |
| `Person`      | `people`       |


## Association Conventions

Active Record uses naming conventions for the columns in database
tables, depending on the purpose of these columns.

* **Foreign keys** - Foreign key columns should be named after the
  table they refer to. For instance, if an `Appointment` has a column
  that refers to a `Physician`, it should be named `physician_id`.
* **Primary keys** - By default, Active Record will use an integer
  column named `id` as the table's primary key. When using
  [Rails Migrations](migrations.md) to create your tables, this
  column will be automatically created.

In our previous example of `Physician` and `Appointment`, we wrote:

```ruby
class Physician < ActiveRecord::base
  has_many(
    :appointments,
    :class_name => "Appointment",
    :foreign_key => "physician_id",
    :primary_key => "id"
  )
end
```

If we follow Rails conventions, we can cut down the boilerplate to
just `has_many :appointments`. Rails will infer that the associated
class name is `Appointment` from the name of the association. Because
this is a `Physician`, Rails will infer that the foreign key name is
`physician_id`. Finally, since primary key is by default `id`, Rails
will infer this, too.

Because it is sometimes necessary to override the Rails defaults, you
are not excused from knowing how to set up an association. Instead,
you should know how Rails infers the parameters. That way you can know
when you can rely on them, and when you need to work around them.

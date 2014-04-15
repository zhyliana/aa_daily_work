# Associations I: `belongs_to` and `has_many`

## Goals

This guide covers the association features of Active Record. By
referring to this guide, you will be able to:

* Declare associations between Active Record models,
* Understand the various types of Active Record associations,
* Use the methods added to your models by creating associations.

## Basic associations

When you create your migrations, you'll set up foreign key references
between entities. For instance,

```ruby
class CreateCoursesAndProfessorsTables < ActiveRecord::Migration
  def change
    create_table :professors do |t|
      t.string :name
      t.string :thesis_title
      
      t.timestamps
    end
    
    create_table :courses do |t|
      t.string :course_name
      t.integer :professor_id
    end
  end
end
```

Each `Course` has a professor teaching the class; we store the
`Professor`'s id in the `Course`'s `professor_id` column.  `courses`'
`professor_id` column contains values that are foreign keys to the
`professors` table.

Given a `Course`, how shall we find the professor? One way is this:

```ruby
Professor.find(course.professor_id)
```

Likewise, to find the courses a professor is teaching:

```ruby
Course.where("professor_id = ?", prof.id)
```

This is tedious and low-level; we need to pull out the foreign key,
then explicitly look it up in the `professors` table. ActiveRecord
makes this easier through *associations*. Associations tell AR that
there is a connection between the two models. Here we modify the
associated model classes:

```ruby
class Course < ActiveRecord::Base
  belongs_to(
    :professor,
    :class_name => "Professor",
    :foreign_key => :professor_id,
    :primary_key => :id
  )
end

class Professor < ActiveRecord::Base
  has_many(
    :courses,
    :class_name => "Course",
    :foreign_key => :professor_id,
    :primary_key => :id
  )
end
```

The `belongs_to` and `has_many` methods exist in a module named
`ActiveRecord::Associations::ClassMethods`. `ActiveRecord::Base`
extends this module, so the association methods are available as class
methods. These class methods define instance methods: in this case,
`Course#professor` and `Professor#courses`. Class methods like this
are called **macros**. These let us write more simply:

```ruby
course.professor # the professor for a course
# => SELECT
#      professors.*
#    FROM
#      professors
#    WHERE
#      professors.id = ?
#    LIMIT
#      1
#
# The `?` is filled with `course.professor_id`; the LIMIT it not strictly
# necessary, but expresses the intent that one record be returned.

professor.courses # an array of the courses a professor teaches
# => SELECT
#      courses.*
#    FROM
#      courses
#    WHERE
#      courses.professor_id = ?
#
# The `?` is filled with `professor.id`.
```

Note that Rails needs the `primary_key` and `foreign_key` attributes
so that it knows how `courses` and `professors` are connected. It uses
this information to generate the proper SQL query.

The `class_name` attribute is also necessary, since this tells Rails
what other table to look up, and what kind of model object to
construct with the result. Also, without the class name Rails wouldn't
know to build `Course` objects to return from the `Professor#courses`
call.

## `belongs_to` versus `has_many`

### `belongs_to`

A `belongs_to` sets up a connection that will fetch a single
associated object. Use a `belongs_to` association when an object has a
foreign key that points to the associated record. In our example, a
`Course` `belongs_to` a `Professor` because `courses` records hold a
`professor_id` foreign key.

Note that it is expected that the primary key be unique; it is
typically the `id` column. Accessing a `belongs_to` association will
only return one object.

Note that when we defined the association, we used the singular form
(e.g., `Course#professor`). That's because a `Course` has a single
foreign key that refers to a single `Professor`. Name your association
accordingly: in the singular.

![belongs_to Association Diagram](http://guides.rubyonrails.org/images/belongs_to.png)

### `has_many`

We use `belongs_to` when the record holds a foreign key that
references an associated object. What if we want to go in the opposite
direction?

The answer is to use `has_many`. We use `has_many` when a record holds
a column (the primary key) that is refered to by a foreign key in the
associated records.

Note that because a foreign key is not expected to be unique, many
records in a table may all refer to the same object. For that reason,
`has_many` associations can yield multiple associated records.

In our example, `professors` owns the primary key `id`. This primary
key is referred to by `courses`' `professor_id` attribute. The right
choice here is `has_many` and not `belongs_to` because `professors` is
referred to by the associated object.

Note that the name of a `has_many` association is pluralized, since
the method will return an array (possibly empty) of associated
objects.

![has_many Association Diagram](http://guides.rubyonrails.org/images/has_many.png)

### Deciding between `belongs_to` and `has_many`

When defining an association, you need to figure out whether to use
`belongs_to` or `has_many`. The rule is that if the record holds a
reference pointing to the associated record, use `belongs_to`. If the
record is pointed to by the associated records, use `has_many`.

The choice is about who has the foreign key and who has the primary
key. It is not really about whether there is at most one or
potentially multiple associated records.

In a pair of associations like `Course#professor` and
`Professor#courses`, notice that `primary_key` and `foreign_key` are
the same. The concept of primary key and foreign key are not relative
to which side of an association you are on; they are about whether a
column holds a reference to the other record (the foreign key), or
whether the column is referred to by the other record (the primary
key). That's why they are the same in both directions.

Lastly **think about the SQL that will be
generated**. `belongs_to`/`has_many` are short-cuts to writing the SQL
yourself, but you need to be able to write the SQL they would
generate.

## References

* [JumpStart Labs Relations reading][js-relations]

[js-relations]: http://tutorials.jumpstartlab.com/topics/models/relationships.html

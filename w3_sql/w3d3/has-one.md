# Associations III: `has_one` and HABTM

### The `has_one` Association

`has_one` is a `has_many` association where at most one associated
record will exist. As a convenience, instead of returning an empty or
one-element array, `has_one` will return the associated object (or
`nil`, if the associated object doesn't exist).

`has_one` is not very common, because it implies that there is a
one-to-one association between two records in the database. In that
case, it would be more typical for those two tables to be merged.

One exception is if one of the tables contains a lot of "wide" columns
that contain a lot of data and is not likely to be used often. In that
case, you may wish to extract some of the "wide" columns into a table
that is related 1 to 1.

### The `has_one :through` Association

This acts the same as `has_many :through`, but tells ActiveRecord that
only one record will be returned, so don't put it in an array. This is
exactly analogous to what you saw with traditional `has_one` vs
`has_many`. Because it wouldn't make sense to use a `has_one :through`
which traverses a `has_many` association, `has_one :through` is
used to link up `belongs_to` and `has_one` associations only.

### The `has_and_belongs_to_many` (HABTM) Association

ActiveRecord has a way of defining a many-to-many association without
requiring a model for the intervening join table. This is the
`has_and_belongs_to_many` association. It is a shortcut to writing
`has_many :through` associations. All it does is save you a little
more boilerplate.

I (and many others) don't advise this approach, since join tables
often contain useful information. For instance, an `appointments`
table could have the start and end time of the appointment. In that
case, you'll want an `Appointment` model class anyway.

For this reason, I won't further describe HABTM; you can look it up if
you encounter out there on the mean streets.

## Exercises

* What is the difference between `belongs_to` and `has_one`?
* Why would a new `belongs_to_many` association type not make sense?

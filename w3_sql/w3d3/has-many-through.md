# Associations II: `has_many :through`

## The Problem

We've defined two kinds of associations; `belongs_to` associates a
record holding a foreign key to the record the key points to, while
`has_many` associates an record with one or more entities that hold a
foreign key pointing to it.

What about indirect relations? For instance, consider the following
example:

```ruby
class Physician < ActiveRecord::Base
  has_many(
    :appointments,
    :class_name => "Appointment",
    :foreign_key => :physician_id,
    :primary_key => :id
  )
end

class Appointment < ActiveRecord::Base
  belongs_to(
    :physician,
    :class_name => "Physician",
    :foreign_key => :physician_id,
    :primary_key => :id
  )

  belongs_to(
    :patient,
    :class_name => "Patient",
    :foreign_key => :patient_id,
    :primary_key => :id
  )
end

class Patient < ActiveRecord::Base
  has_many(
    :appointments
    :class_name => "Appointment",
    :foreign_key => :patient_id,
    :primary_key => :id
  )
end
```

Here both a `Physician` and a `Patient` may have many
appointments. What if we want to get all the `Patient`s who have an
`Appointment` with a given `Physician`? One way to do this is to get
the `Appointment`s for the `Physician`, then loop through these to get
the `Patient` objects:

```ruby
patients = physician.appointments.map do |appointment|
  appointment.patient
end
```

Holy multiple lines of code, Batman. More importantly, note that each
call of `appointment.patient` will fire another DB query; if a
`Physician` has 100s of `Appointment`s, this will fire 100s of DB
queries. Running 100s of queries will really, really slow down our
app.

This is called an `N+1` query: we do one query for the first fetch of
`appointments`, and then `N` queries for `patient`, one for each of
`N` appointments. As a `Physician` gains more `Appointment`s, this
will grow slower and slower.

There has to be a better way.

## The solution: `has_many :through`

We can use a new kind of association, `has_many :through` that links
up two existing associations. **Important note**: a **`has_many
:through` association has nothing to do with traditional `has_many`**.

```ruby
class Physician < ActiveRecord::Base
  has_many(
    :appointments,
    :class_name => "Appointment",
    :foreign_key => :physician_id,
    :primary_key => :id
  )

  has_many :patients, :through => :appointments, :source => :patient
end

class Appointment < ActiveRecord::Base
  belongs_to(
    :physician,
    :class_name => "Physician",
    :foreign_key => :physician_id,
    :primary_key => :id
  )

  belongs_to(
    :patient,
    :class_name => "Patient",
    :foreign_key => :patient_id,
    :primary_key => :id
  )
end

class Patient < ActiveRecord::Base
  has_many(
    :appointments
    :class_name => "Appointment",
    :foreign_key => :patient_id,
    :primary_key => :id
  )

  has_many :physicians, :through => :appointments, :source => :physician
end
```

A `has_many :through` association associates records *through* other
tables. The most typical case is the one we have here: where two
models are related in a many-to-many way through an intermediary
**join table**. In this case, `Phyisican` and `Patient` are associated
through an intermediary `appointments` table.

Let's pull apart the the `has_many :through` association. Take the
example of:

```ruby
has_many :patients, :through => :appointments, :source => :patient
```

The critical thing here is to note that `:through` and `:source` name
**other associations**. `has_many :through` links existing
associations. First define these underlying associations and then you
can stitch them up using `has_many :through`.

A `has many :through` association can be thought of as a two step
process. Step one is to travel through the `:through` association on
the model; in this case, `Physician#appointments`. Note that it is
necessary to have defined an `appointments` association on
`Physician`.

The next step is to continue on from the `Appointment` to
`Patient`. It does this by using the `:source` association name; the
second step is to follow the `Appointment#patient` association. Again,
this association must be defined.

Let me stress this: **a `has_many :through` association simply names
two existing associations and links them up**. First the `:through`
association is traversed, then the `:source` association.

You **must not** specify low-level details like `:class_name`,
`:foreign_key` and`:primary_key`: they are not relevant. `has_many
:through` works at the level of associations, not tables.

`:source` is an unfortunate, unclear name. You can think of it as
"step two" in your mind.

## The SQL and the Damage Done

Okay, how does `has_many :through` work? What SQL does it generate? As
a refresher, let's consider `Physician#appointments` and
`Appointment#patient`:

```ruby
physician.appointments
# SELECT
#   appointments.*
# FROM
#   appointments
# WHERE
#   appointments.physician_id = ?

appointment.patient
# SELECT
#  patients.*
# FROM
#  patients
# WHERE
#  patients.id = ?
```

Through a process that should seem magical to you right now, `has_many
:through` will combine the two associations into a single query using
a `JOIN`:

```ruby
physician.patients
# SELECT
#  patients.*
# FROM
#  appointments
# JOIN
#  patients ON appointments.patient_id = patients.id
# WHERE
#  appointments.physician_id = ?
```

Notice that we need a join here: we want to return patient
information, but we also need appointment information to see if the
patient is scheduled with the doctor.

Please also note that we needed all the underlying information of the
constituent associations: we needed
`class_name`/`foreign_key`/`primary_key` from each of the associations
we are building the `has_many :through` from. However, note that we do
not need additional information beyond this. That's why we don't need
to specify these attributes with the `has_many :through`. It uses the
attributes of the underlying associations which were already specified
when defined those.

### More degrees of separation

In the examples above, the `:through` was a `has_many` association and
the `:source` was a `belongs_to` association.

`has_many :through` doesn't care about the kind of associations
though. We could go `:through` a `belongs_to` and onward with a
`:source` of `has_many`. Or, another option is to combine two
`has_many` associations.

We can link objects that are further separated by using a `has_many
:through` association as the `:through` or `:source` (or both!). This
will necessitate more `JOIN`s, but still be a single query.

The point is that `has_many :through` does not care about the kind of
underlying associations. It is smart and knows how to build a query
from any pair of constituent associations.

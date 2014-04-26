# Quiz

## Associations

### Basic associations

* When using `belongs_to` and `has_many`, what do the following
  attributes mean?
    * `:primary_key`
    * `:foreign_key`
    * `:class_name`
    * How are the defults for these parameters inferred?
* What is the difference between `belongs_to` and `has_many`?
* When using `belongs_to :physician`, what do each of the following
  generated methods do:
    * `#physician=`
    * `#build_physician`
    * `#create_physician`
* When using `has_many :patients`, what do each of the following
  generated methods do:
    * `patients <<`
    * `patient_ids`
    * `patient_ids=`
    * `patients.build`
    * `patients.create`

### `has_many :through`

* How does `has_many :ys :through => :xs` work?
* What two associations does this join up? On which classes?
* Why don't we use `:class_name`, `:primary_key`, `:foreign_key` with
  `has_many :through`?
* What is the `:source` option?

### `inverse_of`

In the example

```ruby
class Patient
  belongs_to :physician
  
  validates :physician_id, :presence => true
end

class Physician
  has_many :patients
end
```

What is the problem with `physician.create_patient`? Why would
validations fail?

Why is the `physician_id` attribute not set? What should we validate
instead? Why will we use `inverse_of` also?

## Forms

### HTML side

* What are the `action` and `method` attributes of the `form` tag
  mean?
* How does Ruby convert between inputs named `key1[key2][key3]` and
  Ruby hashes?
* What happens when multiple inputs have the same name? What is `[]`
  mean when used in a Ruby name?
* How do labels match up with inputs? What are the `id` and `for`
  attributes used for?
* How do you use radio buttons to present the user with a choice of
  values?
* How do you name labels of radio buttons?
* How do you make check boxes so that the user can select multiple
  values.
* How do you make a `select` tag? How do you make many `option`s?

### Rails/AR side

### `has_many :through`

If

```ruby
class Physician
  has_many :physician_patients
  has_many :patients, :through => :physician_patients
end

class PhysicianPatient
  belongs_to :physician
  belongs_to :patient
end

class Patient
end
```

How do you make a form that lets the user set `Patient`s for a
`Physician`? Note that you don't want to create new `Patient`s, you
just want to select them. What does `patient_ids` do?

Why do you need to make `patient_ids` `attr_accessible`?

### Nested attributes

* What does `accepts_nested_attributes_for` mean? What does the
  generated method `#patients_attributes=` do for you?
* Why do you need set `patients_attributes` `attr_accessible` if you
  want to create `Patients`s inside a `Physician` form?
* Why do you not need `accepts_nested_attributes_for` for simple join
  table many-to-many relationships?
* How do you use `fields_for`?
    * Why do you have to build associated objects in the controller
      before calling `fields_for`?
* `patients_attributes=` takes either an array of attribute hashes, or
  a hash where the values are attribute hashes.
    * Rails form parsing conventions don't allow for an array of
      hashes to be uploaded in a form.
    * How does `fields_for` get around this by uploading with a hash
      of hashes?
    * When `patients_attributes=` is passed a hash, what does it do
      with the keys?
* Be able to build a nested form by hand.

## Routing

...

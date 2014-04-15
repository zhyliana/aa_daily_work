# Design Patterns

## Delegation

Suppose we were building an app to manage a clinic. Our models might look like this to begin with:

```ruby
class Office < ActiveRecord::Base
  belongs_to :doctor
end

class Doctor < ActiveRecord::Base
  has_one :office
  has_many :patients
end

class Patient < ActiveRecord::Base
  belongs_to :doctor
end
```

When documenting a patient's appointments we want to ensure we
track which office and doctor the patient will be visiting.

A view of this might look something like this:

```html
<%= @patient.doctor.name %>
<%= @patient.doctor.specialty %>
<%= @patient.doctor.office.number %>
<%= @patient.doctor.office.address %>
``` 

ActiveRecord is powerful. But with great power, comes great responsibility.

Remember when we talked about the Law of Demeter? It says you should only talk to your neighbors/only use one dot.
The HTML above is loaded with LoD violations. Reaching from patient across to office will become a problem:
when we want to some day change the address of the office, we'll be in a world of hurt.

One design pattern to overcome LoD violations is to use _delegation_. We can either write getters by 
hand like this:

```ruby
class Patient < ActiveRecord::Base
  belongs_to :doctor
  
  def doctor_name
    doctor.name
  end
end
```

This allows us to access the doctors name via the patient like this:

```html
<%= @patient.doctor_name %>
```

See how we've only got one dot now? We've removed one LoD violation.

As you can imagine these getters are very common. Let's see how to use the `delegate`
method so that we don't have to write these setters by hand.

We can add a woof method to an owner so that `owner.woof` call the woof method of their dog by doing this:

```ruby
class Owner < ActiveRecord::Base
  has_one :dog
  delegate :woof, to: :dog
end

class Dog < ActiveRecord::Base
  belongs_to :owner
  
  def woof
    puts "woof"
  end
end
```

Now let's clean up our models so they delegate enough information to remove all of the LoD violations from above.
We can use the `:prefix => true` option to sensibly prefix our methods:

```ruby
class Office < ActiveRecord::Base
  belongs_to :doctor
end

class Doctor < ActiveRecord::Base
  has_one :office
  has_many :patients
  delegate :number,
           :address,
           to: office,
           prefix: true
end

class Patient < ActiveRecord::Base
  belongs_to :doctor
  delegate :name, 
           :specialty,
           :office_number, 
           :office_address, 
           to: :doctor, 
           prefix: true
end
```

We can now use our delegate methods in our view.

```html
<%= @patient.doctor_name %>
<%= @patient.doctor_specialty %>
<%= @patient.doctor_office_number %>
<%= @patient.doctor_office_address %>
```

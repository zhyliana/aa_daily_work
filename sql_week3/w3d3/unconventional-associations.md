# Unconventional Associations

## Reflexive Associations

We've learned about the `class_name`/`foreign_key`/`primary_key`
options for `belongs_to` and `has_many`. We know that Rails can often
infer these. Let's see an example where it cannot:

```ruby
class Employee < ActiveRecord::Base
  has_many :subordinates, 
           :class_name => "Employee",
           :foreign_key => :manager_id,
           :primary_key => :id
           
  belongs_to :manager, 
             :class_name => "Employee",
             :foreign_key => :manager_id,
             :primary_key => :id
end
```

I call this a *reflexive association*, because the association refers
back to the same table. Here, there is a `employees.manager_id` column
that refers to `employees.id` column.

We have to use the non-standard association names
`subordinates`/`manager` because `employees`/`employee` would be
extremely confusing to understand. Also, Rails itself will probably
get confused if you have two associations on the same class that
differ only in pluralization.

Note that I also departed from the conventional `employee_id` column
name. `manager_id` better explains the nature of this key.

## Two associations to the same class

Let's look at another example:

```ruby
# emails: id|from_email_address|to_email_address|text
#  users: id|email_address

class User < ActiveRecord::Base
  has_many(
    :sent_emails,
    :class_name => "Email",
    :foreign_key => :from_email_address,
    :primary_key => :email_address
  )
  has_many(
    :received_emails,
    :class_name => "Email",
    :foreign_key => :to_email_address,
    :primary_key => :email_address
  )
end

class Email < ActiveRecord::Base
  belongs_to(
    :sender,
    :class_name => "User",
    :foreign_key => :from_email_address,
    :primary_key => :email_address
  )
  belongs_to(
    :recipient,
    :class_name => "User",
    :foreign_key => :to_email_address,
    :primary_key => :email_address
  )
end
```

Here the `Email` and `User` objects are associated in two ways: sender
and recipient. Additionally, the `Email` record doesn't reference
`User`'s `id` field directly; instead, it refers to an
`email_address`. For that reason, we need to specify the `primary_key`
option; this is otherwise by default simply `id`.

Through these two examples, we've seen that we can go beyond the
conventional ActiveRecord guesses in cases where our associations are
a little special.

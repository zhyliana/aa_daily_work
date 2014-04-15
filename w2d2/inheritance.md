# Inheritance
## Goals

* Know how to extend a class.
* Know how to override a method.
* Know how to call the original method.

## Extending Classes
Inheritance is a way to establish a subtype from an existing class in
order to reuse code. Let's look at an example:

```ruby
class User
  attr_reader :first_name, :last_name

  def initialize(first_name, last_name)
    @first_name, @last_name = first_name, last_name
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def upvote_article(article)
    article.upvotes += 1
  end
end

class SuperUser < User
  attr_reader :super_powers

  def initialize(first_name, last_name, super_powers)
    super(first_name, last_name)
    @super_powers = super_powers
  end

  def upvote_article(article)
    # extra votes
    article.upvotes += 3
  end

  def delete_user(user)
    return unless super_powers.include?(:user_deletion)

    # super user is authorized to delete user
    puts "Die, #{user.full_name}, die!"
  end
end
```

Here we use `<` to denote that the `SuperUser` class **inherits** from
the `User` class. That means that the `SuperUser` class gets all of
the methods of the `User` class. We say that `User` is the **parent
class** or **superclass**, and that `SuperUser` is the **child class**
or **subclass**. So we can write code like so:

```ruby
[13] pry(main)> load 'test.rb'
=> true
[14] pry(main)> u = User.new("Jamis", "Buck")
=> #<User:0x007f9ba9897d98 @first_name="Jamis", @last_name="Buck">
[15] pry(main)> u.full_name
=> "Jamis Buck"
[16] pry(main)> su = SuperUser.new("David", "Heinemeier Hansson", [:user_deletion])
=> #<SuperUser:0x007f9ba98e66c8
 @first_name="David",
 @last_name="Heinemeier Hansson",
 @super_powers=[:user_deletion]>
[17] pry(main)> su.full_name
=> "David Heinemeier Hansson"
[18] pry(main)> su.delete_user(u)
Die, Jamis Buck, die!
=> nil
```

`SuperUser` **overrides** some of `User`'s methods: `initialize` and
`upvote_article`. The definitions in `SuperUser` will be called
instead.

In the case of `initialize`, the `SuperUser` method will call the
original definition in `User`. This is done through the call of
`super`, which runs the parent class's version of the current method.

Calls to `super` are especially common when overriding `initialize`.

## Inheritance and Code Reuse

Inheritance has allowed us to avoid duplicating the methods that are
common to `User` and `SuperUser`. Here's another example:

```ruby
class Magazine
  attr_accessor :editor
end

class Book
  attr_accessor :editor
end
```

We see code being duplicated: a bad sign. We can use inheritance to
solve this problem like so:

```ruby
class Publication
  attr_accessor :editor
end

class Magazine < Publication
end

class Book < Publication
end
```

This is a toy example, but the more two classes have in common the
more it pays for them to share a single base class. This also makes it
easier to add new child classes later.

Of course, the `Magazine` and `Book` classes may have their own
methods in addition to the shared `editor` method.

## Calling a super method
When overriding a method, it is common to call the original
implementation. The most common method where this happens is
`initialize`:

```ruby
class Animal
  attr_reader :species

  def initialize(species)
    @species = species
  end
end

class Human < Animal
  attr_reader :name

  def initialize(name)
    @name = name
  end
end
```

Uh-oh! When we call `Human.new`, this won't set the species! Let's fix
that:

```ruby
class Human < Animal
  attr_reader :name

  def initialize(name)
    # super calls the original definition of the method
    super("Human")
    @name = name
  end
end
```

## Exercises

Estimated time: 45min.

### Employee and Manager

Write a class `Employee` that has attributes that return the
employee's name, title, salary, and boss.

Write another class, `Manager`, that extends `Employee`. `Manager`
should have an attribute that holds an array of all employees assigned
to the manager. Note that managers can be assigned to higher level
managers, of course.

Add a method, `bonus(multiplier)` to `Employee`. Employees
should get a bonus like this

    bonus = employee salary * multiplier

Managers should get a bonus based on the salary of their whole team:

    bonus = (total salary of all employees and sub employees) * multiplier

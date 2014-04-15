# Privacy

### `public`, `private`, `protected`.

You may have seen the keywords `public`, `private`, and `protected` in
class definitions:

```ruby
class Cat
  public
  def meow
    puts "meow"
  end

  # access control gets set until another access control statement is
  # seen.
  def other_public_method
  end

  private
  def thoughts
    ...
  end

  protected
  def clean
    ...
  end
end
```

#### `public`

From [Ruby-Doc][ruby-doc-protected] (on Access Control):

> * *Public methods* can be called by anyone---there is no access
> control. Methods are public by default (except for initialize, which
> is always private).

Note that as `public` is the default access level for methods, so in the 
example from the last section we didn't have to specify that `#meow` 
was public.

#### `private`

> * *private methods* cannot be called with an explicit
> receiver. Because you cannot specify an object when using them,
> private methods can be called only in the defining class. [...]

Say we have some class with a private method `#private_thing`.

```ruby
class MyClass
   private
   def private_thing
      puts "Hello World"
   end

   public
   def explicit_receiver
      self.private_thing
   end

   def implicit_receiver
      private_thing
   end
end
```

What do you expect `#explicit_receiver` and `#implicit_receiver` to
do?

```
> thing = MyClass.new
 => #<MyClass:0x007fe2612ccae0>
> thing.implicit_receiver
Hello World
 => nil

> thing.explicit_receiver
 NoMethodError: private method `private_thing' called for #<MyClass:0x007f9cfa064200>
```

So not even `self` is okay as the explicit receiver! 

Private methods are inherited as private. So if we say:

```
class MyOtherClass < MyClass
   def implicitly_inherited
      private_thing
   end
end
```

Then, in irb:

```
> thing2 = MyOtherClass.new
> thing2.implicitly_inherited
Hello World
 => nil
```

This differs somewhat from languages like C++/Java, where private
methods are inaccessible to subclasses.

#### `protected`

> * *Protected methods* can be invoked only by objects of the defining
> class and its subclasses. Access is kept within the family.

So protected methods can be called with an explicit receiver, so long
as the caller is of the same class.

```ruby
class Dog
  def initialize
    # dominance score is not explicitly observable
    @secret_dominance_score = rand
  end

  def dominates?(other_dog)
    self.secret_dominance_score > other_dog.secret_dominance_score
  end

  protected
  attr_reader :secret_dominance_score
end
```

This way members of the `Dog` class can access other dominance scores,
but they are secret to everyone outside the `Dog` class.

### Access controls are not about security

Note that these access modifiers are *not* for security. In fact,
they're super easy to subvert. Check it out:

```ruby
class Cat
  private
  def meow
    puts "meow"
  end
end

cat = Cat.new
cat.send(:meow) # => prints meow!
```

We'll cover `#send` another day; but for now you should know that 
it allows you to pass in a symbol (or string) and call a method 
with that name. In particular, it ignores privacy levels.

Instead of security, you should be using access controls to describe 
to other programmers reading your code:

0. What methods are the "interface" that they'll want to use, and what
   are underlying details they may wish to ignore.
1. What methods are "supported" and public, and which ones are liable
   to change. Private methods, because they usually are focused on
   internal details, often are removed or changed as the code
   grows. There is typically a greater effort to continue to support
   and not break the existing public interface.

[ruby-doc-protected]: http://www.ruby-doc.org/docs/ProgrammingRuby/html/tut_classes.html#S4

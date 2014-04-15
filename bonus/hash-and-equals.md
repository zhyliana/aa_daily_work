# Equality in Ruby

Here is a quick overview of the different equality operators in Ruby.

## `#==` (Value Equality)

This is the most fundamental check for equality, it checks if two
objects have the same value.

In classes that you write, `#==` is inherited from the Object
class. By default, it will return true iff the two objects are
literally the same object (pointer equality). This default behavior is
not particularly helpful, so you should override it. 

This is your chance as the class author to decide what it means 
for two objects to have the same value.


## `#eql?` (Hash Equality)

Like `#==`, `#eql?` assesses general equality. Unlike most implementations of `#==`, 
`#eql` uses the objects' `#hash` method to assess equality. So `a.eql? b` is 
equivalent to `a.hash == b.hash`.

If you would like to provide a meaningful `#eql?` method for your classes, 
you will need to override the `#hash` method.

As an example of "meaningful" `#eql?` methods `#==` performs
type conversion amongst numerics (_e.g._ `Float` to `Integer`), 
but `#eql?` does not.

```ruby
   3.0 == 3 #=> true
   3.0.eql? 3 #=> false
```

This is because `Float#hash` and `Integer#hash` are not the same.

Now that you know that `#eql?` is used by `Hash` to check if an object
is a key in a hash, you should not be surprised by this _gotcha_:

```ruby
some_hash = { 3 => 'the third' }
some_hash[3.0] #=> nil
some_hash[3] #=> 'the third'
```

As an exercise for the reader, I suggest playing with using
Arrays and Hashes as the keys to a Hash, and seeing what happens when
you modify the keys. See below:

```ruby
some_array = [1]
some_hash = { some_array => 'secrets' }
some_array << 2
some_hash[some_array] #=> ???
```

## `#equal?` (Identity Equality)

`#equal?` does simple identity comparison (pointer comparison).
_i.e._ `a.equal? b` if and only if `a` is the same object as `b`. This
is identical to the default behavior of `#==` in the `Object` class.

```ruby
class Dog
   # ...
end

a = Dog.new
b = Dog.new
a = c

a.equal? b #=> false
a.equal? c #=> true
```

`#equal?` should _never_ be overridden.

## `#===` (Case Equality)

`#===` has the same behavior as `#==` for most classes 
(and by default for classes that you write). This is the 
method that `case` uses to determine which block to execute.

```ruby
case a
when b
   # ...
when c
   # ...
else
   # ...
end
```

Is equivalent to:

```
if b === a # triple equals!
   # ...
elsif c === a
   # ...
else
   # ...
end
```

I encourage you to override `#===` if you want to add advanced
`case`/`when` behavior to your class.  As an example, `Integer#===`
checks to see if the argument is of type Integer ( `Integer === 3 #=>
true`). So you can do this:
```ruby
case number
when Integer
   # ...
when Float
   # ...
end
```

Also, check out what you can do with `Regexp#===` (from this
[StackOverflow post][regex-case])

```ruby
tracking_service = case number
   when /^.Z/ then :ups
   when /^Q/ then :dhl
   when /^96.{20}$/ then :fedex
   when /^[HK].{10}$/ then :ups
end
```
## Further Reading
The interested student should read more about them in the
[`Object` documentation][object-doc], and in this awesome
[_Stack Overflow_ post][so-equality].

[so-equality]: http://stackoverflow.com/a/7157051
[object-doc]: http://ruby-doc.org/core-2.0/Object.html
[regex-case]: http://stackoverflow.com/a/1735777

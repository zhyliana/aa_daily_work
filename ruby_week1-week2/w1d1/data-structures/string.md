# Strings

## Goals

* Familiarize yourself with the selected, important methods here.
* Know how to use string interpolation and to prefer it to
  concatenation.

## Quotes

Strings are how we represent text in Ruby. We need to protect the text
from the Ruby interpreter so it doesn't think our text is actually
code:

```ruby
> these are some words
NameError: undefined local variable or method `words' for main:Object
        from (irb):6
        from /Users/ruggeri/.rvm/rubies/ruby-1.9.3-p194/bin/irb:16:in `<main>'
```

Uh oh.

```ruby
> "these are some words"
 => "these are some words"
```

Better. We protect text with quotes. You may use either single or
double quotes:

```ruby
'letters' == "letters" # => true
```

When to use which? If your text includes a quotation mark, you may
want to use the opposite form of quotes:

```ruby
'"Yesterday" has been covered >2,200 times'
"I didn't know that!"
```

## Multiline and Complex Quotes

One of the issues with quotes (both of the single and double variety)
is that they can make for some unwieldy code for other programmers to
read and maintain.

Two problems usually come hand in hand for complex blocks of text:
* They may be large, spanning multiple lines
* They may contain specific spacing, inner quotes, and escape
  characters

```ruby
stomach_contents = "Bacon 'ipsum dolor' sit amet venison\n fatback pig, prosciutto/pork belly jowl.\n
Beef kielbasa leberkas, shank t-bone doner strip "steak" pork loin. Doner hamburger"
```

Yikes! The example above won't compute properly.

We've placed double quotes around steak and double quotes around the
entire string.  Ruby inteprets this as two strings separated by an
undefined variable, steak.

Let's say we try single quotes to get the "steak" back in there.

```ruby
stomach_contents = 'Bacon 'ipsum dolor' sit amet venison\n fatback pig, prosciutto pork belly jowl.\n
Beef kielbasa leberkas, shank t-bone doner strip "steak" pork loin. Doner hamburger'
```

Now we're getting bit by 'ipsum dolor'.  Notice also, that, having
enclosed the string in single quotes, we can no longer access escape
characters.  The `\n` will be interpreted as just that, and not a
newline as we intend.

These are common problems with complex strings! Not to fret; there are
several solutions.

One classic way to handle ` " ` and ` ' ` and ` \ ` within strings is
to make a double quoted string and use ` \ ` as an escape character.
Ex: ` "\"Pigs\" is double quoted, and this is a backslash \\" ` will
print:

    "Pigs" is double quoted, and this is a backslash \

## Interpolation

It is very common to build up strings from other strings.

```ruby
worst_day = "Monday"
"#{worst_day}s are the hardest."
# => "Mondays are the hardest."
```

This technique is called *string interpolation*. Inside the `#{}`, you
place Ruby code; the code is executed, `#to_s` is called on the result
to turn it into the string, and the stringified result is inserted
into the containing string.

The code inside the `#{}` should be very short; just one variable plus
maybe a single method call; that keeps things easy to read and
understand. Otherwise, first save the result in a temporary variable,
then interpolate that:

```ruby
murder = "redrum".reverse.upcase
"#{murder}! #{murder}!"
```

String interpolation can only be done with double quotes (""), and
doesn't work with single quotes (''). For this reason, as well as
because single quotes don't support as many
[escape sequences][wiki-escape-seq], double quotes are the preferred
default.

[wiki-escape-seq]: http://en.wikibooks.org/wiki/Ruby_Programming/Strings#Escape_sequences

## Concatenating and appending to strings

Interpolation is usually the idiomatic, clean way to build up
strings. Sometimes you'll want more power. Strings have methods that
correspond to array's `<<` and `+` methods: For example:

```ruby
likes = "race cars, lasers, aeroplanes"
dislikes = "harmonicas"

"I like " + likes + ". I don't like " + dislikes + "."
# => "I like race cars, lasers, aeroplanes. I don't like harmonicas."
```

You'd probably prefer string interpolation here, but concatenation is
an option. And not true: harmonicas are cool.

As with arrays, it's common to want to grow strings by appending to
them. You could do this like so:

```ruby
count_in = ""
count_in = count_in + "One, "
count_in = count_in + "two, "
# ...
```

It is preferred to use the shovel (`<<`) operator for this. This will
avoid the creating new strings and instead will modify the original.

```ruby
count_in = ""
count_in << "One, "
count_in << "two, "
# ...
```

## Accessing a substring

You can access substrings of a string much like you can access
subarrays of an array.

```ruby
"this is my sentence"[5, 2]
# => "is"
```

Here five is the starting position of the substring, and two is the
substring's length. As with arrays, you may also pass a range of
indexes.

```ruby
"this is my sentence"[5..6]
# => "is"
```

## Length

To count the number of characters in a string, use the `length`
method:

```ruby
"words words words".length
# => 17
```

## Split a string into parts

It is common to want to split a string into an array of parts. For
instance:

```ruby
ice_creams = "Bi-Rite, Humphrey Slocum, Mitchell's"
ice_creams.split(", ")
#=> ["Bi-Rite", "Humphrey Slocum", "Mitchell's"]

[1] pry(main)> motto = "We all scream for ice cream!"
=> "We all scream for ice cream!"
[2] pry(main)> motto.split(" ")
=> ["We", "all", "scream", "for", "ice", "cream!"]
```

## Nil converts to empty string

```ruby
nil.to_s
=> ""
```

## Other Killer `String` Methods

Read up on 'em all:

* [`#chomp`][chomp-doc]/[`#strip`][strip-doc]
* [`#gsub`][gsub-doc]
* [`#downcase`][downcase-doc]/[`#upcase`][upcase-doc]
* [`#to_i`][to_i-doc]
* [`#to_sym`][to_sym-doc]
* [`#*`][times-doc]

[chomp-doc]: http://www.ruby-doc.org/core-1.9.3/String.html#method-i-chomp
[strip-doc]: http://www.ruby-doc.org/core-1.9.3/String.html#method-i-strip
[gsub-doc]: http://www.ruby-doc.org/core-1.9.3/String.html#method-i-gsub
[downcase-doc]: http://www.ruby-doc.org/core-1.9.3/String.html#method-i-downcase
[upcase-doc]: http://www.ruby-doc.org/core-1.9.3/String.html#method-i-upcase
[to_i-doc]: http://www.ruby-doc.org/core-1.9.3/String.html#method-i-to_i
[to_sym-doc]: http://www.ruby-doc.org/core-1.9.3/String.html#method-i-to_sym
[times-doc]: http://www.ruby-doc.org/core-1.9.3/String.html#method-i-2A

## Exercises

Estimated time: 1hr

### Your own `to_s` method

In this exercise, you will define a method `num_to_s(num, base)`,
which will return a string representing the original number in a
different base (up to base 16). **Do not use the built in
`#to_s(base)`**.

To refresh your memory, a few common base systems:

|Base 10 (decimal)     |0|1|2|3|...|9|10|11|12|13|14|15
|----------------------|---|---|---|---|---|---|---|---|---|---|---|---|
|Base 2 (binary)       |0|1|10|11|...|1001|1010|1011|1100|1101|1110|1111|
|Base 16 (hexadecimal) |0|1|2|3|...|9|A|B|C|D|E|F|

Examples of strings `num_to_s(num, base)` should produce:

```ruby
num_to_s(5, 10) #=> "5"
num_to_s(5, 2)  #=> "101"
num_to_s(5, 16) #=> "5"

num_to_s(234, 10) #=> "234"
num_to_s(234, 2)  #=> "11101010"
num_to_s(234, 16) #=> "EA"
```

Here's a more concrete example of how your method might arrive at the
conversions above:

```ruby
num_to_s(234, 10) #=> "234"
(234 / 1)   % 10  #=> 4
(234 / 10)  % 10  #=> 3
(234 / 100) % 10  #=> 2
                      ^

num_to_s(234, 2) #=> "11101010"
(234 / 1)   % 2  #=> 0
(234 / 2)   % 2  #=> 1
(234 / 4)   % 2  #=> 0
(234 / 8)   % 2  #=> 1
(234 / 16)  % 2  #=> 0
(234 / 32)  % 2  #=> 1
(234 / 64)  % 2  #=> 1
(234 / 128) % 2  #=> 1
                     ^
```

The general idea is to each time divide by a greater power of `base`
and then mod the result by `base` to get the next digit. Continue until
`num / (base ** pow) == 0`.

You'll get each digit as a number; you need to turn it into a
character. Make a `Hash` where the keys are digit numbers (up to and
including 15) and the values are the characters to use (up to and
including `F`).

### Caesar cipher

* Implement a
  [Caesar cipher](http://en.wikipedia.org/wiki/Caesar_cipher).
  Example: `caesar("hello", 3) # => "khoor"`
* Assume the text is all lower case letters.
* You'll probably want to map letters to numbers (so you can shift
  them). You could do this mapping yourself, but you will want to use
  the [ASCII codes][wiki-ascii], which are accessible through
  `String#ord` or `String#each_byte`. To convert back from an ASCII
  code number to a character, use `Fixnum#chr`.
* Important point: ASCII codes are all consecutive!
    * In particular, `"b".ord - "a".ord == 1`.
* Lastly, be careful of the letters at the end of the alphabet, like
  `"z"`!

## Resources

* http://www.ruby-doc.org/core-1.9.3/String.html

[wiki-ascii]: http://en.wikipedia.org/wiki/Ascii

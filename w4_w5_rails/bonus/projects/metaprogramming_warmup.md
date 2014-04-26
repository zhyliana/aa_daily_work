# Metaprogramming Warmup
------------------------

Alright, you've learned the basics of metaprogramming. Let's do some stretches before we tackle ActiveRecord Lite.

```
class Goofy
  private
  def say_hello
    puts 'Huh huh, hey evaray-body!'
  end
```

Man, I really want Goofy to say hello but I can't seem to do it.

```
>> Goofy.new.say_hello
NoMethodError: private method `say_hello' called for #<Goofy:0x007f8d991cfa10>
```

* **Please use your awesome metaprogramming knowledge to   
   make a new Goofy object `#say_hello`.**

Ah, thank you, that was music to my ears.

---------------------------------------------------------

There are a few more things that I want Goofy to do. He's previously been defined with some other methods. I have an array of symbols with the method names. Please make him do this stuff.

* **Write a method `#do_some_stuff` in the `Goofy` class that takes an array of symbols and calls the methods on the instance.**
   
Awesome, thanks for that too.

---------------------------------------------------------

Okay, Goofy doesn't know how to laugh. I know, crazy. Please teach him to laugh. I have the info you need:

```
[:laugh, 'Ah-hyuck!']
```

* **Open up the Goofy class and add a method `::teach_goofy_to_say_something` that takes an array and defines a method on the Goofy class whose name should be the first argument and that `puts` the second argument. (So, in this case, I should be able to call Goofy.new.laugh and see `'Ah-hyuck!'`)**

---------------------------------------------------------

Alright, now I need Goofy to do more stuff that he just doesn't know how to do yet. I have an array of stuff I want him to do:

```
[
 [:say_goodbye, "Buh-bye evaray-body!"], 
 [:go_crazy, "AAAHHHHHHHHHHHHHHHHH!!!!!"], 
 [:be_goofy, 'Gawrsh!']
]
```

* **Reuse you `::teach_goofy_to_say_something` method to create all these methods.**

---------------------------------------------------------

Great. Now that Goofy can do so much stuff, I want a bunch of him so I can put him all around the world to take people's money - I mean, bring joy to the world. But, I need to know how many Goofy's I have out there.

* **Please overrride Goofy's `self.new` method and do what you need to do to keep a count of every Goofy that's created.**

---------------------------------------------------------

Wow. Just wow. I'm so proud. You're all warmed up. Get out there and `send`, `define_method`, and class instance variable the hell out of `ActiveRecord Lite`.

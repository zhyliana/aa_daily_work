# Debugging Rails

Congratulations, you are at a stage where you can write a Rails application, but you aren't ready just yet to leave into the big scary world. 
You aren't going to have your amazing TA to help you when working in a job (I've heard that TA named Dylan is exceptionally good) and so it's time to learn how to properly debug your Rails app so that you can party with the big ~~boys~~ persons.

### Before we start

Bugs happen, don't be afraid of trying something because you are scared it might not work. Part of being a programmer is having some crazy idea and just giving it a shot to see if it works. That is also why you have Git at your disposal, remember to use Git as a safety net that WILL save you if you ever mess up really badly.

### Google is your friend
When it comes to Rails, chances are that someone has asked the exact same question as you before. StackOverflow will generally have a question related to yours on it. Be sure to get into the habit of googling when something goes wrong or you don't know something. Your TA is always happy to help, but when you leave AppAcademy, your TA won't be there for you. Part of being a good developer is knowing how to find the answers yourself.

## Debugging Models

Models are tucked away from you and aren't openly exposed through a UI like views and controllers are. So it may be a little more difficult at times to work out if something is going wrong in your model. However this is where error messages will become your friend. Look out for things that relate to your models such as:

  * Unknown attribute XYZ
  * Undefined method ABC for XYZ

Models behave fairly similarly to classes that you would have written in the first few weeks of App Academy. Why? Because they are classes themselves, just with extra Rails functionality built into them. 
Therefore to debug them, we make use of our good friend: the Ruby debugger. 

In your gemfile, you will see the lines:
```ruby
# To use debugger
# gem 'debugger'
```

Uncomment the `gem 'debugger'` line

If you need a refresher on Debugger, be sure to have a look over the previous readings: 
https://github.com/appacademy/ruby-curriculum/blob/master/w1d1/debugging/debugger.md

You can also type

```ruby
(rdb: 1) help
``` 
inside of the ruby debugger to get a list of commands that are available for use. 

## Debugging Controllers

So now you can debug your models like a pro, but that's only 1/3 of the battle. Being able to debug your controllers is a crucial skill and one that you should make sure that you are comfortable with. 

It's important that you can realize when something is going wrong in your controller, for example maybe an object isn't being created properly from your params or you aren't being sent the right params in the first place.

In order to debug our controllers, we are going to start using these two gems:
```ruby
# Gemfile
group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
end

# It's important that these go in a development group. If you have these available in production mode, then when you launch your site, if an error occurs, users will have access to your code and be able to do things like User.destroy_all
```
Better Errors will make your error pages a lot nicer to read, you will be able to get stack traces as well as see useful information such as params. 
(Note that Better Errors causes issues with RSpec, and you should probably not use it during assessments.)

<img src="https://a248.e.akamai.net/camo.github.com/f05d967fb90cbe3e686ad794062c2151f7ee19a5/687474703a2f2f692e696d6775722e636f6d2f7a594f58462e706e67">

Binding of caller is quite a complex gem, all you need to know is that it will allow you to have an interactive REPL inside of your better_error pages. This is very useful for inspecting values that you have assigned and testing your code as it runs.

Also, new rule from now on. Your TA is going to ignore your request for help if you have not used better_errors and binding_of_caller and have attempted to debug your code yourself.

<b>Using Better Errors</b>

So better errors is going to open up whenever our code throws an exception of some sort. However what happens if our code isn't throwing an error, but doesn't work the way that we want it to?

Well luckily our controllers have a method called `fail`. By typing fail in a controller, it basically pauses your code at that point and will open up better errors. EG:

```ruby
# ~/app/controllers/posts_controller.rb

class PostsController < ApplicationController
  
  def create
    @post = Post.new(params[:id])
    fail
    
    if @post.save
      redirect_to @post
    else
      flash[:errors] ||= []
      flash[:errors] << @post.errors.full_messages.to_sentence
      render :new
    end
  end
end
```

With this fail, our code will stop just after `@post = Post.new(params[:id])`, we can now do things like `p @post` and try to save it manually to see what's going wrong with our code. 

Using `fail` is very useful and is something you should do often. It will allow you to step into your controller as it runs and make sure things like params are coming in correctly.

<b>Useful things to do inside of a controller when debugging</b>
* Check what the params are
* Try @object.save. If it returns false then call @object.valid? And check @object.errors.full_messages. This will allow you to see what validations are failing.
* Make sure things like current_user are working. 
* Make sure instance variables are set correctly. 
* Check that you have called `permit` on the params when building objects.
* Check that objects being built via associations are built correctly. EG: `current_user.posts.new(post_params)`


## Debugging Views

It's time to learn about debugging the third layer of our Rails application, our views.

Views are generally harder to debug. This is because there typically should be no logic in the view and thus any problems are most likely caused by small syntax issues. 

TODO:
 * Add view debugging => Chrome debugger
 * Linters
    
    
    

# Goal Setter App

## Goals
 * Know how to write integration tests using Capybara and RSpec.
 * Know what and when to test.
 * Understand how to test *behavior* rather than *implementation*.
 * Learn to develop one feature at a time (the 'slices' approach).
 * Understand that capybara testing is agnostic of implementation.
 * Recognize how `concerns` and `polymorphic associations` can
   _dry_ up your code.
 
## Set Up
 
Remember to set up your app to use RSpec and Capybara.  
(See the [Rspec Setup][rspec-setup] and [Capybara][capybara] readings.)

Also, pick a name for your app that is not "goal" or "goals", or anything else
that will cause a conflict with a model class name.

*You MUST use git* from the beginning with this project.  This means 
`git init` right away, remember to set the `git config user.name` to 
both partner names, and commit regularly.

Feel free to consult the [reading on git][git-reading].

Git Tip: To add all changes, use `git add -A`.  Prefer this to other methods for adding all changes.
Reading [here][git-add].

[git-reading]: https://github.com/appacademy/ruby-curriculum/blob/master/w1d6-w1d7/git-summary.md
[git-add]: https://github.com/appacademy/ruby-curriculum/blob/master/w1d6-w1d7/git-add.md

## Phase I: User Creation & Login
 
 1. Write integration tests for just this feature. (Tests should fail at beginning.)

Here is an outline to get you started for the Authentication integration tests:

```ruby
# spec/features/auth_spec.rb

require 'spec_helper'

feature "the signup process" do 

  it "has a new user page"

  feature "signing up a user" do

    it "shows username on the homepage after signup"

  end

end

feature "logging in" do 

  it "shows username on the homepage after login"

end

feature "logging out" do 
  
  it "begins with logged out state"

  it "doesn't show username on the homepage after logout"

end

```

Fill in the missing test logic.

 2. Implement the feature, and make the tests pass. Write model
    tests as necessary as you build out the feature.

 3. Refactor any obvious bugs or flaws which remain.
 
This is the 'Red, Green, Refactor' approach.

[rspec-setup]: ../w5d4/rspec-and-rails-setup.md
[capybara]: ../w5d5/capybara-integration.md
 
## Phase II: Goals

 1. Start with the integration tests for the 'goals' feature.
 Users should be able to CRUD (create, read, update, and delete)
 their goals.  Goals can be private or public - other users should not
 see 'private' goals, but a user should see all of their own goals.

 2. Implement the feature: red to green!
 
 3. Think of a way for the user to keep track of which goals are completed.
 When writing a test for this, focus on testing the behavior rather than the feature.
 In this case, that means your test should work if the user can track their
 goal completion, regardless of how the code behind that feature works.
 
## Phase III: Comment ALL the things!

### Make the tests!
In this phase we are going to add functionality for a user to add comments.
Imagine all the helpful words of encouragement that other users could add to a goal.
Ok, now here's the crazy part. We _also_ want to be able to comment on users.
This way a user's show page will have comments and each goal will also have comments.

Do **NOT** implement any of these features until you have capybara tests for everything.
Make sure the tests cover comments on the User's show page and also on the goals.

We are going to implement this feature using two different strategies and see that
both pass the tests successfully.

When you are sure that your tests are in place, continue on to the next step.

### Branch the branch, implement using two tables
Make a new git branch and check it out using git. `git checkout -b comment_two_table`.
Now you are on the `comment_two_table` branch.

In this branch we will implement the comments using two different tables, `UserComment`
and `GoalComment`. When the tests go green it is time to commit all of our changes
and **switch back to the master branch** `git checkout master`. Do NOT delete
this branch!

Now we are back on the `master` branch and our changes are safely stored on the
other branch. Let's make yet **another** branch. `git checkout -b polymorphic-comments`.
Now we have all the same content as the master branch but are safely on a different
branch. 

### Polymorphic associations and concerns!
On this branch we are going to use _polymorphic associations_ and _concerns_. Sounds
bad ass, right? Indeed.

Polymorphic associations allow us to let two different models _share_ an association.
Specifically, `User`s and `Goal`s will both refer to the same `Comment` model.

This is nothing to be intimidated by, it only requires a few extra lines of code
and a couple extra columns in the `comments` table. 

Please review [this reading][poly-reading] on polymorphic associations before
moving on.

[poly-reading]: http://guides.rubyonrails.org/association_basics.html#polymorphic-associations

When you have a good idea of what you will need to continue, go ahead and create
this new model. Before you associate your models think about which associations
you would need. Both `User` and `Goal` will `has_many` `comments`. It wouldn't 
be very _dry_ to write identical code for both cases. We can use **Concerns** to
_dry_ our code out. 

Please read [this reading][concerns-reading] before moving on and creating your
`Commentable` concen.

[concerns-reading]: http://signalvnoise.com/posts/3372-put-chubby-models-on-a-diet-with-concerns

When the tests go green you can pat yourself on the back for successfully 
solving a problem using two different strategies. Rspec and capybara give us the 
comfort and security of knowing that although things have changed beneath the hood,
the presentation is identical because **the tests are still green**. Isn't this
a nice feeling?

Now, let's merge a branch back to the master so our main branch can include
our wonderful new feature. Pick your favorite of the two. Leave the other to
die a lonely death in the valley of unloved branches.
 
How to merge the branch:

```
$ git branch
=> lists all branches
$ git checkout "master"
$ git merge "branch_name_here"

```
 
## Bonus

 * Cheers: Users can give cheers for the goals of other users, 
  and they have a set number of cheers to award.
 * Leaderboards (whose goals have the most cheers?)
 * Go back and add integration tests to previous day's project
 
[railsguides-polymorph-assoc]: http://guides.rubyonrails.org/v3.2.14/association_basics.html#polymorphic-associations

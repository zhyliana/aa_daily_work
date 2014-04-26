# Drills

## Question 1.

For **each** of the associations in the following scenarios, specify
the **:class_name, :primary_key, and :foreign_key** that would be
generated **by default**. For the :primary_key and :foreign_key,
please specify **which table** Rails will look for them in.

NB: some of these associations are not set up properly yet; we'll fix
them in Question 2.

#### Scenario 1
```
class User
  has_many :posts
end
```


#### Scenario 2
```
class User
  has_many :posts
end

class Post
  belongs_to :user
end
```

#### Scenario 3
```
class User
  has_many :writings
end

class Post
  belongs_to :author
end
```

#### Scenario 4
```
class Spaceman
  has_many :minions
  has_many :planet_visits
  has_one :spaceship
  belongs_to :race
end
```

#### Scenario 5
```
 # Building on Scenario 4

class Minion
  belongs_to :overlord
end

class Visit
  belongs_to :visitor
  belongs_to :planet
end

class Spaceship
  belongs_to :owner
end

class Race
  has_many :people
end

class Planet
end

```


## Question 2.

Scenarios 3, 4, and 5 will not work as written. Please fix them so they work. **Do not change the name of any of the associations or write any new ones.** Use the options we've learned to make them work.

**Scenario 3**

* For the `has_many`, I want `Post` objects back 
* For the `belongs_to`, I want a `User` back

**Scenarios 4 & 5**

* On `Spaceman`:
	* For `planet_visits`, I want `Visit` objects back
* On `Minion` & `Visit` & `Spaceship` & `Race`:
	* For `overlord`/`visitor`/`owner`/`people`, I want `Spaceman` objects back


## Question 3.

For Scenarios 4 & 5 above, please write **a single association** so that I can call `Spaceman.first.visited_planets` and get an array of `Planet` objects back.


## Question 4.

```
class User
end

class Memberships
end

class Teams
end
```

Please write the necessary associations on the above models so that I can call the following methods:

* `User.first.my_teams`
* `Membership.first.team`
* `Membership.first.user`
* `Team.first.players`
* `Team.first.player_ids`


## Question 5.

```
class User
  has_many :posts
end

class Post
  belongs_to :user
end
```

There are 5 posts (with id's 1-5). All belong to the first User (user with id 1). 

I then run:

```
u = User.create(name: 'Jim')  # <= This user's id is 2
u.post_ids = [3, 4, 5]
```

1. Have any attributes changed?
2. If any attributes have changed, which attributes exactly?
3. Have any changes been persisted to the database?

## Question 6.

Oops. I didn't mean to assign the post with `id` 5 to the second
user. Set the user of that post back to the first user. Do not set the
`user_id` directly; use an association-generated helper method.

## Question 7.

```
class Team
  has_many :memberships
  has_many :users, through: :memberships
end

class Memberships
  belongs_to :team
  belongs_to :user
end

class User
  has_many :teams
end
```

This code is broken. Please fix it so that I can call `User.first.team_ids = [3, 4, 5]`.

Now that it's fixed, I call `User.first.team_ids = [3, 4, 5]`.

1. Has anything been changed in the database?
2. If anything, what exactly has changed in the database?


## Question 8.

```
class User
  has_many :posts
end

class Post
  belongs_to :user
  
  validates :user_id, presence: true
end
```

I call: 

```
u = User.new(name: 'Jim')
u.posts.build(title: 'My first post')
u.save
```
But it doesn't work. Please fix it.

## Question 9.

For each of the following scenarios, please write out the params that
would be generated. Note that some of these don't follow conventions.

#### Scenario 1

```
<input name='user[name]' value='Jim'></input>
<input name='user[password]' value='****'></input>
<input name='user[address][street]' value='1234 Cherry Lane'></input>
<input name='user[address][city]' value='San Francisco'></input>
<input name='user[address][state]' value='CA'></input>
```

#### Scenario 2

```
<input name='user[name]' value='Jim'></input>
<input name='user[name][supername]' value='Superman'></input>
<input name='post[body]' value='Hi'></input>
<input name='comment[title]' value='Bye'></input>
<input name='user[name]' value='Bob'></input>
```

#### Scenario 3

```
<input name='bob[patient_ids]' value='1'></input>
<input name='bob[patient_ids]' value='2'></input>
<input name='bob[patient_ids]' value='3'></input>
<input name='bob[patient_ids]' value='4'></input>
<input name='bob[patient_ids]' value='5'></input>
```

Also, what did the Rails application writer probably intend?

#### Scenario 4
```
<input name='bill[neverland][]' value='1'></input>
<input name='bill[neverland][]' value='2'></input>
<input name='bill[neverland][]' value='3'></input>
<input name='user_attributes[name]' value='Lalala'></input>
<input name='user_attributes[age]' value='5'></input>
```

#### Scenario 5
```
<input name='boom' value='1'></input>
<input name='aqualung[artist]' value='Jethro Tull'></input>
<input name='am_I_real' value='3'></input>
<input name='yes[no][actually_yes]' value='4'></input>
<input name='yes[no]' value='5'></input>
```

## Question 10.

Please write the correct `form` tag that will get me the desired
results for each scenario. NB: not all these examples make a lot of
sense.

1. post to 'http://www.google.com'
2. get to '/i-have-something-to-show-you'
3. post to '/users'
4. post to 'http://blahblah.com'
5. get to '/tolstoy-went-soft'

## Question 11.

Here is an `erb` form:

```
<%= form_for @user, url: '/people' do |f| %>
  <%= f.label :name, 'My Very Special Name' %>
  <%= f.text_field :name, class: 'super-name' %>
  <%= f.text_field :email %>
  <%= f.fields_for :posts do |post_f| %>
    <%= post_f.label :body %>
    <%= post_f.text_area :body %>
    <%= post_f.label :title %>
    <%= post_f.text_field :title %>
  <% end %>
<% end %>
```

1. Write the HTML that it generates.
2. Write out how Rails will interpret the uploaded params.

## Question 12.

Once the form in the previous question submits, it comes to the
following controller:

```
class UsersController
  def create
    @user = User.create(params[:user])
  end
  
  def new
    # what goes here?
  end
end
```

Here is the model currently:

```
class User
  attr_accessible :name, :email
  
  has_many :posts
end

class Post
  attr_accessible :body, :title
  
  validate :body, :title, :author_id, :presence => true
end
```

0. One-by-one, list the attributes that will be mass-assigned.
1. Does this work as is? Why or why not?
2. If not, fix it.

## Question 13.

A user `has_many :projects`. Please alter the form in Question 11 to
display checkboxes for all the `Project`s so that the user may select
which ones he wants to sign up for.

1. Do the erb version.
2. Do the HTML version. 
3. Update how your params hash comes in.

## Question 14.

Now, let's say the controller action we have remains exactly the same. 

1. Will the controller action work as expected? Why or why not?
2. If not, what do you need to change for it to work (exact code you need)?
